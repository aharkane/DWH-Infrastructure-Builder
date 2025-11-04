use AdvWrks2022_DWH


declare @sqlstatement nvarchar(max)

select @sqlstatement =	
	

		STRING_AGG(
			'drop table if exists	'
			+
			QUOTENAME(s.name)+'.'+quotename(t.name)
			,CHAR(13) + CHAR(10)
		)


from	sys.schemas s
		left join sys.tables t on t.schema_id = s.schema_id -- tables

exec	sp_executesql @sqlstatement




GO
-- Drop Procedures

declare @sqlstatement nvarchar(max)
select @sqlstatement =	
	
		STRING_AGG(
			'drop procedure if exists	'
			+
			QUOTENAME(s.name)+'.'+quotename(p.name)
			,CHAR(13) + CHAR(10)
			)

from	sys.schemas s
		left join sys.procedures p on p.schema_id = s.schema_id -- procedures

exec	sp_executesql @sqlstatement



			