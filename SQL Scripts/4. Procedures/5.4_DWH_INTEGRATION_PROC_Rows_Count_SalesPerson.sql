


------ 5.4. integration.Rows_Count_SalesPerson

drop procedure if exists integration.Rows_Count_SalesPerson;
go

create procedure integration.Rows_Count_SalesPerson
(
    @New_Rows_Count int output
    ,@SCD2_Rows_Count int output
    ,@SCD1_Rows_Count int output
)

as
begin
    set nocount on;
    set xact_abort on;

    begin try
        begin transaction;


        ------------------------------------------------------------
        -- STEP 3: Rows Count
        ------------------------------------------------------------


        -- New_Rows_Count
        select  @New_Rows_Count = count(*) 
        from stg.SalesPerson_staging s
            left join prod.DimSalesPerson d
             on d.SalesPersonID = s.SalesPersonID
             and d.PersonType = s.PersonType
        where d.SalesPersonID is null
  

        -- Count SCD2_Rows_Count
        select @SCD2_Rows_Count = count(*) 
        from stg.SalesPerson_staging s
            left join prod.DimSalesPerson d
            on d.SalesPersonID = s.SalesPersonID
            and d.PersonType = s.PersonType
         where
            d.FirstName <> s.FirstName
             or d.MiddleName <> s.MiddleName
             or d.LastName <> s.LastName
             or d.SalesQuota <> s.SalesQuota
             or d.Bonus <> s.Bonus
             or d.CommissionPct <> s.CommissionPct
     

          --- count SCD_1 rows
         select @SCD1_Rows_Count = count (*) 
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