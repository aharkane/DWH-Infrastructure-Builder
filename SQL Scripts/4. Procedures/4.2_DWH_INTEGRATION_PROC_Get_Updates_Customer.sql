
drop procedure if exists integration.Get_Updates_Customer;
go

create procedure integration.Get_Updates_Customer
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
        truncate table stg.Customer_staging;

        ------------------------------------------------------------
        -- STEP 2: Insert incremental updates directly into staging
        ------------------------------------------------------------
        insert into stg.Customer_staging

        select
	        c.	CustomerID	AS	CustomerID 
	        ,c.	PersonID	AS	CustomerPersonID
	        ,c.	StoreID	AS	StoreID
	        ,s.	SalesPersonID	AS	SalesPersonID
	        ,c.	TerritoryID	AS	TerritoryID
	        ,prs.	PersonType	AS	PersonType	----Primary type of person: SC = Store Contact, IN = Individual (retail) customer, SP = Sales person, EM = Employee (non-sales), VC = Vendor contact, GC = General contact
	        ,prs.	Title	AS	Title
	        ,prs.	FirstName	AS	FirstName
	        ,prs.	MiddleName	AS	MiddleName
	        ,prs.	LastName	AS	LastName
	        ,s.	Name	AS	StoreName
	        ,st.	Name	AS	TerritoryName
	        ,cr.	Name	AS	CountryRegionName
	        ,st.	CountryRegionCode	AS	CountryRegionCode
	        ,st.	[Group]	AS	TerritoryGroup
	        ,c.	ValidityDate_Start	AS	ValidityDate_Start
	        ,c.	ValidityDate_End	AS	ValidityDate_End

        from AdvWrks2022_OLTP.Sales.Customer c
	        left join AdvWrks2022_OLTP.Person.Person prs on c.PersonID  = prs.BusinessEntityID	-- customer indentification
	        left join AdvWrks2022_OLTP.Sales.Store s on c.StoreID = s.BusinessEntityID		-- store identification
	        left join AdvWrks2022_OLTP.Sales.SalesTerritory st on st.TerritoryID = c.TerritoryID 
	        left join AdvWrks2022_OLTP.Person.CountryRegion cr on cr.CountryRegionCode = st.CountryRegionCode
	
        where 
            c.ValidityDate_Start > coalesce (@ETL_CuttoffDate_prev,'01-01-2000') -- to select data that has not yet been loaded to DimTable since last load
            and 
            c.ValidityDate_Start <= @ETL_CuttoffDate -- to select only data that validity have already started (no future) 
            and
            c.ValidityDate_End > @ETL_CuttoffDate -- to select only data that is valid to the ETL date 
			


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
