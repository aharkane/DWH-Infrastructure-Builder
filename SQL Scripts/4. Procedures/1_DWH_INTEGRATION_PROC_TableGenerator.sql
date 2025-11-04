-- ======================================================================================
-- Stored Procedure: metadata.CreateTableScript
-- Purpose: Dynamically generates and executes a DROP/CREATE TABLE script for a target
--          table (e.g., a staging or dimension table) based on metadata definitions
--          stored in metadata.[TableName]_TableList and metadata.[TableName]_ColumnMap.
--          This automates the initial data warehouse table creation process.
-- Parameters:
--    @TargetTableType: The target table type in the DWH (e.g., 'stg', 'dim','fact').
--    @TargetTable:  The base name of the target entity (e.g., 'Address'). This name is
--                   used to find the corresponding metadata tables.
-- ======================================================================================


drop procedure if exists metadata.TableGenerator
go

create procedure metadata.TableGenerator (

	@TargetTableType nvarchar(128) -- stg, dim, fact
	,@TargetTable nvarchar(128)
    )
    as 
	begin
	
		-- ======================================================================================
	-- SECTION 0: Load Table Names and Column Names used for the target table
	-- ======================================================================================


	----------- Declare variables for dynamic SQL and the final DDL script ----------------
	declare
	@InsertUsedTablesSQL	nvarchar(max)
	,@InsertUsedColumnsSQL	nvarchar(max)
	,@CreateTableSQL		nvarchar(max)

	-- ======================================================================================
	-- SECTION 1: SETUP TEMPORARY WORKING TABLES
	-- Purpose: Create temp tables to hold the specific metadata for this @TargetTable
	-- ======================================================================================

	----- Temporary table to store the list of source tables required for the target --------

        drop table if exists #UsedTables
        create table #UsedTables (
			SourceSchema	NVARCHAR(50) collate SQL_Latin1_General_CP1_CI_AS
			,SourceTable	NVARCHAR(50) collate SQL_Latin1_General_CP1_CI_AS
			)

	----- Temporary table to store the column mapping (Source -> Target) --------

        drop table if exists #UsedColumns
        create table #UsedColumns(
			SourceTable		NVARCHAR(50)    collate SQL_Latin1_General_CP1_CI_AS
			,SourceColumn	NVARCHAR(50)    collate SQL_Latin1_General_CP1_CI_AS
			,TargetColumn	NVARCHAR(50)    collate SQL_Latin1_General_CP1_CI_AS
			,ColumnComment	NVARCHAR(MAX)   collate SQL_Latin1_General_CP1_CI_AS
		)

			-- ==========================================================================
	-- SECTION 2: POPULATE WORKING TABLES FROM METADATA
	-- Purpose: Dynamically read from the metadata tables for the specified @TargetTable
	--          (e.g., metadata.Address_TableList) and load the data into our temp tables.
	-- ==========================================================================

		---- Populate the "#UsedTables" temp table from the metadata table list
		SET @InsertUsedTablesSQL = concat('insert into #UsedTables select * from metadata.',  QUOTENAME(@TargetTable + '_TableList'))
		exec sp_executesql @InsertUsedTablesSQL

		---- Populate the "#UsedColumns" temp table from the metadata column map
		SET @InsertUsedColumnsSQL = concat('insert into #UsedColumns select * from metadata.' , QUOTENAME(@TargetTable + '_ColumnMap'))
		exec sp_executesql @InsertUsedColumnsSQL
 

	-- ==========================================================================
	-- SECTION 3: GET SOURCE SYSTEM COLUMN DEFINITIONS
	-- Purpose: Retrieve the detailed physical properties (data type, length, nullability)
	--          for all columns in the source tables from the OLTP system catalog views.
	-- ==========================================================================

        ------ Create a temporary table to store the source column details ------
        drop table if exists #SourceTableColumns
        create table #SourceTableColumns (
            SourceSchema				NVARCHAR(50)	collate SQL_Latin1_General_CP1_CI_AS
            ,SourceTable				NVARCHAR(50)	collate SQL_Latin1_General_CP1_CI_AS
            ,SourceColumn				NVARCHAR(128)	collate SQL_Latin1_General_CP1_CI_AS
            ,UserDefined_DataType		NVARCHAR(128)	collate SQL_Latin1_General_CP1_CI_AS
			,SystemDefined_DataType		NVARCHAR(128)	collate SQL_Latin1_General_CP1_CI_AS
            ,DataLength					SMALLINT	
            ,DataPrecision				SMALLINT
            ,DataScale					SMALLINT
            ,CollationName				NVARCHAR(128)	collate SQL_Latin1_General_CP1_CI_AS
			,IsNullable					BIT
            )
		------ Insert data from the source system (OLTP) catalog views ------
        insert into #SourceTableColumns
		select --distinct
			s.name				SourceSchema				
			,t.name				SourceTable
			,c.name				SourceColumn
			,user_tp.name		UserDefined_DataType -- not used but to check the original user defined datatype
			,sys_tp.name		SystemDefined_DataType	
			,c.max_length		DataLength
			,c.precision		DataPrecision
			,c.scale			DataScale
			,c.collation_name	CollationName
			,case when c.name = @TargetTable+'ID'	then 0 else 1 end as IsNullable  --c.is_nullable		IsNullable
		from 
			AdvWrks2022_OLTP.sys.tables t
			inner join AdvWrks2022_OLTP.sys.schemas s on t.schema_id = s.schema_id
			inner join AdvWrks2022_OLTP.sys.columns c on t.object_id = c.object_id
			inner join AdvWrks2022_OLTP.sys.types user_tp  on user_tp.user_type_id = c.user_type_id			-- Get the column's "Base System Data TYPE (SDT)", linked To the "User-Defined Data Type (UDT)"  
			inner join AdvWrks2022_OLTP.sys.types sys_tp   on sys_tp.user_type_id = user_tp.system_type_id	-- Get the column's "Base System Data NAME", linked To the UNIQUE SDT of a UDT
			inner join #UsedTables ut on ut.SourceSchema = s.name	and ut.SourceTable = t.name				-- Filter only for tables in our metadata list

		where c.name not in ('rowguid')		

				

	-- ==========================================================================
	-- SECTION 4: CONSTRUCT TARGET COLUMN DEFINITIONS
	-- Purpose: Combine the source column properties with the target metadata (aliases, comments)
	--          to build the complete SQL data definition language (DDL) for each column.
	-- ==========================================================================
		
		----- Create a table to hold the final DDL for each target column ------
		drop table if exists #CreateTableColumns 
		create table #CreateTableColumns (
			SourceTable         NVARCHAR(50)    collate SQL_Latin1_General_CP1_CI_AS
			,SourceColumn       NVARCHAR(50)    collate SQL_Latin1_General_CP1_CI_AS
			,TargetColumn		NVARCHAR(128)   collate SQL_Latin1_General_CP1_CI_AS
			,ColumnComment		NVARCHAR(MAX)   collate SQL_Latin1_General_CP1_CI_AS
			,ColumnDefinition	NVARCHAR(MAX)   collate SQL_Latin1_General_CP1_CI_AS
		)
		insert into #CreateTableColumns 
		select
			uc.SourceTable         
			,uc.SourceColumn       
			,uc.TargetColumn		
			,uc.ColumnComment		

			---- Build the full column definition: [Name] [SystemDefined_DataType] [Nullability] [Comment]
			, uc.TargetColumn + ' '
				+ case		----- Map source data types to appropriate SQL Server data types and properties
					when stc.SystemDefined_DataType in ('decimal','numeric')	then stc.SystemDefined_DataType + '(' + CAST(stc.DataPrecision AS VARCHAR) + ', ' + CAST(stc.DataScale AS VARCHAR) + ')'
					when stc.SystemDefined_DataType in ('nchar','varchar','nvarchar')	then stc.SystemDefined_DataType + '(' + CAST(stc.DataLength AS VARCHAR) + ')'
					else stc.SystemDefined_DataType
				end
			+ case when stc.CollationName is not null then ' collate ' + stc.CollationName else ' ' end 
			+ case when stc.IsNullable = 1	then '	Null' else ' Not Null ' end	 ---- Add nullability constraint
			+ ','	as ColumnDefinition
        from 
            #UsedColumns uc
            left join #SourceTableColumns stc ON stc.SourceTable = uc.SourceTable
				and stc.SourceColumn = uc.SourceColumn		--------- Ensure we only get columns defined in our metadata
		end

	-- ==========================================================================
	-- SECTION 5: BUILD AND EXECUTE THE DYNAMIC DDL SCRIPT
	-- Purpose: Assemble the final CREATE TABLE statement by aggregating all column
	--          definitions and then execute it dynamically.
	-- ==========================================================================
		---------------------------------------------------------------------------------------------------

		declare 
			@NamingTableString		nvarchar(max)	-- Holds the full target table name (e.g., 'prod.DimAddress')
			,@DropTableString		nvarchar(max)	-- Holds the DROP TABLE IF EXISTS statement


		-- Determine the full name of the target table based on the target schema
		
		
		set @NamingTableString =	case 
										when LOWER(@TargetTableType)	in ('stg', 'staging','stage')	then  QUOTENAME('stg')+'.'+QUOTENAME(@TargetTable+'_staging')
										when LOWER(@TargetTableType)	in ('dim', 'dimension')			then  QUOTENAME('prod') + '.' + QUOTENAME('Dim' + @TargetTable)
										when LOWER(@TargetTableType)	= 'fact'						then  QUOTENAME('prod') + '.' + QUOTENAME('Fact' + @TargetTable)
										end
	
	
		-- Build the drop statement for the target table
		set @DropTableString = concat('drop table if exists ', @NamingTableString)


		-- Build the main CREATE TABLE statement.
		-- STRING_AGG combines all rows from #CreateTableColumns into a single string, separated by new lines.

		
		select @CreateTableSQL = concat(
										@DropTableString
										,CHAR(13) + CHAR(10)
										,' create table ' ,@NamingTableString,' ('
										,case 
											when @TargetTableType in ('dim', 'dimension') then QUOTENAME(@TargetTable+'DWKey') + '	int identity(1,1),'end 
										,STRING_AGG(ColumnDefinition, CHAR(13) + CHAR(10)) -- Aggregates all lines
										,case 
											when @TargetTableType in ('dim', 'dimension')	then 'IsCurrent bit'	-- Add IsCurrent column for Dimension Tables in prod schema
											
										end 
									,CHAR(13) + CHAR(10) , ');'
										)
		from #CreateTableColumns

		

	
		-- Execute the dynamically built SQL script to create the table
		exec sp_executesql @CreateTableSQL
		
	
		
