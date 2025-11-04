USE AdvWrks2022_DWH
GO

-- OLTP


:r "D:\JupyterNotebooks_dir\Github Projects\4. SSIS\1. DWH Infrastructure Builder\SQL Scripts\X. Utilis\X4_OLTP_METADATA_PROC_Inject_SCD_Changes.sql"
GO


-- DWH

-- Clean DWH 

:r "D:\JupyterNotebooks_dir\Github Projects\4. SSIS\1. DWH Infrastructure Builder\SQL Scripts\X. Utilis\X1_DWH_UTILIS_ Clean_DWH.sql"
GO

-- Creation of the DWH objects

:setvar ProceduresPath "D:\JupyterNotebooks_dir\Github Projects\4. SSIS\1. DWH Infrastructure Builder\SQL Scripts\0. Master Scripts\Sub-Master Scripts"
:r ""$(ProceduresPath)\1_Run_Control_Procedure_and_Tables.sql""
GO

:setvar ProceduresPath "D:\JupyterNotebooks_dir\Github Projects\4. SSIS\1. DWH Infrastructure Builder\SQL Scripts\0. Master Scripts\Sub-Master Scripts"
:r ""$(ProceduresPath)\2_Run_Create_Tables_Mappings.sql""
Go

:setvar ProceduresPath "D:\JupyterNotebooks_dir\Github Projects\4. SSIS\1. DWH Infrastructure Builder\SQL Scripts\0. Master Scripts\Sub-Master Scripts"
:r ""$(ProceduresPath)\3_Execute_Procedure_TableGenerator.sql""
GO

:setvar ProceduresPath "D:\JupyterNotebooks_dir\Github Projects\4. SSIS\1. DWH Infrastructure Builder\SQL Scripts\0. Master Scripts\Sub-Master Scripts"
:r ""$(ProceduresPath)\4_Run_Procedures_Get_Updates_Tables.sql""
GO

:setvar ProceduresPath "D:\JupyterNotebooks_dir\Github Projects\4. SSIS\1. DWH Infrastructure Builder\SQL Scripts\0. Master Scripts\Sub-Master Scripts"
:r ""$(ProceduresPath)\5_Run_Procedures_Rows_Count.sql""
GO

:setvar ProceduresPath "D:\JupyterNotebooks_dir\Github Projects\4. SSIS\1. DWH Infrastructure Builder\SQL Scripts\0. Master Scripts\Sub-Master Scripts"
:r ""$(ProceduresPath)\6_Run_Procedures_Load_Updates_Table.sql""
GO

-- check the creation of the DWH objects

select CONCAT(s.name,'.',t.name) TableName
from sys.tables t inner join sys.schemas s on t.schema_id = s.schema_id order by s.schema_id
go

select CONCAT(s.name,'.',p.name) ProcedureName
from sys.procedures p inner join sys.schemas s on p.schema_id = s.schema_id order by s.schema_id
go		