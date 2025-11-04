-- =============================================
-- SCD1 and SCD2 Change Simulation Script
-- Simplified: One SCD1 and one SCD2 column per table
-- =============================================

-- Enable explicit transactions for safety
DROP PROCEDURE IF EXISTS metadata.Inject_SCD_Changes
GO
CREATE PROCEDURE metadata.Inject_SCD_Changes
    @ETL_RUN_Date datetime2(3)
AS BEGIN
BEGIN TRANSACTION;

BEGIN TRY
    -- Create temp tables to track changed records
    CREATE TABLE #ChangedCustomers (CustomerID INT, ChangeType VARCHAR(10));
    CREATE TABLE #ChangedProducts (ProductID INT, ChangeType VARCHAR(10));
    CREATE TABLE #ChangedSalesPeople (BusinessEntityID INT, ChangeType VARCHAR(10));

    -- =============================================
    -- 1. DIMCUSTOMER SCD CHANGES
    -- =============================================
    
    -- First identify customers for SCD1 changes
    INSERT INTO #ChangedCustomers (CustomerID, ChangeType)
    SELECT 
        c.CustomerID,
        'SCD1' AS ChangeType
    FROM AdvWrks2022_OLTP.Sales.Customer c
    WHERE ABS(CAST(BINARY_CHECKSUM(c.CustomerID, NEWID()) AS INT)) % 100 < 20;

    -- Apply SCD1 Changes - StoreName
    UPDATE s
    SET 
        s.Name = (SELECT TOP 1 s2.Name 
                 FROM AdvWrks2022_OLTP.Sales.Store s2 
                 WHERE s2.BusinessEntityID <> s.BusinessEntityID 
                 ORDER BY NEWID())
    FROM AdvWrks2022_OLTP.Sales.Store s
    INNER JOIN AdvWrks2022_OLTP.Sales.Customer c ON s.BusinessEntityID = c.PersonID
    INNER JOIN #ChangedCustomers cc ON c.CustomerID = cc.CustomerID
    WHERE cc.ChangeType = 'SCD1';

    -- Identify customers for SCD2 changes
    INSERT INTO #ChangedCustomers (CustomerID, ChangeType)
    SELECT 
        c.CustomerID,
        'SCD2' AS ChangeType
    FROM AdvWrks2022_OLTP.Sales.Customer c
    WHERE ABS(CAST(BINARY_CHECKSUM(c.CustomerID, NEWID()) AS INT)) % 100 BETWEEN 20 AND 39
    AND c.CustomerID NOT IN (SELECT CustomerID FROM #ChangedCustomers WHERE ChangeType = 'SCD1');

    -- Apply SCD2 Changes - FirstName
    UPDATE prs
    SET 
        prs.FirstName = (SELECT TOP 1 FirstName 
                        FROM AdvWrks2022_OLTP.Person.Person 
                        WHERE FirstName IS NOT NULL 
                          AND FirstName <> ISNULL(prs.FirstName, '') 
                        ORDER BY NEWID())
    FROM AdvWrks2022_OLTP.Person.Person prs
    INNER JOIN AdvWrks2022_OLTP.Sales.Customer c ON prs.BusinessEntityID = c.PersonID
    INNER JOIN #ChangedCustomers cc ON c.CustomerID = cc.CustomerID
    WHERE cc.ChangeType = 'SCD2';

    -- =============================================
    -- 2. DIMPRODUCT SCD CHANGES
    -- =============================================
    
    -- Identify products for SCD1 changes
    INSERT INTO #ChangedProducts (ProductID, ChangeType)
    SELECT 
        p.ProductID,
        'SCD1' AS ChangeType
    FROM AdvWrks2022_OLTP.Production.Product p
    WHERE ABS(CAST(BINARY_CHECKSUM(p.ProductID, NEWID()) AS INT)) % 100 < 20;

    -- Apply SCD1 Changes - DiscontinuedDate
    UPDATE p
    SET 
        p.DiscontinuedDate = CASE 
            WHEN p.DiscontinuedDate IS NULL THEN DATEADD(DAY, ABS(CAST(BINARY_CHECKSUM(p.ProductID, NEWID()) AS INT)) % 365, GETDATE())
            ELSE NULL
        END
    FROM AdvWrks2022_OLTP.Production.Product p
    INNER JOIN #ChangedProducts cp ON p.ProductID = cp.ProductID
    WHERE cp.ChangeType = 'SCD1';

    -- Identify products for SCD2 changes
    INSERT INTO #ChangedProducts (ProductID, ChangeType)
    SELECT 
        p.ProductID,
        'SCD2' AS ChangeType
    FROM AdvWrks2022_OLTP.Production.Product p
    WHERE ABS(CAST(BINARY_CHECKSUM(p.ProductID, NEWID()) AS INT)) % 100 BETWEEN 20 AND 39
    AND p.ProductID NOT IN (SELECT ProductID FROM #ChangedProducts WHERE ChangeType = 'SCD1');

    -- Apply SCD2 Changes - ListPrice
    UPDATE p
    SET 
        p.ListPrice = p.ListPrice * (0.8 + (RAND(CHECKSUM(NEWID())) * 0.4))
    FROM AdvWrks2022_OLTP.Production.Product p
    INNER JOIN #ChangedProducts cp ON p.ProductID = cp.ProductID
    WHERE cp.ChangeType = 'SCD2';

    -- =============================================
    -- 3. DIMSALESPERSON SCD CHANGES
    -- =============================================
    
    -- Identify salespeople for SCD1 changes
    INSERT INTO #ChangedSalesPeople (BusinessEntityID, ChangeType)
    SELECT 
        sp.BusinessEntityID,
        'SCD1' AS ChangeType
    FROM AdvWrks2022_OLTP.Sales.SalesPerson sp
    WHERE ABS(CAST(BINARY_CHECKSUM(sp.BusinessEntityID, NEWID()) AS INT)) % 100 < 20;

    -- Apply SCD1 Changes - JobTitle
    UPDATE em
    SET 
        em.JobTitle = (SELECT TOP 1 JobTitle 
                      FROM AdvWrks2022_OLTP.HumanResources.Employee 
                      WHERE JobTitle IS NOT NULL 
                        AND JobTitle <> ISNULL(em.JobTitle, '') 
                      ORDER BY NEWID())
    FROM AdvWrks2022_OLTP.HumanResources.Employee em
    INNER JOIN #ChangedSalesPeople csp ON em.BusinessEntityID = csp.BusinessEntityID
    WHERE csp.ChangeType = 'SCD1';

    -- Identify salespeople for SCD2 changes
    INSERT INTO #ChangedSalesPeople (BusinessEntityID, ChangeType)
    SELECT 
        sp.BusinessEntityID,
        'SCD2' AS ChangeType
    FROM AdvWrks2022_OLTP.Sales.SalesPerson sp
    WHERE ABS(CAST(BINARY_CHECKSUM(sp.BusinessEntityID, NEWID()) AS INT)) % 100 BETWEEN 20 AND 39
    AND sp.BusinessEntityID NOT IN (SELECT BusinessEntityID FROM #ChangedSalesPeople WHERE ChangeType = 'SCD1');

    -- Apply SCD2 Changes - FirstName
    UPDATE prs
    SET 
        prs.FirstName = (SELECT TOP 1 FirstName 
                        FROM AdvWrks2022_OLTP.Person.Person 
                        WHERE FirstName IS NOT NULL 
                          AND FirstName <> ISNULL(prs.FirstName, '') 
                        ORDER BY NEWID())
    FROM AdvWrks2022_OLTP.Person.Person prs
    INNER JOIN #ChangedSalesPeople csp ON prs.BusinessEntityID = csp.BusinessEntityID
    WHERE csp.ChangeType = 'SCD2';

    -- =============================================
    -- UPDATE VALIDITY DATES FOR CHANGED RECORDS
    -- =============================================
    
    -- Update validity dates for changed Customer records
    UPDATE c
    SET 
        c.ValidityDate_Start = DATEADD(DAY, -ABS(CAST(BINARY_CHECKSUM(c.CustomerID, NEWID()) AS INT)) % 365, @ETL_RUN_Date),
        c.ValidityDate_End = DATEADD(DAY, ABS(CAST(BINARY_CHECKSUM(c.CustomerID, NEWID()) AS INT)) % 365, @ETL_RUN_Date)
    FROM AdvWrks2022_OLTP.Sales.Customer c
    INNER JOIN #ChangedCustomers cc ON c.CustomerID = cc.CustomerID;

    -- Update validity dates for changed Product records  
    UPDATE p
    SET 
        p.ValidityDate_Start = DATEADD(DAY, -ABS(CAST(BINARY_CHECKSUM(p.ProductID, NEWID()) AS INT)) % 365, @ETL_RUN_Date),
        p.ValidityDate_End = DATEADD(DAY, ABS(CAST(BINARY_CHECKSUM(p.ProductID, NEWID()) AS INT)) % 365, @ETL_RUN_Date)
    FROM AdvWrks2022_OLTP.Production.Product p
    INNER JOIN #ChangedProducts cp ON p.ProductID = cp.ProductID;

    -- Update validity dates for changed SalesPerson records
    UPDATE sp
    SET 
        sp.ValidityDate_Start = DATEADD(DAY, -ABS(CAST(BINARY_CHECKSUM(sp.BusinessEntityID, NEWID()) AS INT)) % 365, @ETL_RUN_Date),
        sp.ValidityDate_End = DATEADD(DAY, ABS(CAST(BINARY_CHECKSUM(sp.BusinessEntityID, NEWID()) AS INT)) % 365, @ETL_RUN_Date)
    FROM AdvWrks2022_OLTP.Sales.SalesPerson sp
    INNER JOIN #ChangedSalesPeople csp ON sp.BusinessEntityID = csp.BusinessEntityID;

    -- Clean up temp tables
    DROP TABLE #ChangedCustomers;
    DROP TABLE #ChangedProducts;
    DROP TABLE #ChangedSalesPeople;

    COMMIT TRANSACTION;
    
    PRINT 'SCD1 and SCD2 changes applied successfully:';
    PRINT '- Customer: StoreName (SCD1), FirstName (SCD2)';
    PRINT '- Product: DiscontinuedDate (SCD1), ListPrice (SCD2)';
    PRINT '- SalesPerson: JobTitle (SCD1), FirstName (SCD2)';
    PRINT '- 20% of records for each change type';
    PRINT '- Validity dates updated for all changed records';

END TRY
BEGIN CATCH
    -- Clean up temp tables in case of error
    IF OBJECT_ID('tempdb..#ChangedCustomers') IS NOT NULL DROP TABLE #ChangedCustomers;
    IF OBJECT_ID('tempdb..#ChangedProducts') IS NOT NULL DROP TABLE #ChangedProducts;
    IF OBJECT_ID('tempdb..#ChangedSalesPeople') IS NOT NULL DROP TABLE #ChangedSalesPeople;
    
    ROLLBACK TRANSACTION;
    
    PRINT 'Error occurred: ' + ERROR_MESSAGE();
    PRINT 'Changes rolled back.';
    
    THROW;
END CATCH;
END
GO
