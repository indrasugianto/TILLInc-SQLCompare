"""
Script to check for tables in TILLDB that don't exist in TILLDBWeb_Prod
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


def get_tables(database: str, schema: str = 'dbo'):
    """Get list of tables in a database."""
    conn = get_connection(database)
    cursor = conn.cursor()
    
    try:
        cursor.execute("""
            SELECT TABLE_NAME
            FROM INFORMATION_SCHEMA.TABLES
            WHERE TABLE_SCHEMA = ?
            AND TABLE_TYPE = 'BASE TABLE'
            ORDER BY TABLE_NAME
        """, schema)
        
        tables = [row[0] for row in cursor.fetchall()]
        return set(tables)
        
    finally:
        conn.close()


def main():
    """Main function to compare tables."""
    print(f"\n{'='*80}")
    print("Checking for tables in TILLDB that don't exist in TILLDBWeb_Prod")
    print(f"{'='*80}\n")
    
    print("Retrieving tables from TILLDB...")
    tilldb_tables = get_tables("TILLDB", "dbo")
    print(f"Found {len(tilldb_tables)} tables in TILLDB (dbo schema)\n")
    
    print("Retrieving tables from TILLDBWeb_Prod...")
    tilldbweb_tables = get_tables("TILLDBWeb_Prod", "dbo")
    print(f"Found {len(tilldbweb_tables)} tables in TILLDBWeb_Prod (dbo schema)\n")
    
    # Find tables only in TILLDB
    only_in_tilldb = tilldb_tables - tilldbweb_tables
    only_in_tilldbweb = tilldbweb_tables - tilldb_tables
    common_tables = tilldb_tables & tilldbweb_tables
    
    print(f"{'='*80}")
    print("COMPARISON RESULTS")
    print(f"{'='*80}\n")
    
    print(f"Common tables (exist in both): {len(common_tables)}")
    print(f"Tables only in TILLDB: {len(only_in_tilldb)}")
    print(f"Tables only in TILLDBWeb_Prod: {len(only_in_tilldbweb)}\n")
    
    if only_in_tilldb:
        print(f"{'='*80}")
        print("TABLES IN TILLDB THAT DON'T EXIST IN TILLDBWeb_Prod")
        print(f"{'='*80}\n")
        for table in sorted(only_in_tilldb):
            print(f"  - {table}")
        print()
    else:
        print("No tables found in TILLDB that don't exist in TILLDBWeb_Prod.\n")
    
    if only_in_tilldbweb:
        print(f"{'='*80}")
        print("TABLES IN TILLDBWeb_Prod THAT DON'T EXIST IN TILLDB")
        print(f"{'='*80}\n")
        for table in sorted(only_in_tilldbweb):
            print(f"  - {table}")
        print()
    
    # Write results to file
    with open('new_tables_in_TILLDB.txt', 'w') as f:
        f.write("="*80 + "\n")
        f.write("TABLES IN TILLDB THAT DON'T EXIST IN TILLDBWeb_Prod\n")
        f.write("Database: TILLDB\n")
        f.write("Schema: dbo\n")
        f.write("="*80 + "\n\n")
        
        if only_in_tilldb:
            f.write(f"Total tables found: {len(only_in_tilldb)}\n\n")
            f.write("Table Name\n")
            f.write("-" * 80 + "\n")
            for table in sorted(only_in_tilldb):
                f.write(f"{table}\n")
        else:
            f.write("No tables found in TILLDB that don't exist in TILLDBWeb_Prod.\n")
        
        f.write("\n" + "="*80 + "\n")
        f.write("End of Report\n")
        f.write("="*80 + "\n")
    
    print(f"{'='*80}")
    print("Results saved to: new_tables_in_TILLDB.txt")
    print(f"{'='*80}\n")


if __name__ == "__main__":
    main()

