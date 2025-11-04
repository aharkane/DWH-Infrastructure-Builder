drop procedure if exists integration.Update_Control_Tables;
go

create procedure integration.Update_Control_Tables
(   @TableName      nvarchar(128)
    ,@ETL_LineageKey int
    ,@ETL_CutoffDate datetime2(3)
    ,@CurrentDate datetime2(3)
    ,@New_Rows_Count int
    ,@SCD2_Rows_Count int
    ,@SCD1_Rows_Count int
)
as
begin
    set nocount on;
    set xact_abort on;
    
    --begin try
    begin transaction
        
        ----  1. Update ETL Lineage Table 
        update integration.ETL_Lineage
        set 
            IsSuccessful = 1
            ,ETL_CutoffDate_End = DATEADD(MILLISECOND,DATEDIFF(Second, @CurrentDate, SYSDATETIME()),@ETL_CutoffDate)
            ,ETL_TimeDuration_MilliSec = DATEDIFF(MILLISECOND, @CurrentDate, SYSDATETIME())
            ,New_Rows_Count =  @New_Rows_Count
            ,SCD2_Rows_Count = @SCD2_Rows_Count
            ,SCD1_Rows_Count = @SCD1_Rows_Count

        where ETL_LineageKey = @ETL_LineageKey;
        
        -----  2. Update ETL Cutoff Table 
        update integration.ETL_Cutoff
        set ETL_CutoffDate = @ETL_CutoffDate
        where TableName = @TableName
   
   commit transaction


end
