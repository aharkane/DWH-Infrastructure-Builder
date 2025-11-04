USE AdvWrks2022_DWH
GO


--------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------- Execute PROC metadata.TableGenerator  -------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------------

-------------------------------------------
------- Creat Staging Tables ------------
-------------------------------------------
----- Adress Tables  ------
EXEC metadata.TableGenerator
    @TargetTableType = 'stg'
    ,@TargetTable = 'Address'

----- Customer Tables  ------
    EXEC metadata.TableGenerator
    @TargetTableType = 'stg'
    ,@TargetTable = 'Customer'


----- Product Tables  ------
    EXEC metadata.TableGenerator
    @TargetTableType = 'stg'
    ,@TargetTable = 'Product'

----- SalesPerson Tables  ------
    EXEC metadata.TableGenerator
    @TargetTableType = 'stg'
    ,@TargetTable = 'SalesPerson'

----- Sales Tables  ------
EXEC metadata.TableGenerator
    @TargetTableType = 'stg'
    ,@TargetTable = 'Sales'

-------------------------------------------
------- Creat Dimension Tables ------------
-------------------------------------------

----- Adress Tables  ------
EXEC metadata.TableGenerator
    @TargetTableType = 'dim'
    ,@TargetTable = 'Address'
GO

----- Customer Tables  ------
    EXEC metadata.TableGenerator
    @TargetTableType = 'dim'
    ,@TargetTable = 'Customer'
GO

----- Product Tables  ------
    EXEC metadata.TableGenerator
    @TargetTableType = 'dim'
    ,@TargetTable = 'Product'
GO

----- SalesPerson Tables  ------
    EXEC metadata.TableGenerator
    @TargetTableType = 'dim'
    ,@TargetTable = 'SalesPerson'
GO

----- Sales Tables  ------
EXEC metadata.TableGenerator
    @TargetTableType = 'fact'
    ,@TargetTable = 'Sales'
GO
--------------------------------------------------------------------------------------------------------------
---------------------------------------------- Drop Metadata Mapping Tables ----------------------------------
--------------------------------------------------------------------------------------------------------------
:setvar TablesMappingPath "D:\JupyterNotebooks_dir\Github Projects\4. SSIS\1. DWH Infrastructure Builder\SQL Scripts\2. DWH Tables Mappings"
GO
:r ""$(TablesMappingPath)\6_DWH_METADATA_Mapping_Cleanup.sql""