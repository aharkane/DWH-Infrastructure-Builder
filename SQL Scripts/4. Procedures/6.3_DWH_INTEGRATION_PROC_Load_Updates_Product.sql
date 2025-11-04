

------ 6.3. integration.Load_Updates_Product

drop procedure if exists integration.Load_Updates_Product;
go

create procedure integration.Load_Updates_Product

as
begin
    set nocount on;
    set xact_abort on;

    begin try
        begin transaction;

    ------------------------------------------------------------
    -- STEP 1: Handle SCD Type 2 (new and changed historical rows
    ------------------------------------------------------------

    -- Mark current records as non-current if historical change detected
    update d
    set d.IsCurrent = 0
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
            d.ProductColor <> s.ProductColor
         or d.ProductStyle <> s.ProductStyle
         or d.ProductLine <> s.ProductLine
         or d.StandardCost <> s.StandardCost
         or d.ListPrice <> s.ListPrice
         or d.ProductWeight <> s.ProductWeight
      );

    -- Insert new or changed (SCD2) records
    insert into prod.DimProduct
    (
        ProductNumber,
        ProductID,
        ProductCategoryID,
        ProductSubcategoryID,
        UnitSizeCode,
        UnitWeightCode,
        ProductName,
        ProductCategoryName,
        ProductSubcategoryName,
        ProductColor,
        ProductStyle,
        ProductLine,
        StandardCost,
        ListPrice,
        ProductSize,
        UnitSizeName,
        ProductWeight,
        UnitWeightName,
        SellStartDate,
        SellEndDate,
        DiscountinuedDate,
        ValidityDate_Start,
        ValidityDate_End,
        IsCurrent
    )
    select
        s.ProductNumber,
        s.ProductID,
        s.ProductCategoryID,
        s.ProductSubcategoryID,
        s.UnitSizeCode,
        s.UnitWeightCode,
        s.ProductName,
        s.ProductCategoryName,
        s.ProductSubcategoryName,
        s.ProductColor,
        s.ProductStyle,
        s.ProductLine,
        s.StandardCost,
        s.ListPrice,
        s.ProductSize,
        s.UnitSizeName,
        s.ProductWeight,
        s.UnitWeightName,
        s.SellStartDate,
        s.SellEndDate,
        s.DiscountinuedDate,
        s.ValidityDate_Start as ValidityDate_Start,
        s.ValidityDate_End   as ValidityDate_End,
        1 as IsCurrent
    from stg.Product_staging s
    left join prod.DimProduct d
        on d.ProductID = s.ProductID
        and d.ProductNumber = s.ProductNumber
        and d.ProductCategoryID = s.ProductCategoryID
        and d.ProductSubcategoryID = s.ProductSubcategoryID
        and d.UnitSizeCode = s.UnitSizeCode
        and d.UnitWeightCode = s.UnitWeightCode
    where d.ProductID is null
       or (
            d.ProductColor <> s.ProductColor
         or d.ProductStyle <> s.ProductStyle
         or d.ProductLine <> s.ProductLine
         or d.StandardCost <> s.StandardCost
         or d.ListPrice <> s.ListPrice
         or d.ProductWeight <> s.ProductWeight
      );

    ------------------------------------------------------------
    -- STEP 2: Handle SCD Type 1 (non-historical attribute updates)
    ------------------------------------------------------------

    update d
    set d.ProductNumber        = s.ProductNumber,
        d.ProductCategoryID    = s.ProductCategoryID,
        d.ProductSubcategoryID = s.ProductSubcategoryID,
        d.UnitSizeCode         = s.UnitSizeCode,
        d.UnitWeightCode       = s.UnitWeightCode,
        d.ProductName          = s.ProductName,
        d.ProductCategoryName  = s.ProductCategoryName,
        d.ProductSubcategoryName = s.ProductSubcategoryName,
        d.ProductSize          = s.ProductSize,
        d.UnitSizeName         = s.UnitSizeName,
        d.UnitWeightName       = s.UnitWeightName,
        d.SellStartDate        = s.SellStartDate,
        d.SellEndDate          = s.SellEndDate,
        d.DiscountinuedDate    = s.DiscountinuedDate
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