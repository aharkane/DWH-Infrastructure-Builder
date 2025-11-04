use AdvWrks2022_DWH
go

-------- Customer Table ------------------------------------

---------1. Create Table
drop table if exists metadata.Customer_ColumnMap
go
create table metadata.Customer_ColumnMap(
    SourceTable           NVARCHAR(50)    collate SQL_Latin1_General_CP1_CI_AS
    ,SourceColumn         NVARCHAR(50)    collate SQL_Latin1_General_CP1_CI_AS
    ,TargetColumn    NVARCHAR(50)    collate SQL_Latin1_General_CP1_CI_AS
    ,ColumnComment  NVARCHAR(MAX)   collate SQL_Latin1_General_CP1_CI_AS
)
go
drop table if exists metadata.Customer_TableList
go
create table metadata.Customer_TableList(
    SourceSchema NVARCHAR(50) collate SQL_Latin1_General_CP1_CI_AS
    ,SourceTable NVARCHAR(50) collate SQL_Latin1_General_CP1_CI_AS
)
go
----------2.Populate Table
insert into metadata.Customer_ColumnMap (SourceTable ,SourceColumn ,TargetColumn ,ColumnComment)
values  --------------------------- values from excel output
('Customer','CustomerID','CustomerID ','')
,('Customer','PersonID','CustomerPersonID','')
,('Customer','StoreID','StoreID','')
,('Store','SalesPersonID','SalesPersonID','')
,('Customer','TerritoryID','TerritoryID','')
,('Person','PersonType','PersonType','----Primary type of person: SC = Store Contact, IN = Individual (retail) customer, SP = Sales person, EM = Employee (non-sales), VC = Vendor contact, GC = General contact')
,('Person','Title','Title','')
,('Person','FirstName','FirstName','')
,('Person','MiddleName','MiddleName','')
,('Person','LastName','LastName','')
,('Store','Name','StoreName','')
,('SalesTerritory','Name','TerritoryName','')
,('CountryRegion','Name','CountryRegionName','')
,('SalesTerritory','CountryRegionCode','CountryRegionCode','')
,('SalesTerritory','Group','TerritoryGroup','')
,('Customer','ValidityDate_Start','ValidityDate_Start','')
,('Customer','ValidityDate_End','ValidityDate_End','')







insert into metadata.Customer_TableList (SourceSchema, SourceTable)
values  --------------------------- values from excel output
('Sales','Customer')
,('Sales','Store')
,('Person','Person')
,('Sales','SalesTerritory')
,('Person','CountryRegion')



