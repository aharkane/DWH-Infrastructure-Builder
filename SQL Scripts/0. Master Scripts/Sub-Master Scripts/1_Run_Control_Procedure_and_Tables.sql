USE AdvWrks2022_DWH
GO


-------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------ Run Create Control Tables ----------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------------

:setvar ProceduresPath "D:\JupyterNotebooks_dir\Github Projects\4. SSIS\1. DWH Infrastructure Builder\SQL Scripts\3. Control Tables"
GO
:r ""$(ProceduresPath)\1_DWH_INTEGRATION_Create_ControlTables.sql""
GO

:setvar ProceduresPath "D:\JupyterNotebooks_dir\Github Projects\4. SSIS\1. DWH Infrastructure Builder\SQL Scripts\4. Procedures"
GO

---- Run Procedures Integration.GetDataExtract -------
:r ""$(ProceduresPath)\2_DWH_INTEGRATION_PROC_Get_Last_ETL_CutoffDate.sql""
GO

---- Run Procedure Integration.GetLineageKey --------
:r ""$(ProceduresPath)\3_DWH_INTEGRATION_PROC_Get_Last_ETL_LineageKey.sql""
GO

---- Run Procedure integration.Update_Control_Tables --------
:r ""$(ProceduresPath)\7_DWH_INTEGRATION_PROC_Update_Control_Tables.sql""