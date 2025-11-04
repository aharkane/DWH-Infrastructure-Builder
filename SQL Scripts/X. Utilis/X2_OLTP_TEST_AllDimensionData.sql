
------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------
															-----OLTP Tables Testing Queries------
------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------


------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------
															----- Address Tables Testing ------
------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------
use AdvWrks2022_OLTP
go

select top 80 percent 
ad.	AddressID	AS	AddressID
,spr.	StateProvinceID	AS	StateProvinceID
,spr.	TerritoryID	AS	TerritoryID
,ad.	AddressLine1	AS	AddressLine
,ad.	City	AS	City
,ad.	PostalCode	AS	PostalCode
,spr.	Name	AS	StateProvinceName
,spr.	StateProvinceCode	AS	StateProvinceCode	
,st.	Name	AS	TerritoryName
,cr.	Name	AS	CountryRegionName
,st.	CountryRegionCode	AS	CountryRegionCode
,st.	[Group]	AS	TerritoryGroup
,ad.	ValidityDate_Start	AS	ValidityDate_Start
,ad.	ValidityDate_End	AS	ValidityDate_End

from AdvWrks2022_OLTP.Person.Address ad
	left join AdvWrks2022_OLTP.Person.StateProvince spr on ad.StateProvinceID = spr.StateProvinceID
	left join AdvWrks2022_OLTP.Sales.SalesTerritory st on st.TerritoryID = spr.TerritoryID 
	left join AdvWrks2022_OLTP.Person.CountryRegion cr on cr.CountryRegionCode = st.CountryRegionCode





------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------
															----- Customer Tables Testing ------
------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------
use AdvWrks2022_OLTP
go

select top 80 percent
c.	CustomerID	AS	CustomerID 
,c.	PersonID	AS	CustomerPersonID
,c.	StoreID	AS	StoreID
,s.	SalesPersonID	AS	SalesPersonID
,c.	TerritoryID	AS	TerritoryID
,prs.	PersonType	AS	PersonType	----Primary type of person: SC = Store Contact, IN = Individual (retail) customer, SP = Sales person, EM = Employee (non-sales), VC = Vendor contact, GC = General contact
,prs.	Title	AS	Title
,prs.	FirstName	AS	FirstName
,prs.	MiddleName	AS	MiddleName
,prs.	LastName	AS	LastName
,s.	Name	AS	StoreName
,st.	Name	AS	TerritoryName
,cr.	Name	AS	CountryRegionName
,st.	CountryRegionCode	AS	CountryRegionCode
,st.	[Group]	AS	TerritoryGroup
,c.	ValidityDate_Start	AS	ValidityDate_Start
,c.	ValidityDate_End	AS	ValidityDate_End

from AdvWrks2022_OLTP.Sales.Customer c
	left join AdvWrks2022_OLTP.Person.Person prs on c.PersonID  = prs.BusinessEntityID	-- customer indentification
	left join AdvWrks2022_OLTP.Sales.Store s on c.StoreID = s.BusinessEntityID		-- store identification
	left join AdvWrks2022_OLTP.Sales.SalesTerritory st on st.TerritoryID = c.TerritoryID 
	left join AdvWrks2022_OLTP.Person.CountryRegion cr on cr.CountryRegionCode = st.CountryRegionCode





------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------
															----- Product Tables Testing ------
------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------
use AdvWrks2022_OLTP
go

------------------select * 
------------------from Production.Product p
------------------	left join Production.ProductSubcategory psc on psc.ProductSubcategoryID = p.ProductSubcategoryID
------------------	left join Production.ProductCategory pc on pc.ProductCategoryID = psc.ProductCategoryID
------------------	left join Production.UnitMeasure pumS on pumS.UnitMeasureCode = p.SizeUnitMeasureCode 
------------------	left join Production.UnitMeasure pumW on pumW.UnitMeasureCode = p.WeightUnitMeasureCode


select top 80 percent
p.	ProductNumber	AS	ProductNumber
,p.	ProductID	AS	ProductID
,pc.	ProductCategoryID	AS	ProductCategoryID
,psc.	ProductSubcategoryID	AS	ProductSubcategoryID
,p.	Name	AS	ProductName
,pc.	Name	AS	ProductCategoryName
,psc.	Name	AS	ProductSubcategoryName	
,p.	Color	AS	ProductColor
,p.	Style	AS	ProductStyle	---- W = Womens, M = Mens, U = Universal
,p.	ProductLine	AS	ProductLine	---- R = Road, M = Mountain, T = Touring, S = Standard
,p.	StandardCost	AS	StandardCost 	
,p.	ListPrice	AS	ListPrice
,p.	Size	AS	ProductSize
,pumS.	UnitMeasureCode	AS	UnitSizeCode	
,pumS.	Name	AS	UnitSizeName
,p.	Weight	AS	ProductWeight
,pumW.	UnitMeasureCode	AS	UnitWeightCode
,pumW.	Name	AS	UnitWeightName
,p.	SellStartDate	AS	SellStartDate	
,p.	SellEndDate	AS	SellEndDate
,p.	DiscontinuedDate	AS	DiscountinuedDate
,p.	ValidityDate_Start	AS	ValidityDate_Start
,p.	ValidityDate_End	AS	ValidityDate_End

from AdvWrks2022_OLTP.Production.Product p
	left join AdvWrks2022_OLTP.Production.ProductSubcategory psc on psc.ProductSubcategoryID = p.ProductSubcategoryID
	left join AdvWrks2022_OLTP.Production.ProductCategory pc on pc.ProductCategoryID = psc.ProductCategoryID
	left join AdvWrks2022_OLTP.Production.UnitMeasure pumS on pumS.UnitMeasureCode = p.SizeUnitMeasureCode 
	left join AdvWrks2022_OLTP.Production.UnitMeasure pumW on pumW.UnitMeasureCode = p.WeightUnitMeasureCode





------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------
															----- SalesPerson Tables Testing ------
------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------
use AdvWrks2022_OLTP
go


select top 80 percent
sp.	BusinessEntityID	AS	SalesPersonID
,prs.	PersonType	AS	PersonType	---- Primary type of person: SC = Store Contact, IN = Individual (retail) customer, SP = Sales person, EM = Employee (non-sales), VC = Vendor contact, GC = General contact
,prs.	Title	AS	Title
,prs.	FirstName	AS	FirstName
,prs.	MiddleName	AS	MiddleName
,prs.	LastName	AS	LastName	
,em.	OrganizationLevel	AS	OrganizationLevel	--- The depth of the employee in the corporate hierarchy.
,em.	JobTitle	AS	JobTitle
,sp.	SalesQuota	AS	SalesQuota	--- Projected yearly sales.
,sp.	Bonus	AS	Bonus	--- Bonus due if quota is met.
,sp.	CommissionPct	AS	CommissionPct	--- Commision percent received per sale.
,sp.	TerritoryID	AS	TerritoryID
,sp.	ValidityDate_Start	AS	ValidityDate_Start
,sp.	ValidityDate_End	AS	ValidityDate_End

from AdvWrks2022_OLTP.Sales.SalesPerson sp
	left join AdvWrks2022_OLTP.HumanResources.Employee em on sp.BusinessEntityID = em.BusinessEntityID
	left join AdvWrks2022_OLTP.Person.Person prs on prs.BusinessEntityID = em.BusinessEntityID




------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------
															----- Sales Tables Testing ------
------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------
use AdvWrks2022_OLTP
go

select top 10 percent 
soh.	SalesOrderNumber	AS	SalesOrderNumber	---- Unique sales order identification number.
,soh.	SalesOrderID	AS	SalesOrderID
,sod.	SalesOrderDetailID	AS	SalesOrderDetailID
,sod.	ProductID	AS	ProductID
,soh.	CustomerID	AS	CustomerID
,soh.	SalesPersonID	AS	SalesPersonID
,sod.	SpecialOfferID	AS	SpecialOfferID
,soh.	TerritoryID	AS	TerritoryID
,soh.	ShipToAddressID	AS	ShipToAddressID
,soh.	CurrencyRateID	AS	CurrencyRateID
,soh.	OrderDate	AS	OrderDate	---- Dates the sales order was created.
,soh.	DueDate	AS	DueDate	---- Date the order is due to the customer.
,soh.	ShipDate	AS	ShipDate	---- Date the order was shipped to the customer.
,soh.	Status	AS	Status	---- Order current status. 1 = In process; 2 = Approved; 3 = Backordered; 4 = Rejected; 5 = Shipped; 6 = Cancelled
,soh.	OnlineOrderFlag	AS	OnlineOrderFlag	---- 0 = Order placed by sales person. 1 = Order placed online by customer.
,soh.	SubTotal	AS	OrderSubTotal 
,soh.	TaxAmt	AS	OrderTaxAmt
,soh.	Freight	AS	OrderFreight
,soh.	TotalDue	AS	OrderTotalDue
,sod.	OrderQty	AS	LineOrderQty
,sod.	UnitPrice	AS	UnitPrice
,sod.	UnitPriceDiscount	AS	UnitPriceDiscount
,sod.	LineTotal	AS	LineTotal
,soh.	LastModifiedDate	AS	LastModifiedDate

from AdvWrks2022_OLTP.Sales.SalesOrderHeader soh
	left join AdvWrks2022_OLTP.Sales.SalesOrderDetail sod on soh.SalesOrderID = sod.SalesOrderID