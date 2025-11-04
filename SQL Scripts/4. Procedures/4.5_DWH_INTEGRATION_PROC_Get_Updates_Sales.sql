

drop procedure if exists integration.Get_Updates_Sales;
go

create procedure integration.Get_Updates_Sales
(
    @ETL_CuttoffDate datetime2(3),
    @ETL_CuttoffDate_prev    datetime2(3)
)
as
begin
    set nocount on;
    set xact_abort on;

    begin try
        begin transaction;

        ------------------------------------------------------------
        -- STEP 1: Optional cleanup of staging table
        ------------------------------------------------------------
        truncate table stg.Sales_staging;

        ------------------------------------------------------------
        -- STEP 2: Insert incremental updates directly into staging
        ------------------------------------------------------------
        insert into stg.Sales_staging
        select 
	        soh.	SalesOrderNumber	AS	SalesOrderNumber	---- Unique sales order identification number.
	        ,soh.	SalesOrderID		AS	SalesOrderID
	        ,sod.	SalesOrderDetailID	AS	SalesOrderDetailID
	        ,sod.	ProductID			AS	ProductID
	        ,soh.	CustomerID			AS	CustomerID
	        ,soh.	SalesPersonID		AS	SalesPersonID
	        ,sod.	SpecialOfferID		AS	SpecialOfferID
	        ,soh.	TerritoryID			AS	TerritoryID
	        ,soh.	ShipToAddressID		AS	ShipToAddressID
	        ,soh.	CurrencyRateID		AS	CurrencyRateID
	        ,soh.	OrderDate			AS	OrderDate	---- Dates the sales order was created.
	        ,soh.	DueDate				AS	DueDate	---- Date the order is due to the customer.
	        ,soh.	ShipDate			AS	ShipDate	---- Date the order was shipped to the customer.
	        ,soh.	Status				AS	Status	---- Order current status. 1 = In process; 2 = Approved; 3 = Backordered; 4 = Rejected; 5 = Shipped; 6 = Cancelled
	        ,soh.	OnlineOrderFlag		AS	OnlineOrderFlag	---- 0 = Order placed by sales person. 1 = Order placed online by customer.
	        ,soh.	SubTotal			AS	OrderSubTotal 
	        ,soh.	TaxAmt				AS	OrderTaxAmt
	        ,soh.	Freight				AS	OrderFreight
	        ,soh.	TotalDue			AS	OrderTotalDue
	        ,sod.	OrderQty			AS	LineOrderQty
	        ,sod.	UnitPrice			AS	UnitPrice
	        ,sod.	UnitPriceDiscount	AS	UnitPriceDiscount
	        ,sod.	LineTotal			AS	LineTotal
	        ,soh.	LastModifiedDate	AS	 LastModifiedDate


        from AdvWrks2022_OLTP.Sales.SalesOrderHeader soh
	        left join AdvWrks2022_OLTP.Sales.SalesOrderDetail sod on soh.SalesOrderID = sod.SalesOrderID
	
        where 
            soh.LastModifiedDate > coalesce (@ETL_CuttoffDate_prev,'01-01-2000') -- to select data that has not yet been loaded to DimTable since last load
            and 
            soh.LastModifiedDate <= @ETL_CuttoffDate -- to select only data that validity have already started (no future) 
     
    
		

        ------------------------------------------------------------
        -- STEP 3: Commit transaction
        ------------------------------------------------------------
        commit transaction;
    end try
    begin catch
        if @@TRANCOUNT > 0 rollback transaction;

        declare @ErrorMessage nvarchar(4000),
                @ErrorSeverity int,
                @ErrorState int;

        select
            @ErrorMessage = error_message(),
            @ErrorSeverity = error_severity(),
            @ErrorState = error_state();

        raiserror(@ErrorMessage, @ErrorSeverity, @ErrorState);
    end catch;
end;
go
