
-------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------- Run Procedures --------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------------
:setvar ProceduresPath "D:\JupyterNotebooks_dir\Github Projects\4. SSIS\1. DWH Infrastructure Builder\SQL Scripts\4. Procedures"
GO


---- Run Procedures Integration.LoadUpdates_Table --------
:r ""$(ProceduresPath)\6.1_DWH_INTEGRATION_PROC_Load_Updates_Address.sql""
GO

:r ""$(ProceduresPath)\6.2_DWH_INTEGRATION_PROC_Load_Updates_Customer.sql""
GO

:r ""$(ProceduresPath)\6.3_DWH_INTEGRATION_PROC_Load_Updates_Product.sql""
GO

:r ""$(ProceduresPath)\6.4_DWH_INTEGRATION_PROC_Load_Updates_SalesPerson.sql""
GO

:r ""$(ProceduresPath)\6.5_DWH_INTEGRATION_PROC_Load_Updates_Sales.sql""
GO