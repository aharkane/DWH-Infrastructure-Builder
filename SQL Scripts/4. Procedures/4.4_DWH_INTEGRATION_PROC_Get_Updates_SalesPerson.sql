


drop procedure if exists integration.Get_Updates_SalesPerson;
go

create procedure integration.Get_Updates_SalesPerson
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
        truncate table stg.SalesPerson_staging;

        ------------------------------------------------------------
        -- STEP 2: Insert incremental updates directly into staging
        ------------------------------------------------------------
        insert into stg.SalesPerson_staging
        select 
	        sp.	BusinessEntityID	AS	SalesPersonID
	        ,prs.	PersonType	AS	PersonType	---- Primary type of person: SC = Store Contact, IN = Individual (retail) customer, SP = Sales person, EM = Employee (non-sales), VC = Vendor contact, GC = General contact
	        ,prs.	Title	AS	Title
	        ,prs.	FirstName	AS	FirstName
	        ,prs.	MiddleName	AS	MiddleName
	        ,prs.	LastName	AS	LastName	
	        ,em.	OrganizationLevel	AS	OrganizationLevel	--- The depth of the employee in the corporate hierarchy.
	        ,em.	JobTitle	AS	JobTitle
	        ,sp.	SalesQuota	AS	SalesQuota	--- Projected yearly sales.
	        ,sp.	Bonus	AS	Bonus	--- Bonus due if quota is met.
	        ,sp.	CommissionPct	AS	CommissionPct	--- Commision percent received per sale.
	        ,sp.	TerritoryID	AS	TerritoryID
	        ,sp.	ValidityDate_Start	AS	ValidityDate_Start
	        ,sp.	ValidityDate_End	AS	ValidityDate_End

        from AdvWrks2022_OLTP.Sales.SalesPerson sp
	        left join AdvWrks2022_OLTP.HumanResources.Employee em on sp.BusinessEntityID = em.BusinessEntityID
	        left join AdvWrks2022_OLTP.Person.Person prs on prs.BusinessEntityID = em.BusinessEntityID
	
        where 
            sp.ValidityDate_Start > coalesce (@ETL_CuttoffDate_prev,'01-01-2000') -- to select data that has not yet been loaded to DimTable since last load
            and 
            sp.ValidityDate_Start <= @ETL_CuttoffDate -- to select only data that validity have already started (no future) 
            and
            sp.ValidityDate_End > @ETL_CuttoffDate -- to select only data that is valid to the ETL date 
			


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
