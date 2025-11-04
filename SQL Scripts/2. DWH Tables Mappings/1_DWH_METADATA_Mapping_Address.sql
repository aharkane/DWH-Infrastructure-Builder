use AdvWrks2022_DWH
go

-------- Address_ Table ------------------------------------

---------1. Create Table
drop table if exists metadata.Address_ColumnMap
go
create table metadata.Address_ColumnMap(
    SourceTable     NVARCHAR(50)    collate SQL_Latin1_General_CP1_CI_AS
    ,SourceColumn   NVARCHAR(50)    collate SQL_Latin1_General_CP1_CI_AS
    ,TargetColumn   NVARCHAR(50)    collate SQL_Latin1_General_CP1_CI_AS
    ,ColumnComment  NVARCHAR(MAX)   collate SQL_Latin1_General_CP1_CI_AS
)
go
drop table if exists metadata.Address_TableList
go
create table metadata.Address_TableList(
    SourceSchema NVARCHAR(50) collate SQL_Latin1_General_CP1_CI_AS
    ,SourceTable NVARCHAR(50) collate SQL_Latin1_General_CP1_CI_AS
)
go
----------2.Populate Table
insert into metadata.Address_ColumnMap (SourceTable ,SourceColumn ,TargetColumn ,ColumnComment)
values  --------------------------- values from excel output
('Address','AddressID','AddressID','')
,('StateProvince','StateProvinceID','StateProvinceID','')
,('StateProvince','TerritoryID','TerritoryID','')
,('Address','AddressLine1','AddressLine','')
,('Address','City','City','')
,('Address','PostalCode','PostalCode','')
,('StateProvince','Name','StateProvinceName','')
,('StateProvince','StateProvinceCode','StateProvinceCode','')
,('SalesTerritory','Name','TerritoryName','')
,('CountryRegion','Name','CountryRegionName','')
,('SalesTerritory','CountryRegionCode','CountryRegionCode','')
,('SalesTerritory','Group','TerritoryGroup','')
,('Address','ValidityDate_Start','ValidityDate_Start','')
,('Address','ValidityDate_End','ValidityDate_End','')




insert into metadata.Address_TableList (SourceSchema, SourceTable)
values  --------------------------- values from excel output
('Person','Address')
,('Person','StateProvince')
,('Sales','SalesTerritory')
,('Person','CountryRegion')




