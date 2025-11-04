

------ 5.3. integration.Rows_Count_Product

drop procedure if exists integration.Rows_Count_Product;
go

create procedure integration.Rows_Count_Product
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
         from stg.Product_staging s
            left join prod.DimProduct d
            on d.ProductID = s.ProductID
            and d.ProductNumber = s.ProductNumber
            and d.ProductCategoryID = s.ProductCategoryID
            and d.ProductSubcategoryID = s.ProductSubcategoryID
            and d.UnitSizeCode = s.UnitSizeCode
            and d.UnitWeightCode = s.UnitWeightCode
        where d.ProductID is null
      

        -- Count SCD2_Rows_Count
        select @SCD2_Rows_Count = count(*) 
        from stg.Product_staging s
            left join prod.DimProduct d
            on d.ProductID = s.ProductID
            and d.ProductNumber = s.ProductNumber
            and d.ProductCategoryID = s.ProductCategoryID
            and d.ProductSubcategoryID = s.ProductSubcategoryID
            and d.UnitSizeCode = s.UnitSizeCode
            and d.UnitWeightCode = s.UnitWeightCode
        where
                d.ProductColor <> s.ProductColor
             or d.ProductStyle <> s.ProductStyle
             or d.ProductLine <> s.ProductLine
             or d.StandardCost <> s.StandardCost
             or d.ListPrice <> s.ListPrice
             or d.ProductWeight <> s.ProductWeight
     

        --- count SCD_1 rows
         select @SCD1_Rows_Count = count (*) 
        from prod.DimProduct d
            inner join stg.Product_staging s
                on d.ProductID = s.ProductID
                and d.ProductNumber = s.ProductNumber
                and d.ProductCategoryID = s.ProductCategoryID
                and d.ProductSubcategoryID = s.ProductSubcategoryID
                and d.UnitSizeCode = s.UnitSizeCode
                and d.UnitWeightCode = s.UnitWeightCode
        where d.IsCurrent = 1
            and (
                d.ProductName <> s.ProductName
                or d.ProductCategoryName <> s.ProductCategoryName
                or d.ProductSubcategoryName <> s.ProductSubcategoryName
                or d.ProductSize <> s.ProductSize
                or d.UnitSizeName <> s.UnitSizeName
                or d.UnitWeightName <> s.UnitWeightName
                or d.SellStartDate <> s.SellStartDate
                or d.SellEndDate <> s.SellEndDate
                or d.DiscountinuedDate <> s.DiscountinuedDate
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
end