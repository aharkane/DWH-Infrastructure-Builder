use AdvWrks2022_DWH
go

-------- Sales_ Table ------------------------------------

---------1. Create Table
drop table if exists metadata.Sales_ColumnMap
go
create table metadata.Sales_ColumnMap(
    SourceTable           NVARCHAR(50)    collate SQL_Latin1_General_CP1_CI_AS
    ,SourceColumn         NVARCHAR(50)    collate SQL_Latin1_General_CP1_CI_AS
    ,TargetColumn    NVARCHAR(50)    collate SQL_Latin1_General_CP1_CI_AS
    ,ColumnComment  NVARCHAR(MAX)   collate SQL_Latin1_General_CP1_CI_AS
)
go
drop table if exists metadata.Sales_TableList
go
create table metadata.Sales_TableList(
    SourceSchema NVARCHAR(50) collate SQL_Latin1_General_CP1_CI_AS
    ,SourceTable NVARCHAR(50) collate SQL_Latin1_General_CP1_CI_AS
)
go
----------2.Populate Table
insert into metadata.Sales_ColumnMap (SourceTable ,SourceColumn ,TargetColumn ,ColumnComment)
values  --------------------------- values from excel output
('SalesOrderHeader','SalesOrderNumber','SalesOrderNumber','---- Unique sales order identification number.')
,('SalesOrderHeader','SalesOrderID','SalesOrderID','')
,('SalesOrderDetail','SalesOrderDetailID','SalesOrderDetailID','')
,('SalesOrderDetail','ProductID','ProductID','')
,('SalesOrderHeader','CustomerID','CustomerID','')
,('SalesOrderHeader','SalesPersonID','SalesPersonID','')
,('SalesOrderDetail','SpecialOfferID','SpecialOfferID','')
,('SalesOrderHeader','TerritoryID','TerritoryID','')
,('SalesOrderHeader','ShipToAddressID','ShipToAddressID','')
,('SalesOrderHeader','CurrencyRateID','CurrencyRateID','')
,('SalesOrderHeader','OrderDate','OrderDate','---- Dates the sales order was created.')
,('SalesOrderHeader','DueDate','DueDate','---- Date the order is due to the customer.')
,('SalesOrderHeader','ShipDate','ShipDate','---- Date the order was shipped to the customer.')
,('SalesOrderHeader','Status','Status','---- Order current status. 1 = In process; 2 = Approved; 3 = Backordered; 4 = Rejected; 5 = Shipped; 6 = Cancelled')
,('SalesOrderHeader','OnlineOrderFlag','OnlineOrderFlag','---- 0 = Order placed by sales person. 1 = Order placed online by customer.')
,('SalesOrderHeader','SubTotal','OrderSubTotal ','')
,('SalesOrderHeader','TaxAmt','OrderTaxAmt','')
,('SalesOrderHeader','Freight','OrderFreight','')
,('SalesOrderHeader','TotalDue','OrderTotalDue','')
,('SalesOrderDetail','OrderQty','LineOrderQty','')
,('SalesOrderDetail','UnitPrice','UnitPrice','')
,('SalesOrderDetail','UnitPriceDiscount','UnitPriceDiscount','')
,('SalesOrderDetail','LineTotal','LineTotal','')
,('SalesOrderHeader','LastModifiedDate','LastModifiedDate','')







insert into metadata.Sales_TableList (SourceSchema, SourceTable)
values  --------------------------- values from excel output
('Sales','SalesOrderHeader')
,('Sales','SalesOrderDetail')




