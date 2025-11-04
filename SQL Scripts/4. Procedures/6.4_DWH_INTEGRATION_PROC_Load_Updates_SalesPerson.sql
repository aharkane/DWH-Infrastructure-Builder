


------ 6.4. integration.Load_Updates_SalesPerson

drop procedure if exists integration.Load_Updates_SalesPerson;
go

create procedure integration.Load_Updates_SalesPerson

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
    from prod.DimSalesPerson d
    inner join stg.SalesPerson_staging s
        on d.SalesPersonID = s.SalesPersonID
        and d.PersonType = s.PersonType
    where d.IsCurrent = 1
      and (
            d.FirstName <> s.FirstName
         or d.MiddleName <> s.MiddleName
         or d.LastName <> s.LastName
         or d.SalesQuota <> s.SalesQuota
         or d.Bonus <> s.Bonus
         or d.CommissionPct <> s.CommissionPct
      );

    -- Insert new or changed (SCD2) records
    insert into prod.DimSalesPerson
    (
        SalesPersonID,
        PersonType,
        Title,
        FirstName,
        MiddleName,
        LastName,
        OrganizationLevel,
        JobTitle,
        SalesQuota,
        Bonus,
        CommissionPct,
        TerritoryID,
        ValidityDate_Start,
        ValidityDate_End,
        IsCurrent
    )
    select
        s.SalesPersonID,
        s.PersonType,
        s.Title,
        s.FirstName,
        s.MiddleName,
        s.LastName,
        s.OrganizationLevel,
        s.JobTitle,
        s.SalesQuota,
        s.Bonus,
        s.CommissionPct,
        s.TerritoryID,
        s.ValidityDate_Start,
        s.ValidityDate_End,
        1 as IsCurrent
    from stg.SalesPerson_staging s
    left join prod.DimSalesPerson d
        on d.SalesPersonID = s.SalesPersonID
        and d.PersonType = s.PersonType
    where d.SalesPersonID is null
       or (
            d.FirstName <> s.FirstName
         or d.MiddleName <> s.MiddleName
         or d.LastName <> s.LastName
         or d.SalesQuota <> s.SalesQuota
         or d.Bonus <> s.Bonus
         or d.CommissionPct <> s.CommissionPct
      );

    ------------------------------------------------------------
    -- STEP 2: Handle SCD Type 1 (non-historical attribute updates)
    ------------------------------------------------------------

    update d
    set d.Title              = s.Title,
        d.OrganizationLevel  = s.OrganizationLevel,
        d.JobTitle           = s.JobTitle,
        d.TerritoryID        = s.TerritoryID
    from prod.DimSalesPerson d
    inner join stg.SalesPerson_staging s
        on d.SalesPersonID = s.SalesPersonID
        and d.PersonType = s.PersonType
    where d.IsCurrent = 1
      and (
            d.Title <> s.Title
         or d.OrganizationLevel <> s.OrganizationLevel
         or d.JobTitle <> s.JobTitle
         or d.TerritoryID <> s.TerritoryID
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
end