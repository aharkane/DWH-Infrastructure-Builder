USE AdvWrks2022_DWH
GO


-------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------- Run Procedures --------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------------
:setvar ProceduresPath "D:\JupyterNotebooks_dir\Github Projects\4. SSIS\1. DWH Infrastructure Builder\SQL Scripts\4. Procedures"
GO

---- Integration.GetUpdates_Table --------
:r ""$(ProceduresPath)\4.1_DWH_INTEGRATION_PROC_Get_Updates_Address.sql""
GO

:r ""$(ProceduresPath)\4.2_DWH_INTEGRATION_PROC_Get_Updates_Customer.sql""
GO

:r ""$(ProceduresPath)\4.3_DWH_INTEGRATION_PROC_Get_Updates_Product.sql""
GO

:r ""$(ProceduresPath)\4.4_DWH_INTEGRATION_PROC_Get_Updates_SalesPerson.sql""
GO

:r ""$(ProceduresPath)\4.5_DWH_INTEGRATION_PROC_Get_Updates_Sales.sql""
GO