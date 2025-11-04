# Installation Guide

## Prerequisites

Before you begin, ensure you have the following software installed:

### Required Software
- **SQL Server 2019 or later** (Developer or Express Edition)
  - Download: [SQL Server Downloads](https://www.microsoft.com/sql-server/sql-server-downloads)
- **SQL Server Management Studio (SSMS) 18.0+**
  - Download: [SSMS Download](https://learn.microsoft.com/en-us/sql/ssms/download-sql-server-management-studio-ssms)
- **SQL Server Integration Services (SSIS)**
  - Included with SQL Server installation
- **AdventureWorks2022 Sample Database**
  - Download: [AdventureWorks GitHub](https://github.com/Microsoft/sql-server-samples/releases)

### System Requirements
- Windows 10/11 or Windows Server 2016+
- Minimum 4GB RAM (8GB recommended)
- 10GB free disk space
- .NET Framework 4.7.2 or later

---

## Step-by-Step Installation

### 1. Install SQL Server

1. Download SQL Server Developer Edition (free)
2. Run the installer and select "Custom" installation
3. Select features:
   - Database Engine Services
   - Integration Services
   - Management Tools (or install SSMS separately)
4. Configure the instance:
   - Use default instance or specify named instance
   - Authentication mode: Mixed Mode (recommended for development)
   - Set SA password
5. Complete the installation

### 2. Install SQL Server Management Studio (SSMS)

1. Download SSMS installer
2. Run the installer (SSMSSetup.exe)
3. Follow the installation wizard
4. Launch SSMS and connect to your SQL Server instance

### 3. Setup AdventureWorks OLTP Database

```sql
-- Option 1: Restore from backup
RESTORE DATABASE AdventureWorks2022OLTP
FROM DISK = 'C:\Path\To\AdventureWorks2022.bak'
WITH MOVE 'AdventureWorks2022' TO 'C:\SQL\Data\AdventureWorks2022OLTP.mdf',
     MOVE 'AdventureWorks2022_log' TO 'C:\SQL\Log\AdventureWorks2022OLTP_log.ldf',
     REPLACE;

-- Option 2: Download and attach MDF file
-- Download the .mdf and .ldf files
-- Right-click Databases in SSMS > Attach
-- Browse to the .mdf file location
```

### 4. Create Data Warehouse Database

```sql
-- Create empty database for DWH
USE master;
GO

CREATE DATABASE AdventureWorks2022DWH
ON PRIMARY 
(
    NAME = 'AdventureWorks2022DWH_Data',
    FILENAME = 'C:\SQL\Data\AdventureWorks2022DWH.mdf',
    SIZE = 100MB,
    MAXSIZE = UNLIMITED,
    FILEGROWTH = 10MB
)
LOG ON 
(
    NAME = 'AdventureWorks2022DWH_Log',
    FILENAME = 'C:\SQL\Log\AdventureWorks2022DWH_log.ldf',
    SIZE = 50MB,
    MAXSIZE = UNLIMITED,
    FILEGROWTH = 10MB
);
GO

-- Set recovery model
ALTER DATABASE AdventureWorks2022DWH SET RECOVERY SIMPLE;
GO
```

---

## Deploy the Data Warehouse

### Method 1: Using Master Script (Recommended)

1. Clone or download this repository
2. Open SSMS and connect to your SQL Server instance
3. Set the database context to AdventureWorks2022DWH
4. Navigate to `0-OLTP-Setup` folder
5. Open `Master.sql` in SSMS
6. **Important**: Update the file paths in Master.sql to match your local directory:

```sql
-- Before running, update these paths:
setvar ProceduresPath "C:\YourPath\enterprise-data-warehouse\0-OLTP-Setup\"
```

7. Execute the Master.sql script (F5)
8. Wait for all scripts to complete (approximately 2-3 minutes)

### Method 2: Manual Execution (Step-by-Step)

Execute scripts in this order:

#### Phase 1: Infrastructure Setup
```sql
-- 1. Create database schemas
:r 1-Infrastructure/1_DWH_INTEGRATION_Create_DatabaseSchemas.sql
GO

-- 2. Create control tables
:r 1-Infrastructure/1_DWH_INTEGRATION_Create_ControlTables.sql
GO
```

#### Phase 2: Metadata Setup
```sql
-- 3. Create metadata mappings for each dimension
:r 2-Metadata-Mappings/1_DWH_METADATA_Mapping_Address.sql
:r 2-Metadata-Mappings/2_DWH_METADATA_Mapping_Customer.sql
:r 2-Metadata-Mappings/3_DWH_METADATA_Mapping_Product.sql
:r 2-Metadata-Mappings/4_DWH_METADATA_Mapping_SalesPerson.sql
:r 2-Metadata-Mappings/5_DWH_METADATA_Mapping_Sales.sql
GO

-- 4. Run cleanup if needed
:r 2-Metadata-Mappings/6_DWH_METADATA_Mapping_Cleanup.sql
GO
```

#### Phase 3: Core Integration Procedures
```sql
-- 5. Create core procedures
:r 3-Integration-Procedures/Core/1_DWH_INTEGRATION_PROC_TableGenerator.sql
:r 3-Integration-Procedures/Core/2_DWH_INTEGRATION_PROC_Get_Last_ETL_CutoffDate.sql
:r 3-Integration-Procedures/Core/3_DWH_INTEGRATION_PROC_Get_Last_ETL_LineageKey.sql
GO

-- 6. Generate all dimension and staging tables
EXEC metadata.TableGenerator @TargetTableType = 'stg', @TargetTable = 'Address';
EXEC metadata.TableGenerator @TargetTableType = 'dim', @TargetTable = 'Address';

EXEC metadata.TableGenerator @TargetTableType = 'stg', @TargetTable = 'Customer';
EXEC metadata.TableGenerator @TargetTableType = 'dim', @TargetTable = 'Customer';

EXEC metadata.TableGenerator @TargetTableType = 'stg', @TargetTable = 'Product';
EXEC metadata.TableGenerator @TargetTableType = 'dim', @TargetTable = 'Product';

EXEC metadata.TableGenerator @TargetTableType = 'stg', @TargetTable = 'SalesPerson';
EXEC metadata.TableGenerator @TargetTableType = 'dim', @TargetTable = 'SalesPerson';

EXEC metadata.TableGenerator @TargetTableType = 'stg', @TargetTable = 'Sales';
EXEC metadata.TableGenerator @TargetTableType = 'fact', @TargetTable = 'Sales';
GO
```

#### Phase 4: ETL Procedures
```sql
-- 7. Create Get Updates procedures
:r 3-Integration-Procedures/Get-Updates/4.1_DWH_INTEGRATION_PROC_Get_Updates_Address.sql
:r 3-Integration-Procedures/Get-Updates/4.2_DWH_INTEGRATION_PROC_Get_Updates_Customer.sql
:r 3-Integration-Procedures/Get-Updates/4.3_DWH_INTEGRATION_PROC_Get_Updates_Product.sql
:r 3-Integration-Procedures/Get-Updates/4.4_DWH_INTEGRATION_PROC_Get_Updates_SalesPerson.sql
:r 3-Integration-Procedures/Get-Updates/4.5_DWH_INTEGRATION_PROC_Get_Updates_Sales.sql
GO

-- 8. Create Rows Count procedures
:r 3-Integration-Procedures/Rows-Count/5.1_DWH_INTEGRATION_PROC_Rows_Count_Address.sql
:r 3-Integration-Procedures/Rows-Count/5.2_DWH_INTEGRATION_PROC_Rows_Count_Customer.sql
:r 3-Integration-Procedures/Rows-Count/5.3_DWH_INTEGRATION_PROC_Rows_Count_Product.sql
:r 3-Integration-Procedures/Rows-Count/5.4_DWH_INTEGRATION_PROC_Rows_Count_SalesPerson.sql
:r 3-Integration-Procedures/Rows-Count/5.5_DWH_INTEGRATION_PROC_Rows_Count_Sales.sql
GO

-- 9. Create Load Updates procedures
:r 3-Integration-Procedures/Load-Updates/6.1_DWH_INTEGRATION_PROC_Load_Updates_Address.sql
:r 3-Integration-Procedures/Load-Updates/6.2_DWH_INTEGRATION_PROC_Load_Updates_Customer.sql
:r 3-Integration-Procedures/Load-Updates/6.3_DWH_INTEGRATION_PROC_Load_Updates_Product.sql
:r 3-Integration-Procedures/Load-Updates/6.4_DWH_INTEGRATION_PROC_Load_Updates_SalesPerson.sql
:r 3-Integration-Procedures/Load-Updates/6.5_DWH_INTEGRATION_PROC_Load_Updates_Sales.sql
GO

-- 10. Create control update procedure
:r 4-Control-Update/7_DWH_INTEGRATION_PROC_Update_Control_Tables.sql
GO
```

#### Phase 5: Prepare OLTP Source
```sql
-- 11. Add validity date columns to OLTP tables
USE AdventureWorks2022OLTP;
GO
:r 6-Testing-Utilities/X3_OLTP_PREP_AddValidityColumns.sql
GO
```

---

## Verify Installation

### 1. Check Database Objects

```sql
USE AdventureWorks2022DWH;
GO

-- Verify schemas
SELECT name FROM sys.schemas 
WHERE name IN ('stg', 'prod', 'integration', 'metadata')
ORDER BY name;

-- Expected output: 4 schemas

-- Verify tables
SELECT 
    s.name AS SchemaName,
    t.name AS TableName,
    (SELECT COUNT(*) FROM sys.columns c WHERE c.object_id = t.object_id) AS ColumnCount
FROM sys.tables t
INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
ORDER BY s.name, t.name;

-- Expected output: 
-- stg: 5 staging tables
-- prod: 5 dimension/fact tables  
-- integration: 2 control tables
-- metadata: 10+ metadata tables

-- Verify stored procedures
SELECT 
    s.name AS SchemaName,
    p.name AS ProcedureName
FROM sys.procedures p
INNER JOIN sys.schemas s ON p.schema_id = s.schema_id
ORDER BY s.name, p.name;

-- Expected output: 37+ stored procedures
```

### 2. Test Initial Data Load

```sql
-- Declare variables
DECLARE @ETLCutoffDate DATETIME2(3) = '2010-01-01';
DECLARE @ETLCutoffDatePrev DATETIME2(3) = '1900-01-01';
DECLARE @CurrentDate DATETIME2(3) = GETDATE();
DECLARE @NewRowsCount INT;
DECLARE @SCD1RowsCount INT;
DECLARE @SCD2RowsCount INT;
DECLARE @ETLLineageKey INT;

-- Test Address dimension load
EXEC integration.GetUpdatesAddress @ETLCutoffDate, @ETLCutoffDatePrev;
EXEC integration.RowsCountAddress @NewRowsCount OUTPUT;
EXEC integration.LoadUpdatesAddress;

-- Verify data
SELECT COUNT(*) AS AddressCount FROM prod.DimAddress;
-- Expected: ~450 records

-- Verify control tables
SELECT * FROM integration.ETLLineage ORDER BY ETLLineageKey DESC;
SELECT * FROM integration.ETLCutoff;
```

### 3. Test SSIS Package (Optional)

1. Open SQL Server Data Tools or Visual Studio
2. Import the SSIS package from `5-SSIS-Package/ETL.xml`
3. Configure connection manager to point to your SQL Server instance
4. Execute the package
5. Verify all dimensions and fact table are loaded

---

## Troubleshooting

### Common Issues

#### Issue 1: "Database does not exist" error
**Solution**: Ensure you've created the AdventureWorks2022DWH database first

```sql
-- Check if database exists
SELECT name FROM sys.databases WHERE name = 'AdventureWorks2022DWH';

-- If not exists, create it
CREATE DATABASE AdventureWorks2022DWH;
```

#### Issue 2: "Invalid object name" error
**Solution**: Make sure you're in the correct database context

```sql
-- Always specify database context
USE AdventureWorks2022DWH;
GO
```

#### Issue 3: File path errors in Master.sql
**Solution**: Update the `setvar ProceduresPath` to your local directory path

```sql
-- Example for Windows
setvar ProceduresPath "C:\Users\YourName\Documents\enterprise-data-warehouse\"

-- Use forward slashes if needed
setvar ProceduresPath "C:/Users/YourName/Documents/enterprise-data-warehouse/"
```

#### Issue 4: Permission errors
**Solution**: Ensure your SQL login has db_owner permissions

```sql
-- Grant permissions
USE AdventureWorks2022DWH;
GO
ALTER ROLE db_owner ADD MEMBER [YourLoginName];
GO
```

#### Issue 5: Metadata tables not populated
**Solution**: Run the metadata mapping scripts again

```sql
-- Re-run all metadata mapping scripts
:r 2-Metadata-Mappings/1_DWH_METADATA_Mapping_Address.sql
-- ... repeat for all mapping files
```

---

## Uninstallation

To remove the data warehouse:

```sql
-- Drop the DWH database
USE master;
GO
DROP DATABASE IF EXISTS AdventureWorks2022DWH;
GO

-- Remove validity columns from OLTP (optional)
USE AdventureWorks2022OLTP;
GO
-- Manually remove ValidityDate_Start and ValidityDate_End columns
-- from each table if you want to clean up the OLTP source
```

---

## Next Steps

After successful installation:

1. **Review the Documentation**: Read through the main README.md
2. **Explore the Data Model**: Check out the star schema in prod schema
3. **Test SCD Changes**: Run the SCD simulation script
4. **Run Incremental Loads**: Execute the ETL package multiple times
5. **Build Reports**: Connect Power BI or Tableau to the prod schema

---

## Support

If you encounter issues during installation:

1. Check the [Troubleshooting](#troubleshooting) section
2. Review SQL Server error logs
3. Open an issue on GitHub with:
   - SQL Server version
   - Error message
   - Steps to reproduce
   - Screenshots if applicable

---

**Installation Complete! 🎉**

You now have a fully functional enterprise data warehouse. Proceed to the main [README.md](../README.md) to learn how to use it.
