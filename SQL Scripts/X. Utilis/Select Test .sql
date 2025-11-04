


select top 5 * from stg.Address_staging
select count(*) from stg.Address_staging

select top 5 * from prod.DimAddress

select * from integration.ETL_Cutoff order by TableName, ETL_CutoffDate

select * from integration.ETL_Lineage order by TableName, ETL_CutoffDate_Start

--truncate table prod.DimAddress
--truncate table stg.Address_staging
--truncate table integration.ETL_Lineage
--truncate table integration.ETL_Cutoff