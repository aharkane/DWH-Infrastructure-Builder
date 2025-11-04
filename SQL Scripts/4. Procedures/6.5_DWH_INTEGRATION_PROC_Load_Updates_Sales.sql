



---- 6.5. integration.LoadUpdates_Sales
drop procedure if exists integration.Load_Updates_Sales 
go

create procedure integration.Load_Updates_Sales


as
begin
    set nocount on;
    set xact_abort on;

    begin try
        begin transaction;
	
--- Insert into FactSales

insert into prod.FactSales
select * from stg.Sales_staging

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
end
