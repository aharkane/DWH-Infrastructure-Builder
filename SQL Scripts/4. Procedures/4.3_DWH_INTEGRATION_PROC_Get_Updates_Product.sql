

drop procedure if exists integration.Get_Updates_Product;
go

create procedure integration.Get_Updates_Product
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
        truncate table stg.Product_staging;

        ------------------------------------------------------------
        -- STEP 2: Insert incremental updates directly into staging
        ------------------------------------------------------------
        insert into stg.Product_staging
	select 
		 p.		ProductNumber			AS	ProductNumber
		,p.		ProductID				AS	ProductID
		,pc.	ProductCategoryID		AS	ProductCategoryID
		,psc.	ProductSubcategoryID	AS	ProductSubcategoryID
		,p.		Name					AS	ProductName
		,pc.	Name					AS	ProductCategoryName
		,psc.	Name					AS	ProductSubcategoryName	
		,p.		Color					AS	ProductColor
		,p.		Style					AS	ProductStyle		--------- W = Womens, M = Mens, U = Universal
		,p.		ProductLine				AS	ProductLine			--------- R = Road, M = Mountain, T = Touring, S = Standard
		,p.		StandardCost			AS	StandardCost 	
		,p.		ListPrice				AS	ListPrice
		,p.		Size					AS	ProductSize
		,pumS.	UnitMeasureCode			AS	UnitSizeCode	
		,pumS.	Name					AS	UnitSizeName
		,p.		Weight					AS	ProductWeight
		,pumW.	UnitMeasureCode			AS	UnitWeightCode
		,pumW.	Name					AS	UnitWeightName
		,p.		SellStartDate			AS	SellStartDate	
		,p.		SellEndDate				AS	SellEndDate
		,p.		DiscontinuedDate		AS	DiscountinuedDate
		,p.		ValidityDate_Start		AS	ValidityDate_Start
		,p.		ValidityDate_End		AS	ValidityDate_End

	from AdvWrks2022_OLTP.Production.Product p
		left join AdvWrks2022_OLTP.Production.ProductSubcategory psc on psc.ProductSubcategoryID = p.ProductSubcategoryID
		left join AdvWrks2022_OLTP.Production.ProductCategory pc on pc.ProductCategoryID = psc.ProductCategoryID
		left join AdvWrks2022_OLTP.Production.UnitMeasure pumS on pumS.UnitMeasureCode = p.SizeUnitMeasureCode 
		left join AdvWrks2022_OLTP.Production.UnitMeasure pumW on pumW.UnitMeasureCode = p.WeightUnitMeasureCode
	
        where 
            p.ValidityDate_Start > coalesce (@ETL_CuttoffDate_prev,'01-01-2000') -- to select data that has not yet been loaded to DimTable since last load
            and 
            p.ValidityDate_Start <= @ETL_CuttoffDate -- to select only data that validity have already started (no future) 
            and
            p.ValidityDate_End > @ETL_CuttoffDate -- to select only data that is valid to the ETL date 
			


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
