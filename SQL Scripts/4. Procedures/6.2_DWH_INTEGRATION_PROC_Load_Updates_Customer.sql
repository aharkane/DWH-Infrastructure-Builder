
------ 6.2. integration.Load_Updates_Customer

drop procedure if exists integration.Load_Updates_Customer;
go

create procedure integration.Load_Updates_Customer

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
    from prod.DimCustomer d
    inner join stg.Customer_staging s
        on d.CustomerID = s.CustomerID
        and d.CustomerPersonID = s.CustomerPersonID
        and d.PersonType = s.PersonType
    where d.IsCurrent = 1
      and (
            d.FirstName <> s.FirstName
         or d.MiddleName <> s.MiddleName
         or d.LastName <> s.LastName
      );

    -- Insert new or changed (SCD2) records
    insert into prod.DimCustomer
    (
        CustomerID,
        CustomerPersonID,
        PersonType,
        StoreID,
        SalesPersonID,
        TerritoryID,
        Title,
        FirstName,
        MiddleName,
        LastName,
        StoreName,
        TerritoryName,
        CountryRegionName,
        CountryRegionCode,
        TerritoryGroup,
        ValidityDate_Start,
        ValidityDate_End,
        IsCurrent
    )
    select
        s.CustomerID,
        s.CustomerPersonID,
        s.PersonType,
        s.StoreID,
        s.SalesPersonID,
        s.TerritoryID,
        s.Title,
        s.FirstName,
        s.MiddleName,
        s.LastName,
        s.StoreName,
        s.TerritoryName,
        s.CountryRegionName,
        s.CountryRegionCode,
        s.TerritoryGroup,
        s.ValidityDate_Start as ValidityDate_Start,
        s.ValidityDate_End   as ValidityDate_End,
        1 as IsCurrent
    from stg.Customer_staging s
    left join prod.DimCustomer d
        on d.CustomerID = s.CustomerID
        and d.CustomerPersonID = s.CustomerPersonID
        and d.PersonType = s.PersonType
    where d.CustomerID is null
       or (
            d.FirstName <> s.FirstName
         or d.MiddleName <> s.MiddleName
         or d.LastName <> s.LastName
      );

    ------------------------------------------------------------
    -- STEP 2: Handle SCD Type 1 (non-historical attribute updates)
    ------------------------------------------------------------

    update d
    set d.StoreID            = s.StoreID,
        d.SalesPersonID      = s.SalesPersonID,
        d.TerritoryID        = s.TerritoryID,
        d.Title              = s.Title,
        d.StoreName          = s.StoreName,
        d.TerritoryName      = s.TerritoryName,
        d.CountryRegionName  = s.CountryRegionName,
        d.CountryRegionCode  = s.CountryRegionCode,
        d.TerritoryGroup     = s.TerritoryGroup
    from prod.DimCustomer d
    inner join stg.Customer_staging s
        on d.CustomerID = s.CustomerID
        and d.CustomerPersonID = s.CustomerPersonID
        and d.PersonType = s.PersonType
    where d.IsCurrent = 1
      and (
            d.StoreID <> s.StoreID
         or d.SalesPersonID <> s.SalesPersonID
         or d.TerritoryID <> s.TerritoryID
         or d.Title <> s.Title
         or d.StoreName <> s.StoreName
         or d.TerritoryName <> s.TerritoryName
         or d.CountryRegionName <> s.CountryRegionName
         or d.CountryRegionCode <> s.CountryRegionCode
         or d.TerritoryGroup <> s.TerritoryGroup
      );



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
