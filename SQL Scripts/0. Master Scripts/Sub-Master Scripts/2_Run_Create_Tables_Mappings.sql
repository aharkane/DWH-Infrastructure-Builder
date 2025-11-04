USE AdvWrks2022_DWH
GO


-------------------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------Run Create Tables Mappings ---------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------------------

:setvar TablesMappingPath "D:\JupyterNotebooks_dir\Github Projects\4. SSIS\1. DWH Infrastructure Builder\SQL Scripts\2. DWH Tables Mappings"
GO
---- Metadata.ColumnMap_TableList -------
:r ""$(TablesMappingPath)\1_DWH_METADATA_Mapping_Address.sql""
GO

:r ""$(TablesMappingPath)\2_DWH_METADATA_Mapping_Customer.sql""
GO

:r ""$(TablesMappingPath)\3_DWH_METADATA_Mapping_Product.sql""
GO

:r ""$(TablesMappingPath)\4_DWH_METADATA_Mapping_SalesPerson.sql""
GO

:r ""$(TablesMappingPath)\5_DWH_METADATA_Mapping_Sales.sql""
GO

-------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------- Run Table Generator Stored Procedures --------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------------
:setvar ProceduresPath "D:\JupyterNotebooks_dir\Github Projects\4. SSIS\1. DWH Infrastructure Builder\SQL Scripts\4. Procedures"
GO

---- Integration.TableGenerator -------
:r ""$(ProceduresPath)\1_DWH_INTEGRATION_PROC_TableGenerator.sql""