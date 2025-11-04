
------ 5.2. integration.Rows_Count_Customer

drop procedure if exists integration.Rows_Count_Customer;
go

create procedure integration.Rows_Count_Customer
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
        from stg.Customer_staging s
            left join prod.DimCustomer d
            on d.CustomerID = s.CustomerID
            and d.CustomerPersonID = s.CustomerPersonID
            and d.PersonType = s.PersonType
        where d.CustomerID is null


        -- Count SCD2_Rows_Count
       select @SCD2_Rows_Count = count(*) 
        from stg.Customer_staging s
            left join prod.DimCustomer d
            on d.CustomerID = s.CustomerID
            and d.CustomerPersonID = s.CustomerPersonID
            and d.PersonType = s.PersonType
        where 
            d.FirstName <> s.FirstName
             or d.MiddleName <> s.MiddleName
             or d.LastName <> s.LastName
  

        --- count SCD_1 rows
        select @SCD1_Rows_Count = count (*) 
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
        -- STEP 4: Commit transaction
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
