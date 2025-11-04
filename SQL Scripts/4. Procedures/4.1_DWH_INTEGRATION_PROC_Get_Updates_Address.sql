drop procedure if exists integration.Get_Updates_Address
go

create procedure integration.Get_Updates_Address
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
        truncate table stg.Address_staging;

        ------------------------------------------------------------
        -- STEP 2: Insert incremental updates directly into staging
        ------------------------------------------------------------
        insert into stg.Address_staging
        select
            ad.AddressID,
            spr.StateProvinceID,
            spr.TerritoryID,
            ad.AddressLine1,
            ad.City,
            ad.PostalCode,
            spr.Name as StateProvinceName,
            spr.StateProvinceCode,
            st.Name as TerritoryName,
            cr.Name as CountryRegionName,
            st.CountryRegionCode,
            st.[Group] as TerritoryGroup,
            ad.ValidityDate_Start,
            ad.ValidityDate_End
        
        from    AdvWrks2022_OLTP.Person.Address ad
        left join AdvWrks2022_OLTP.Person.StateProvince spr 
            on ad.StateProvinceID = spr.StateProvinceID
        left join AdvWrks2022_OLTP.Sales.SalesTerritory st 
            on spr.TerritoryID = st.TerritoryID
        left join AdvWrks2022_OLTP.Person.CountryRegion cr 
            on st.CountryRegionCode = cr.CountryRegionCode
        where 
            ad.ValidityDate_Start > coalesce (@ETL_CuttoffDate_prev,'01-01-2000') -- to select data that has not yet been loaded to DimTable since last load
            and 
            ad.ValidityDate_Start <= @ETL_CuttoffDate -- to select only data that validity have already started (no future) 
            and
            ad.ValidityDate_End > @ETL_CuttoffDate -- to select only data that is valid to the ETL date 
			


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
