------ 6.1. integration.Load_Updates_Address


drop procedure if exists integration.Load_Updates_Address;
go

create procedure integration.Load_Updates_Address
as
begin
    set nocount on;
    set xact_abort on;

    begin try
        begin transaction;
        
        ------------------------------------------------------------
        -- STEP 1: Handle SCD Type 2 (new and changed historical rows)
        ------------------------------------------------------------

        -- Mark current records as non-current if historical change detected
        update d
        set d.IsCurrent = 0
        from prod.DimAddress d
        inner join stg.Address_staging s
            on d.AddressID = s.AddressID
            and d.StateProvinceID = s.StateProvinceID
            and d.TerritoryID = s.TerritoryID
        where d.IsCurrent = 1
          and (
                d.AddressLine <> s.AddressLine
             or d.City <> s.City
             or d.PostalCode <> s.PostalCode
          );

        -- Insert new or changed (SCD2) records
        insert into prod.DimAddress
        (
            AddressID,
            StateProvinceID,
            TerritoryID,
            AddressLine,
            City,
            PostalCode,
            StateProvinceName,
            StateProvinceCode,
            TerritoryName,
            CountryRegionName,
            CountryRegionCode,
            TerritoryGroup,
            ValidityDate_Start,
            ValidityDate_End,
            IsCurrent
        )
        select
            s.AddressID,
            s.StateProvinceID,
            s.TerritoryID,
            s.AddressLine,
            s.City,
            s.PostalCode,
            s.StateProvinceName,
            s.StateProvinceCode,
            s.TerritoryName,
            s.CountryRegionName,
            s.CountryRegionCode,
            s.TerritoryGroup,
            s.ValidityDate_Start as ValidityDate_Start,
            s.ValidityDate_End as ValidityDate_End,
            1 as IsCurrent
        from stg.Address_staging s


       


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
