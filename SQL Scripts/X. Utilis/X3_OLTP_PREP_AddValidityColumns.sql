use AdvWrks2022_OLTP
go
---------------------------------------------------------------------------------------------------------------------------------------------------------------------
							------- Adding Validity Date columns to dimension tables and Last modified date to fact table-----------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------------------------------
----- Alter Product Table -----
alter table AdvWrks2022_OLTP.Production.Product
add	 ValidityDate_Start	datetime	null 
	,ValidityDate_End	datetime	null      
GO

----- Alter Customer Table -----
alter table AdvWrks2022_OLTP.Sales.Customer
add	 ValidityDate_Start	datetime	null  
	,ValidityDate_End	datetime	null
GO

----- Alter SalesPerson Table -----
alter table AdvWrks2022_OLTP.Sales.SalesPerson
add	 ValidityDate_Start	datetime	null  
	,ValidityDate_End	datetime	null        
GO

----- Alter Address Table -----
alter table AdvWrks2022_OLTP.Person.Address
add	 ValidityDate_Start	datetime	null   
	,ValidityDate_End	datetime	null        
GO

----- Alter SalesOrderHeader Table -----
alter table AdvWrks2022_OLTP.Sales.SalesOrderHeader
add	 LastModifiedDate	datetime	null     
GO


---------------------------------------------------------------------------------------------------------------------------------------------------------------------
							------- Updating ValidityDate columns and Last modified date with randoms datetimes ------------
---------------------------------------------------------------------------------------------------------------------------------------------------------------------
----- Alter Product Table -----
update AdvWrks2022_OLTP.Production.Product
set ValidityDate_Start	=	(DATEADD(DAY, RAND(CHECKSUM(NEWID()))*(1+DATEDIFF(DAY, '01/01/2019','12/31/2024')),'01/01/2019'))
	,ValidityDate_End	=	(DATEADD(DAY, RAND(CHECKSUM(NEWID()))*(1+DATEDIFF(DAY, '01/01/2025','01/01/2030')),'01/01/2025')) 
GO

----- Alter Customer Table -----
update AdvWrks2022_OLTP.Sales.Customer
set ValidityDate_Start	=	(DATEADD(DAY, RAND(CHECKSUM(NEWID()))*(1+DATEDIFF(DAY, '01/01/2019','12/31/2024')),'01/01/2019'))
	,ValidityDate_End	=	(DATEADD(DAY, RAND(CHECKSUM(NEWID()))*(1+DATEDIFF(DAY, '01/01/2025','01/01/2030')),'01/01/2025')) 
GO

----- Alter SalesPerson Table -----
update AdvWrks2022_OLTP.Sales.SalesPerson
set ValidityDate_Start	=	(DATEADD(DAY, RAND(CHECKSUM(NEWID()))*(1+DATEDIFF(DAY, '01/01/2019','12/31/2024')),'01/01/2019'))
	,ValidityDate_End	=	(DATEADD(DAY, RAND(CHECKSUM(NEWID()))*(1+DATEDIFF(DAY, '01/01/2025','01/01/2030')),'01/01/2025')) 
GO

----- Alter Address Table -----
update AdvWrks2022_OLTP.Person.Address
set ValidityDate_Start	=	(DATEADD(DAY, RAND(CHECKSUM(NEWID()))*(1+DATEDIFF(DAY, '01/01/2019','12/31/2024')),'01/01/2019'))
	,ValidityDate_End	=	(DATEADD(DAY, RAND(CHECKSUM(NEWID()))*(1+DATEDIFF(DAY, '01/01/2025','01/01/2030')),'01/01/2025')) 
GO

----- Alter SalesOrderHeader Table -----
update AdvWrks2022_OLTP.Sales.SalesOrderHeader
set LastModifiedDate	=	(DATEADD(DAY, RAND(CHECKSUM(NEWID()))*(1+DATEDIFF(DAY, '01/01/2019','12/31/2025')),'01/01/2019'))
GO









