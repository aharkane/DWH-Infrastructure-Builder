# 📁 Project Structure

Based on your current organization at:  
`D:\JupyterNotebooks_dir\Github Projects\4. SSIS\1. DWH Infrastructure Builder`

```
1. DWH Infrastructure Builder/
│
├── 📂 Source DB/
│   ├── AdvWrks2022_OLTP_Backup.bak
│
├── 📂 Documentation/
│   ├── Data-Dictionnary.xlsx                    # Complete data dictionary (44 KB)
│   ├── OLTP-Tables-Diagram-and-listing.md       # Visual table relationships (8.6 KB)
│   └── OLT-Tables-List.md                       # Source table listing (5.2 KB)
│
├── 📂 ETL/
│   └── ETL.xml                                  # SSIS Package - Complete ETL workflow (150 KB)
│
├── 📂 SQL Scripts/
│   │
│   ├── 📂 0. Master Scripts/
│   │   ├── Master.sql                           # Main orchestration script (2 KB)
│   │   └── 📂 Sub-Master Scripts/
│   │       ├── 1_Run_Control_Procedure_and_Tables.sql         (1.2 KB)
│   │       ├── 2_Run_Create_Tables_Mappings.sql               (1.7 KB)
│   │       ├── 3_Execute_Procedure_TableGenerator.sql         (2.6 KB)
│   │       ├── 4_Run_Procedures_Get_Updates_Tables.sql        (1 KB)
│   │       ├── 5_Run_Procedures_Rows_Count.sql                (1 KB)
│   │       └── 6_Run_Procedures_Load_Updates_Table.sql        (1 KB)
│   │
│   ├── 📂 1. DWH Architecture/
│   │   └── 1_DWH_INTEGRATION_Create_DatabaseSchemas.sql       (199 bytes)
│   │
│   ├── 📂 2. DWH Tables Mappings/
│   │   ├── 1_DWH_METADATA_Mapping_Address.sql                 (1.9 KB)
│   │   ├── 2_DWH_METADATA_Mapping_Customer.sql                (2.2 KB)
│   │   ├── 3_DWH_METADATA_Mapping_Product.sql                 (2.5 KB)
│   │   ├── 4_DWH_METADATA_Mapping_SalesPerson.sql             (2.2 KB)
│   │   ├── 5_DWH_METADATA_Mapping_Sales.sql                   (2.8 KB)
│   │   └── 6_DWH_METADATA_Mapping_Cleanup.sql                 (925 bytes)
│   │
│   ├── 📂 3. Control Tables/
│   │   └── 1_DWH_INTEGRATION_Create_ControlTables.sql         (597 bytes)
│   │
│   ├── 📂 4. Procedures/
│   │   ├── 1_DWH_INTEGRATION_PROC_TableGenerator.sql          (10.5 KB) ⭐ Core
│   │   ├── 2_DWH_INTEGRATION_PROC_Get_Last_ETL_CutoffDate.sql (466 bytes)
│   │   ├── 3_DWH_INTEGRATION_PROC_Get_Last_ETL_LineageKey.sql (845 bytes)
│   │   │
│   │   ├── 4.1_DWH_INTEGRATION_PROC_Get_Updates_Address.sql        (2.8 KB)
│   │   ├── 4.2_DWH_INTEGRATION_PROC_Get_Updates_Customer.sql       (3.3 KB)
│   │   ├── 4.3_DWH_INTEGRATION_PROC_Get_Updates_Product.sql        (3.4 KB)
│   │   ├── 4.4_DWH_INTEGRATION_PROC_Get_Updates_SalesPerson.sql    (3.1 KB)
│   │   ├── 4.5_DWH_INTEGRATION_PROC_Get_Updates_Sales.sql          (3.4 KB)
│   │   │
│   │   ├── 5.1_DWH_INTEGRATION_PROC_Rows_Count_Address.sql         (1.3 KB)
│   │   ├── 5.2_DWH_INTEGRATION_PROC_Rows_Count_Customer.sql        (2.8 KB)
│   │   ├── 5.3_DWH_INTEGRATION_PROC_Rows_Count_Product.sql         (3.5 KB)
│   │   ├── 5.4_DWH_INTEGRATION_PROC_Rows_Count_SalesPerson.sql     (2.5 KB)
│   │   ├── 5.5_DWH_INTEGRATION_PROC_Rows_Count_Sales.sql           (806 bytes)
│   │   │
│   │   ├── 6.1_DWH_INTEGRATION_PROC_Load_Updates_Address.sql       (2.8 KB)
│   │   ├── 6.2_DWH_INTEGRATION_PROC_Load_Updates_Customer.sql      (4.3 KB)
│   │   ├── 6.3_DWH_INTEGRATION_PROC_Load_Updates_Product.sql       (5.8 KB)
│   │   ├── 6.4_DWH_INTEGRATION_PROC_Load_Updates_SalesPerson.sql   (3.7 KB)
│   │   ├── 6.5_DWH_INTEGRATION_PROC_Load_Updates_Sales.sql         (778 bytes)
│   │   │
│   │   └── 7_DWH_INTEGRATION_PROC_Update_Control_Tables.sql        (1.2 KB)
│   │
│   └── 📂 X. Utilis/
│       ├── Select-Test.sql                                    (440 bytes)
│       ├── X1_DWH_UTILIS_-Clean_DWH.sql                       (709 bytes)
│       ├── X2_OLTP_TEST_AllDimensionData.sql                  (10.7 KB)
│       ├── X3_OLTP_PREP_AddValidityColumns.sql                (3.3 KB)
│       └── X4_OLTP_METADATA_PROC_Inject_SCD_Changes.sql       (8.8 KB)
│
└── README.md                                     # Main project documentation
```

---

## 📊 File Organization Summary

### **Total Files: 43**

| Category | Files | Total Size | Description |
|----------|-------|------------|-------------|
| **Documentation** | 3 | 58 KB | Data dictionary and table diagrams |
| **ETL Package** | 1 | 150 KB | SSIS package with complete workflow |
| **Master Scripts** | 7 | 10 KB | Orchestration and deployment scripts |
| **Architecture** | 1 | 199 bytes | Database schema creation |
| **Metadata Mappings** | 6 | 12 KB | Table mapping definitions |
| **Control Tables** | 1 | 597 bytes | ETL control framework |
| **Procedures** | 19 | 57 KB | Core ETL stored procedures |
| **Testing & Utilities** | 5 | 24 KB | Test data and cleanup scripts |

---

## 🔢 Procedure Breakdown by Function

### **Core Framework (3 procedures)**
- Table Generator - Metadata-driven table creation
- Get Last ETL Cutoff Date - Incremental load tracking
- Get Last ETL Lineage Key - Audit trail management

### **Extract Phase (5 procedures)**
- Get Updates for: Address, Customer, Product, SalesPerson, Sales
- Purpose: Pull incremental changes from OLTP source

### **Transform Phase (5 procedures)**
- Rows Count for: Address, Customer, Product, SalesPerson, Sales
- Purpose: Calculate New, SCD1, and SCD2 row counts

### **Load Phase (5 procedures)**
- Load Updates for: Address, Customer, Product, SalesPerson, Sales
- Purpose: Apply SCD Type 0, 1, and 2 logic to DWH

### **Control Phase (1 procedure)**
- Update Control Tables
- Purpose: Maintain ETL lineage and cutoff dates

---

## 📂 Folder Purpose & Execution Order

### **0. Master Scripts**
**Purpose**: Single-click deployment and orchestration  
**Execute**: Run `Master.sql` to deploy entire infrastructure  
**Contains**: 
- Main orchestration script
- 6 sub-scripts that execute in sequence

### **1. DWH Architecture**
**Purpose**: Create foundational database schemas  
**Creates**: `stg`, `prod`, `integration`, `metadata` schemas  
**Execute First**: Before any other scripts

### **2. DWH Tables Mappings**
**Purpose**: Define metadata that drives the entire ETL  
**Defines**: 
- Source-to-target table mappings
- Column transformations
- SCD type specifications
**Execute**: After architecture, before table generation

### **3. Control Tables**
**Purpose**: ETL audit trail and incremental load tracking  
**Creates**: 
- `integration.ETLLineage` - Execution tracking
- `integration.ETLCutoff` - Last successful load dates

### **4. Procedures**
**Purpose**: All ETL logic encapsulated in stored procedures  
**Organization**: 
- Numbered 1-7 for execution sequence
- Sub-numbered (4.1-4.5, 5.1-5.5, 6.1-6.5) for parallel execution
**Total**: 19 procedures handling Extract, Transform, Load, Control

### **X. Utilis**
**Purpose**: Testing, validation, and maintenance utilities  
**Contains**:
- Test data generation
- SCD change simulation
- DWH cleanup scripts
- Validation queries

---

## 🚀 Deployment Sequence

### **Option 1: Automated (Recommended)**
```sql
-- Single command deploys everything
:r "SQL Scripts/0. Master Scripts/Master.sql"
```

### **Option 2: Manual Step-by-Step**
```sql
-- Step 1: Create schemas
:r "SQL Scripts/1. DWH Architecture/1_DWH_INTEGRATION_Create_DatabaseSchemas.sql"

-- Step 2: Create control tables
:r "SQL Scripts/3. Control Tables/1_DWH_INTEGRATION_Create_ControlTables.sql"

-- Step 3: Create metadata mappings (all 6 files)
:r "SQL Scripts/2. DWH Tables Mappings/1_DWH_METADATA_Mapping_Address.sql"
-- ... execute all mapping files ...

-- Step 4: Create procedures (all 19 files)
:r "SQL Scripts/4. Procedures/1_DWH_INTEGRATION_PROC_TableGenerator.sql"
-- ... execute all procedure files ...

-- Step 5: Generate tables from metadata
EXEC metadata.TableGenerator @TargetTableType='stg', @TargetTable='Address';
EXEC metadata.TableGenerator @TargetTableType='dim', @TargetTable='Address';
-- ... repeat for all dimensions and fact ...

-- Step 6: Prepare OLTP source
:r "SQL Scripts/X. Utilis/X3_OLTP_PREP_AddValidityColumns.sql"
```

---

## 📝 File Naming Convention

Your project uses a clear, logical naming convention:

### **Prefix System**
- **Numbers (0-9)**: Execution order and deployment sequence
- **X prefix**: Utility scripts (testing, cleanup, preparation)
- **Decimal notation (4.1, 5.2)**: Sub-categories within main sequence

### **Naming Pattern**
```
[Order]_[Layer]_[Function]_[Entity].sql

Examples:
1_DWH_INTEGRATION_Create_DatabaseSchemas.sql
    ↓         ↓           ↓            ↓
  Order    Layer      Function      What

4.2_DWH_INTEGRATION_PROC_Get_Updates_Customer.sql
  ↓         ↓           ↓         ↓         ↓
Order    Layer      Type      Action    Entity
```

### **Layer Indicators**
- `DWH_INTEGRATION`: Integration layer procedures
- `DWH_METADATA`: Metadata mappings
- `DWH_UTILIS`: Utility scripts
- `OLTP_TEST`: OLTP test data
- `OLTP_PREP`: OLTP preparation
- `OLTP_METADATA`: OLTP metadata procedures

### **Function Keywords**
- `Create`: DDL for creating objects
- `PROC`: Stored procedure
- `Get_Updates`: Extract phase
- `Rows_Count`: Transform phase (counting)
- `Load_Updates`: Load phase
- `Update`: Maintenance operations

---

## 📏 Project Statistics

- **Total Scripts**: 43 files
- **Total Code Size**: ~312 KB
- **Stored Procedures**: 19 procedures
- **Metadata Mappings**: 6 mappings (5 dimensions + 1 fact)
- **Utility Scripts**: 5 testing/maintenance scripts
- **Documentation Files**: 3 comprehensive docs
- **Lines of Code**: ~3,500+ lines of T-SQL
- **SSIS Package**: 1 production-ready ETL workflow

---

