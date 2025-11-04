use AdvWrks2022_DWH
go

---1 create cutoff table

drop table if exists integration.ETL_Cutoff
go

create table integration.ETL_Cutoff (
	TableName	nvarchar(128)	primary key
	,ETL_CutoffDate	datetime	
)


--- 2 create lineage table
drop table if exists integration.ETL_Lineage
go

create table integration.ETL_Lineage(
	ETL_LineageKey	int identity(1,1)	primary key
	,TableName	nvarchar(128)
	,ETL_CutoffDate_Start	datetime
	,ETL_CutoffDate_End	datetime
	,ETL_TimeDuration_MilliSec int
	,New_Rows_Count int
	,SCD2_Rows_Count int
	,SCD1_Rows_Count int
	,IsSuccessful	bit
)