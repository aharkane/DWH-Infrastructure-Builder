
------ 5.1. integration.Rows_Count_Address


drop procedure if exists integration.Rows_Count_Address
go

create procedure integration.Rows_Count_Address
(
    @New_Rows_Count int output

)
as
begin
    set nocount on;
    set xact_abort on;

    begin try
        begin transaction;

        ------------------------------------------------------------
        -- STEP 1: Rows Count
        ------------------------------------------------------------

       
         -- New_Rows_Count
       select  @New_Rows_Count = count(*) 
        from stg.Address_staging





        --------------------------------------------------------------
        ---- STEP 2: Commit transaction
        --------------------------------------------------------------
        commit transaction;

    end try
    begin catch
        if @@TRANCOUNT > 0 rollback transaction;

        declare @ErrorMessage nvarchar(4000),
                @ErrorSeverity int,
                @ErrorState int;

        select
            @ErrorMessage = error_message(),
            @ErrorSeverity = error_severity(),
            @ErrorState = error_state();

        raiserror(@ErrorMessage, @ErrorSeverity, @ErrorState);
    end catch;
end;
go
