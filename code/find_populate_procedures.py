"""
Script to find stored procedures in TILLDBWeb_Prod that populate tables from TILLDB
"""

import pyodbc
import sys


def get_connection(database: str):
    """Create and return a database connection."""
    server = "tillsqlserver.database.windows.net"
    username = "tillsqladmin"
    password = "Purpl3R31gn"
    
    connection_string = (
        "Driver={{ODBC Driver 18 for SQL Server}};"
        "Server={server};"
        "Database={database};"
        "UID={username};"
        "PWD={password};"
        "Encrypt=yes;"
        "TrustServerCertificate=no;"
        "Connection Timeout=30;"
    ).format(
        server=server,
        database=database,
        username=username,
        password=password
    )
    
    try:
        return pyodbc.connect(connection_string)
    except Exception as e:
        print(f"Error connecting to {database}: {e}")
        sys.exit(1)


def find_populate_procedures():
    """Find stored procedures that populate tables from TILLDB."""
    print(f"\n{'='*80}")
    print("Finding stored procedures in TILLDBWeb_Prod that populate tables from TILLDB")
    print(f"{'='*80}\n")
    
    conn = get_connection("TILLDBWeb_Prod")
    cursor = conn.cursor()
    
    try:
        # Get all stored procedures in dbo schema
        print("Retrieving stored procedures...")
        cursor.execute("""
            SELECT 
                ROUTINE_NAME,
                ROUTINE_DEFINITION
            FROM INFORMATION_SCHEMA.ROUTINES
            WHERE ROUTINE_SCHEMA = 'dbo'
            AND ROUTINE_TYPE = 'PROCEDURE'
            ORDER BY ROUTINE_NAME
        """)
        
        procedures = cursor.fetchall()
        print(f"Found {len(procedures)} stored procedures in dbo schema\n")
        
        # Also get procedure definitions from sys.sql_modules for more complete text
        cursor.execute("""
            SELECT 
                OBJECT_SCHEMA_NAME(p.object_id) AS SCHEMA_NAME,
                p.name AS PROCEDURE_NAME,
                m.definition AS PROCEDURE_DEFINITION
            FROM sys.procedures p
            INNER JOIN sys.sql_modules m ON p.object_id = m.object_id
            WHERE OBJECT_SCHEMA_NAME(p.object_id) = 'dbo'
            ORDER BY p.name
        """)
        
        procedure_definitions = {}
        for row in cursor.fetchall():
            schema_name, proc_name, definition = row
            if definition:
                procedure_definitions[proc_name] = definition
        
        # Keywords that indicate procedures that populate data from TILLDB
        keywords = [
            'TILLDB',
            'INSERT INTO',
            'INSERT',
            'UPDATE',
            'MERGE',
            'SELECT INTO',
            'FROM TILLDB',
            'TILLDB.dbo',
            'TILLDB..',
            'EXEC TILLDB',
            'EXECUTE TILLDB'
        ]
        
        # Tables that were identified as needing new fields
        target_tables = [
            'catStaffEmailAddresses',
            'tblPeopleClientsDayServices',
            'tblPeopleDayAttendance',
            'tblPeopleScheduledStaffChanges'
        ]
        
        matching_procedures = []
        
        print("Analyzing stored procedures...\n")
        
        for proc_name, definition in procedure_definitions.items():
            if not definition:
                continue
            
            definition_upper = definition.upper()
            matches = []
            
            # Check for TILLDB references
            if 'TILLDB' in definition_upper:
                matches.append("References TILLDB database")
            
            # Check for INSERT/UPDATE/MERGE operations
            has_insert = 'INSERT' in definition_upper
            has_update = 'UPDATE' in definition_upper
            has_merge = 'MERGE' in definition_upper
            has_select_into = 'SELECT INTO' in definition_upper
            
            if has_insert or has_update or has_merge or has_select_into:
                operations = []
                if has_insert:
                    operations.append("INSERT")
                if has_update:
                    operations.append("UPDATE")
                if has_merge:
                    operations.append("MERGE")
                if has_select_into:
                    operations.append("SELECT INTO")
                matches.append(f"Contains data modification operations: {', '.join(operations)}")
            
            # Check if it references any of our target tables
            referenced_tables = []
            for table in target_tables:
                if table.upper() in definition_upper:
                    referenced_tables.append(table)
            
            if referenced_tables:
                matches.append(f"References tables: {', '.join(referenced_tables)}")
            
            # If it has TILLDB reference AND data modification, it's likely a populate procedure
            if ('TILLDB' in definition_upper) and (has_insert or has_update or has_merge or has_select_into):
                matching_procedures.append({
                    'name': proc_name,
                    'definition': definition,
                    'matches': matches,
                    'referenced_tables': referenced_tables
                })
        
        # Print results
        print(f"{'='*80}")
        print("STORED PROCEDURES THAT POPULATE TABLES FROM TILLDB")
        print(f"{'='*80}\n")
        
        if matching_procedures:
            print(f"Found {len(matching_procedures)} stored procedure(s):\n")
            
            for proc in matching_procedures:
                print(f"Procedure: {proc['name']}")
                for match in proc['matches']:
                    print(f"  - {match}")
                if proc['referenced_tables']:
                    print(f"  - Affected tables: {', '.join(proc['referenced_tables'])}")
                print()
        else:
            print("No stored procedures found that match the criteria.")
            print("\nSearching for all procedures with INSERT/UPDATE operations...\n")
            
            # Fallback: show all procedures with data modification
            all_modification_procs = []
            for proc_name, definition in procedure_definitions.items():
                if not definition:
                    continue
                definition_upper = definition.upper()
                if 'INSERT' in definition_upper or 'UPDATE' in definition_upper or 'MERGE' in definition_upper:
                    all_modification_procs.append(proc_name)
            
            if all_modification_procs:
                print(f"Found {len(all_modification_procs)} procedure(s) with data modification operations:")
                for proc_name in sorted(all_modification_procs):
                    print(f"  - {proc_name}")
            else:
                print("No procedures found with data modification operations.")
        
        print(f"\n{'='*80}\n")
        
        return matching_procedures
        
    finally:
        conn.close()


def list_all_procedures():
    """List all stored procedures for reference."""
    print(f"\n{'='*80}")
    print("ALL STORED PROCEDURES IN TILLDBWeb_Prod (dbo schema)")
    print(f"{'='*80}\n")
    
    conn = get_connection("TILLDBWeb_Prod")
    cursor = conn.cursor()
    
    try:
        cursor.execute("""
            SELECT 
                ROUTINE_NAME,
                CREATED,
                LAST_ALTERED
            FROM INFORMATION_SCHEMA.ROUTINES
            WHERE ROUTINE_SCHEMA = 'dbo'
            AND ROUTINE_TYPE = 'PROCEDURE'
            ORDER BY ROUTINE_NAME
        """)
        
        procedures = cursor.fetchall()
        print(f"Total procedures: {len(procedures)}\n")
        
        for row in procedures:
            proc_name, created, altered = row
            print(f"  - {proc_name}")
            if created:
                print(f"    Created: {created}")
            if altered:
                print(f"    Last Altered: {altered}")
            print()
        
    finally:
        conn.close()


if __name__ == "__main__":
    # Find procedures that populate from TILLDB
    matching_procedures = find_populate_procedures()
    
    # Also list all procedures for reference
    list_all_procedures()

