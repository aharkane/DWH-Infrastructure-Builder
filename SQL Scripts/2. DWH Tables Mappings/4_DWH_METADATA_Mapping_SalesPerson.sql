use AdvWrks2022_DWH
go

-------- SalesPerson_ Table ------------------------------------

---------1. Create Table
drop table if exists metadata.SalesPerson_ColumnMap
go
create table metadata.SalesPerson_ColumnMap(
    SourceTable           NVARCHAR(50)    collate SQL_Latin1_General_CP1_CI_AS
    ,SourceColumn         NVARCHAR(50)    collate SQL_Latin1_General_CP1_CI_AS
    ,TargetColumn    NVARCHAR(50)    collate SQL_Latin1_General_CP1_CI_AS
    ,ColumnComment  NVARCHAR(MAX)   collate SQL_Latin1_General_CP1_CI_AS
)
go
drop table if exists metadata.SalesPerson_TableList
go
create table metadata.SalesPerson_TableList(
    SourceSchema NVARCHAR(50) collate SQL_Latin1_General_CP1_CI_AS
    ,SourceTable NVARCHAR(50) collate SQL_Latin1_General_CP1_CI_AS
)
go
----------2.Populate Table
insert into metadata.SalesPerson_ColumnMap (SourceTable ,SourceColumn ,TargetColumn ,ColumnComment)
values  --------------------------- values from excel output
('SalesPerson','BusinessEntityID','SalesPersonID','')
,('Person','PersonType','PersonType','---- Primary type of person: SC = Store Contact, IN = Individual (retail) customer, SP = Sales person, EM = Employee (non-sales), VC = Vendor contact, GC = General contact')
,('Person','Title','Title','')
,('Person','FirstName','FirstName','')
,('Person','MiddleName','MiddleName','')
,('Person','LastName','LastName','')
,('Employee','OrganizationLevel','OrganizationLevel','--- The depth of the employee in the corporate hierarchy.')
,('Employee','JobTitle','JobTitle','')
,('SalesPerson','SalesQuota','SalesQuota','--- Projected yearly sales.')
,('SalesPerson','Bonus','Bonus','--- Bonus due if quota is met.')
,('SalesPerson','CommissionPct','CommissionPct','--- Commision percent received per sale.')
,('SalesPerson','TerritoryID','TerritoryID','')
,('SalesPerson','ValidityDate_Start','ValidityDate_Start','')
,('SalesPerson','ValidityDate_End','ValidityDate_End','')








insert into metadata.SalesPerson_TableList (SourceSchema, SourceTable)
values  --------------------------- values from excel output
('Sales','SalesPerson')
,('Person','Person')
,('HumanResources','Employee')





