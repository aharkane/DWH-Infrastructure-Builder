### \*\*OLT Tables List:\*\*







Production.Product 



Production.ProductSubcategory



Production.ProductCategory



Production.UnitMeasure

------------------------

----------------------

Sales.Customer



Person.Person



Sales.Store



Sales.SalesPerson



HumanResources.Employee



Sales.SalesTerritory



Person.CountryRegion



------------------------

----------------------



Sales.SalesOrderHeader



Sales.SalesOrderDetail	



Sales.SpecialOfferProduct



Sales.SpecialOffer



Person.StateProvince	



Sales.CurrencyRate



Sales.Currency



Purchasing.ShipMethod

------------------------

----------------------



Sales.SalesTaxRate



Person.StateProvince



Person.CountryRegion



Sales.SalesTerritory



Person.CountryRegion



### 

### **\*\*OLT Tables Diagram\*\***



--------------------------------------------------------------------------------------------------------------------



--------------------------------------------------------------------------------------------------------------------



**DimProduct**







Production.Product |-------- > 	Production.ProductSubcategory ---- > Production.ProductCategory



&nbsp;		   |



&nbsp;		   |



&nbsp;		   |--------- >	Production.UnitMeasure









--------------------------------------------------------------------------------------------------------------------



--------------------------------------------------------------------------------------------------------------------







**DimCustomer**

**DimSalesPerson**

**DimSalesTerritory**



Sales.Customer 	|---> Person.Person <-----------------------------------------------------|



&nbsp;		|                                                                         |



&nbsp;		|                                                                         |



&nbsp;		|---> Sales.Store ---> Sales.SalesPerson ----> HumanResources.Employee ---|



&nbsp;		|				|



&nbsp;		|             -------------------



&nbsp;               |             |



&nbsp;		|---> Sales.SalesTerritory ---> Person.CountryRegion

















---------------------------------------------------------------------------------------------------------------



---------------------------------------------------------------------------------------------------------------------------







**FactSales**

**DimAddress**

**DimCurrency**

**DimSpecialOfferProduct**

**DimshipMethod**

**DimSalesTaxRate**



Sales.SalesOrderHeader	|---> 	Sales.Customer (Ref to above)



&nbsp;			|



&nbsp;			|



&nbsp;			|--->	Sales.SalesPerson (Ref to above) (Can be accessed by Sales.Customer tree also)



&nbsp;			|



&nbsp;			|



&nbsp;			|--->	Sales.SalesTerritory (Ref To above) (Can be accessed by Sales.Customer tree also)	



&nbsp;			|



&nbsp;			|<---> 	Sales.SalesOrderDetail	|----->	Production.Product (Ref to above)	



&nbsp;			|				|



&nbsp;			|				|----->	Sales.SpecialOfferProduct |-----> Sales.SpecialOffer



&nbsp;			|								  |-----> Production.Product (Ref to above)



&nbsp;			|--->	(shipment) Person.Address -- > Person.StateProvince	



&nbsp;			|



&nbsp;			|---> 	Sales.CurrencyRate ---> Sales.Currency	-- Sales.CountryRegionCurrency

&nbsp;			|

&nbsp;			|---> Purchasing.ShipMethod

&nbsp;							











&nbsp;								









Sales.SalesTaxRate ---> Person.StateProvince|---> Person.CountryRegion



&nbsp;					    |---> Sales.SalesTerritory ---> Person.CountryRegion















### **DW Tables List**

----------------------------------------

---------------------------------------



##### **DimProduct**



Production.Product |-------- > 	Production.ProductSubcategory ---- > Production.ProductCategory

 		   |--------- >	Production.UnitMeasure



-------------------------------------------------------------------------------------------------- 

--------------------------------------------------------------------------------------------------

##### 

##### **DimCustomer**



Sales.Customer 	|---> Person.Person

&nbsp;               |---> Sales.Store

&nbsp;		|---> Sales.SalesTerritory ---> Person.CountryRegion

--------------------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------------



##### **DimSalesPerson**



Sales.SalesPerson |----> HumanResources.Employee ---> Person.Person 

&nbsp;        	  |---> Sales.SalesTerritory ---> Person.CountryRegion

-----------------------------------------------------------------------------------------------------

-----------------------------------------------------------------------------------------------------



##### **DimSalesTerritory (NOT FOR NOW)**



Sales.SalesTerritory ---> Person.CountryRegion



----------------------------------------------------------------------------------------------------

----------------------------------------------------------------------------------------------------

##### **DimSalesTaxRate (NOT FOR NOW)**



Sales.SalesTaxRate ---> Person.StateProvince|---> Person.CountryRegion



----------------------------------------------------------------------------------------------------

--------------------------------------------------------------------------------------------------------



##### **DimshipMethod (NOT FOR NOW)**



&nbsp;Purchasing.ShipMethod

-----------------------------------------------------------------------------------------------------

-----------------------------------------------------------------------------------------------------



##### **DimAddress**



(shipment) Person.Address -- > Person.StateProvince

-----------------------------------------------------------------------------------------------------

-------------------------------------------------------------------------------------------------------

##### 

##### **DimCurrency**



Sales.CurrencyRate ---> Sales.Currency	-- Sales.CountryRegionCurrency



-----------------------------------------------------------------------------------------------

-----------------------------------------------------------------------------------------------



##### **DimSpecialOfferProduct**



Sales.SalesOrderHeader	|----->	Sales.SpecialOfferProduct |-----> Sales.SpecialOffer





-------------------------------------------------------------------------------------------------

-------------------------------------------------------------------------------------------------

##### **FactSales**



Sales.SalesOrderHeader  |---> 	Sales.SalesOrderDetail



 



### **DW Tables Diagram**

**-----------------------------------------------------------------------------**

**------------------------------------------------------------------------------**



**DimProduct**



------------------------------------------------------------------------------

**DimCustomer**     |---> **DimSalesPerson**



 		|---> **DimSalesTerritory**



----------------------------------------------------------------------------



**FactSales**	        |---> 	**DimCustomer**	

 			|--->	**DimProduct**

 			|--->	**DimSpecialOfferProduct**

 			|--->	**DimAddress**

 			|---> 	**DimCurrency**

 			|--->	**DimshipMethod**

 

----------------------------------------------------------------------------



**DimSalesTaxRate**		|---> **DimSalesTerritory**





### GENERAL DW DIAGRAM



**FactSales**	|---> 	**DimCustomer**	|---> **DimSalesPerson** 

&nbsp;		|                       |---> **DimSalesTerritory ---> DimSalesTaxRate ( canbe merged to DimSalesTerritory)** 

&nbsp;		|--->	**DimProduct**

 		|--->	**DimSpecialOfferProduct**

 		|--->	**DimAddress**

 		|---> 	**DimCurrency**

 		|--->	**DimshipMethod**

 





**FactSales**	|---> 	**DimCustomer**	|---> **DimSalesPerson**

 		|           

 		|--->	**DimProduct**

 















































































