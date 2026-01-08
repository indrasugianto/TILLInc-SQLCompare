# TILLInc SQL Database Comparison Tool

A Python-based toolset for comparing and synchronizing SQL Azure database structures between TILLDB and TILLDBWeb_Prod databases.

## Project Structure

```
TILLInc-SQLCompare/
├── code/                    # Python utility scripts
│   ├── compare_databases.py      # Compare table structures between databases
│   ├── check_new_tables.py      # Find tables in TILLDB not in TILLDBWeb_Prod
│   ├── find_populate_procedures.py  # Find stored procedures that populate tables
│   ├── get_table_structure.py   # Get structure of a specific table
│   └── requirements.txt          # Python dependencies
├── docs/                    # Documentation and analysis files
│   ├── affected_tables_and_fields.txt
│   ├── catMassHealthServiceLevels_implementation_summary.txt
│   ├── new_tables_analysis.txt
│   └── new_tables_in_TILLDB.txt
└── sql/                     # SQL scripts
    └── MASTER_UPDATE_SCRIPT.sql  # Combined update script for TILLDBWeb_Prod
```

## Prerequisites

- Python 3.7+
- ODBC Driver 18 for SQL Server (or Driver 17)
- Azure SQL Server access credentials

## Quick Start

1. **Install dependencies:**
   ```bash
   pip install -r code/requirements.txt
   ```

2. **Configure connection details** in the Python scripts (server, username, password)

3. **Run comparison tools:**
   ```bash
   cd code
   python compare_databases.py
   python check_new_tables.py
   python find_populate_procedures.py
   ```

## Available Tools

### `compare_databases.py`
Compares table structures between TILLDB and TILLDBWeb_Prod:
- Table existence
- Column definitions (data types, nullability, defaults)
- Primary keys and foreign keys
- Identifies tables with new fields

### `check_new_tables.py`
Finds tables that exist in TILLDB but not in TILLDBWeb_Prod.

### `find_populate_procedures.py`
Identifies stored procedures in TILLDBWeb_Prod that populate data from TILLDB.

### `get_table_structure.py`
Retrieves the complete structure of a specific table for analysis.

## Master Update Script

The `sql/MASTER_UPDATE_SCRIPT.sql` file contains a consolidated script that:
- Adds new fields to existing tables in TILLDBWeb_Prod
- Creates new tables (e.g., `catMassHealthServiceLevels`)
- Updates stored procedures to include new fields in data population

**⚠️ Important:** Always test in a non-production environment and backup the database before executing.

## Configuration

Connection details are configured in each script's `main()` function:
- Server: `tillsqlserver.database.windows.net`
- Username: `tillsqladmin`
- Databases: `TILLDB` and `TILLDBWeb_Prod`
- Schema: `dbo`

## Troubleshooting

**ODBC Driver Issues:**
- Install ODBC Driver 18 for SQL Server from [Microsoft](https://learn.microsoft.com/en-us/sql/connect/odbc/download-odbc-driver-for-sql-server)
- Or use Driver 17 by modifying the connection string in scripts
- Check available drivers: `odbcinst -q -d` (Windows)

**Connection Errors:**
- Verify Azure SQL Server firewall rules allow your IP address
- Check username and password credentials
- Ensure SSL/TLS settings match your server configuration

