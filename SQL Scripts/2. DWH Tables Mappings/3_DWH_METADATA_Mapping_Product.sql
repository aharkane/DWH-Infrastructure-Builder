use AdvWrks2022_DWH
go

-------- Product_ Table ------------------------------------

---------1. Create Table
drop table if exists metadata.Product_ColumnMap
go
create table metadata.Product_ColumnMap(
    SourceTable           NVARCHAR(50)    collate SQL_Latin1_General_CP1_CI_AS
    ,SourceColumn         NVARCHAR(50)    collate SQL_Latin1_General_CP1_CI_AS
    ,TargetColumn    NVARCHAR(50)    collate SQL_Latin1_General_CP1_CI_AS
    ,ColumnComment  NVARCHAR(MAX)   collate SQL_Latin1_General_CP1_CI_AS
)
go
drop table if exists metadata.Product_TableList
go
create table metadata.Product_TableList(
    SourceSchema NVARCHAR(50) collate SQL_Latin1_General_CP1_CI_AS
    ,SourceTable NVARCHAR(50) collate SQL_Latin1_General_CP1_CI_AS
)
go
----------2.Populate Table
insert into metadata.Product_ColumnMap (SourceTable ,SourceColumn ,TargetColumn ,ColumnComment)
values  --------------------------- values from excel output
('Product','ProductNumber','ProductNumber','')
,('Product','ProductID','ProductID','')
,('ProductCategory','ProductCategoryID','ProductCategoryID','')
,('ProductSubcategory','ProductSubcategoryID','ProductSubcategoryID','')
,('Product','Name','ProductName','')
,('ProductCategory','Name','ProductCategoryName','')
,('ProductSubcategory','Name','ProductSubcategoryName','')
,('Product','Color','ProductColor','')
,('Product','Style','ProductStyle','---- W = Womens, M = Mens, U = Universal')
,('Product','ProductLine','ProductLine','---- R = Road, M = Mountain, T = Touring, S = Standard')
,('Product','StandardCost','StandardCost ','')
,('Product','ListPrice','ListPrice','')
,('Product','Size','ProductSize','')
,('UnitMeasure','UnitMeasureCode','UnitSizeCode','')
,('UnitMeasure','Name','UnitSizeName','')
,('Product','Weight','ProductWeight','')
,('UnitMeasure','UnitMeasureCode','UnitWeightCode','')
,('UnitMeasure','Name','UnitWeightName','')
,('Product','SellStartDate','SellStartDate','')
,('Product','SellEndDate','SellEndDate','')
,('Product','DiscontinuedDate','DiscountinuedDate','')
,('Product','ValidityDate_Start','ValidityDate_Start','')
,('Product','ValidityDate_End','ValidityDate_End','')




insert into metadata.Product_TableList (SourceSchema, SourceTable)
values  --------------------------- values from excel output
('Production','Product')
,('Production','ProductCategory')
,('Production','ProductSubcategory')
,('Production','UnitMeasure')


