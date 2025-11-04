
drop procedure if exists integration.Get_Last_ETL_LineageKey
go

create procedure integration.Get_Last_ETL_LineageKey
(
	@TableName				nvarchar(128)
	,@ETL_CuttoffDate	datetime2(3)
)
as
begin
	declare @DataLoad_StartTime_param datetime2(3) =  @ETL_CuttoffDate

	insert into integration.ETL_Lineage	(
		TableName
		,ETL_CutoffDate_Start
		,ETL_CutoffDate_End
		,ETL_TimeDuration_MilliSec
		,New_Rows_Count
		,SCD2_Rows_Count
		,SCD1_Rows_Count
		,IsSuccessful
		)
	Values (
		@TableName
		,@ETL_CuttoffDate
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,0
		) -- ,ETL_TimeDuration_MilliSec, ETL_CutoffDate_End and IsSuccessful are to updated after the migration is successful

	
	
	
	select top 1 ETL_LineageKey
	from integration.ETL_Lineage
	where TableName = @TableName
	order by ETL_LineageKey DESC 

end