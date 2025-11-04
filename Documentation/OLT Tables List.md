### **\*\*OLT Tables List:\*\***







Production.Product 



Production.ProductSubcategory



Production.ProductCategory



Production.UnitMeasure

------------------------

----------------------

Sales.Customer



Person.Person



Sales.Store



Sales.SalesTerritory



Person.CountryRegion



------------------------

----------------------

Sales.SalesPerson



HumanResources.Employee

----------------------------

--------------------------

Sales.SalesOrderHeader



Sales.SalesOrderDetail	



------------------------

----------------------







### **\*\*OLT Tables Diagram\*\***



--------------------------------------------------------------------------------------------------------------------



--------------------------------------------------------------------------------------------------------------------



DimProduct







Production.Product |-------- > 	Production.ProductSubcategory ---- > Production.ProductCategory



&nbsp;		   |



&nbsp;		   |



&nbsp;		   |--------- >	Production.UnitMeasure









--------------------------------------------------------------------------------------------------------------------



--------------------------------------------------------------------------------------------------------------------



DimSalesPerson



Sales.SalesPerson ----> HumanResources.Employee ---> Person.Person











------------------------------------------------------------------------------------------------

-------------------------------------------------------------------------------------------------------





DimCustomer



Sales.Customer 	|---> Person.Person 

&nbsp;		|---> Sales.Store --- > Sales.SalesPerson (Ref to above)

&nbsp;		|---> Sales.SalesTerritory ---> Person.CountryRegion







---------------------------------------------------------------------------------------------------------------



---------------------------------------------------------------------------------------------------------------------------







FactSales

DimAddress





Sales.SalesOrderHeader	|---> 	Sales.Customer (Ref to above)



&nbsp;			|--->	Sales.SalesPerson (Ref to above) (Can be accessed by Sales.Customer tree also)



&nbsp;			|--->	Sales.SalesTerritory (Ref To above) (Can be accessed by Sales.Customer tree also)	



&nbsp;			|<---> 	Sales.SalesOrderDetail	|----->	Production.Product (Ref to above)	



&nbsp;			|--->	(shipment) Person.Address -- > Person.StateProvince













### **DW Tables List**

----------------------------------------

---------------------------------------



DimProduct



Production.Product |-------- > 	Production.ProductSubcategory ---- > Production.ProductCategory

 		   |--------- >	Production.UnitMeasure



-------------------------------------------------------------------------------------------------- 

--------------------------------------------------------------------------------------------------



DimCustomer



Sales.Customer 	|---> Person.Person

&nbsp;               |---> Sales.Store

&nbsp;		|---> Sales.SalesTerritory ---> Person.CountryRegion

--------------------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------------



DimSalesPerson



Sales.SalesPerson |----> HumanResources.Employee ---> Person.Person 

&nbsp;

-----------------------------------------------------------------------------------------------------

-----------------------------------------------------------------------------------------------------



DimAddress



(shipment) Person.Address -- > Person.StateProvince ---> Sales.SalesTerritory--->  Person.CountryRegion



-------------------------------------------------------------------------------------------------

-------------------------------------------------------------------------------------------------

FactSales



Sales.SalesOrderHeader  |---> 	Sales.SalesOrderDetail



 



### **DW Tables Diagram**

-----------------------------------------------------------------------------

------------------------------------------------------------------------------



DimProduct



------------------------------------------------------------------------------

DimCustomer     |---> DimSalesPerson



----------------------------------------------------------------------------



FactSales	        |---> 	DimCustomer	

 			|--->	DimProduct

 			|--->	DimAddress

 

----------------------------------------------------------------------------





### **GENERAL DW DIAGRAM**



FactSales	|---> 	DimCustomer	|---> DimSalesPerson 

&nbsp;		|--->	DimProduct

 		|--->	DimAddress



 

 















































































