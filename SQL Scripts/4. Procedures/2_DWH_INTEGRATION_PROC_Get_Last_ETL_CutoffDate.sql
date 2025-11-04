


drop procedure if exists integration.Get_Last_ETL_CutoffDate
go

create procedure integration.Get_Last_ETL_CutoffDate
@TableName nvarchar(128)
as 
begin
	if not exists (
		select ETL_CutoffDate
		from integration.ETL_Cutoff
		where TableName = @TableName 
	)
	begin
		insert into integration.ETL_Cutoff (TableName	,ETL_CutoffDate)
		Values	(@TableName 	,NULL)
	end

	select ETL_CutoffDate
	from ETL_Cutoff
	where TableName = @TableName 
end