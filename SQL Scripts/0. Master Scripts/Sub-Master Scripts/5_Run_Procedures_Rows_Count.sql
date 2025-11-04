
-------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------- Run Procedures --------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------------
:setvar ProceduresPath "D:\JupyterNotebooks_dir\Github Projects\4. SSIS\1. DWH Infrastructure Builder\SQL Scripts\4. Procedures"
GO


---- Run Procedures Integration.LoadUpdates_Table --------
:r ""$(ProceduresPath)\5.1_DWH_INTEGRATION_PROC_Rows_Count_Address.sql""
GO

:r ""$(ProceduresPath)\5.2_DWH_INTEGRATION_PROC_Rows_Count_Customer.sql""
GO

:r ""$(ProceduresPath)\5.3_DWH_INTEGRATION_PROC_Rows_Count_Product.sql""
GO

:r ""$(ProceduresPath)\5.4_DWH_INTEGRATION_PROC_Rows_Count_SalesPerson.sql""
GO

:r ""$(ProceduresPath)\5.5_DWH_INTEGRATION_PROC_Rows_Count_Sales.sql""
GO