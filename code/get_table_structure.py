"""
Script to get the structure of catMassHealthServiceLevels table from TILLDB
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


def get_table_structure(table_name: str, schema: str = 'dbo'):
    """Get table structure information."""
    conn = get_connection("TILLDB")
    cursor = conn.cursor()
    
    try:
        # Get column information
        cursor.execute("""
            SELECT 
                COLUMN_NAME,
                ORDINAL_POSITION,
                DATA_TYPE,
                CHARACTER_MAXIMUM_LENGTH,
                NUMERIC_PRECISION,
                NUMERIC_SCALE,
                IS_NULLABLE,
                COLUMN_DEFAULT
            FROM INFORMATION_SCHEMA.COLUMNS
            WHERE TABLE_SCHEMA = ?
            AND TABLE_NAME = ?
            ORDER BY ORDINAL_POSITION
        """, schema, table_name)
        
        columns = []
        for row in cursor.fetchall():
            col_name, pos, data_type, max_length, precision, scale, nullable, default = row
            
            # Format data type
            if data_type in ['varchar', 'nvarchar', 'char', 'nchar']:
                if max_length == -1:
                    type_str = f"{data_type}(MAX)"
                else:
                    type_str = f"{data_type}({max_length})"
            elif data_type in ['decimal', 'numeric']:
                type_str = f"{data_type}({precision},{scale})"
            else:
                type_str = data_type
            
            columns.append({
                'name': col_name,
                'position': pos,
                'data_type': type_str,
                'is_nullable': nullable,
                'default': default
            })
        
        # Get primary keys
        cursor.execute("""
            SELECT 
                kc.COLUMN_NAME,
                kc.ORDINAL_POSITION
            FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS tc
            JOIN INFORMATION_SCHEMA.KEY_COLUMN_USAGE kc
                ON tc.CONSTRAINT_NAME = kc.CONSTRAINT_NAME
                AND tc.TABLE_SCHEMA = kc.TABLE_SCHEMA
            WHERE tc.CONSTRAINT_TYPE = 'PRIMARY KEY'
                AND tc.TABLE_SCHEMA = ?
                AND tc.TABLE_NAME = ?
            ORDER BY kc.ORDINAL_POSITION
        """, schema, table_name)
        
        primary_keys = [(row[0], row[1]) for row in cursor.fetchall()]
        
        return {
            'columns': columns,
            'primary_keys': primary_keys
        }
        
    finally:
        conn.close()


def generate_create_table_sql(table_name: str, structure: dict):
    """Generate CREATE TABLE SQL statement."""
    sql = f"CREATE TABLE dbo.[{table_name}]\n(\n"
    
    col_definitions = []
    for col in structure['columns']:
        nullable = "NULL" if col['is_nullable'] == 'YES' else "NOT NULL"
        default = f" DEFAULT {col['default']}" if col['default'] else ""
        col_definitions.append(f"    [{col['name']}] {col['data_type']} {nullable}{default}")
    
    sql += ",\n".join(col_definitions)
    
    # Add primary key constraint if exists
    if structure['primary_keys']:
        pk_cols = [col[0] for col in sorted(structure['primary_keys'], key=lambda x: x[1])]
        sql += f",\n    CONSTRAINT [PK_{table_name}] PRIMARY KEY ([{'], ['.join(pk_cols)}])"
    
    sql += "\n);"
    
    return sql


if __name__ == "__main__":
    print("Retrieving structure of catMassHealthServiceLevels from TILLDB...\n")
    
    structure = get_table_structure('catMassHealthServiceLevels', 'dbo')
    
    print("Table Structure:")
    print("=" * 80)
    for col in structure['columns']:
        nullable = "NULL" if col['is_nullable'] == 'YES' else "NOT NULL"
        print(f"  {col['name']}: {col['data_type']} {nullable}")
    
    if structure['primary_keys']:
        pk_cols = [col[0] for col in sorted(structure['primary_keys'], key=lambda x: x[1])]
        print(f"\nPrimary Key: {', '.join(pk_cols)}")
    
    print("\n" + "=" * 80)
    
    # Generate CREATE TABLE SQL
    create_sql = generate_create_table_sql('catMassHealthServiceLevels', structure)
    
    print("\nGenerated CREATE TABLE SQL:")
    print("=" * 80)
    print(create_sql)
    print("=" * 80)
    
    # Save to file
    with open('create_catMassHealthServiceLevels.sql', 'w') as f:
        f.write("-- ============================================================================\n")
        f.write("-- CREATE TABLE: catMassHealthServiceLevels\n")
        f.write("-- Database: TILLDBWeb_Prod\n")
        f.write("-- Schema: dbo\n")
        f.write("-- ============================================================================\n\n")
        f.write("USE TILLDBWeb_Prod;\n")
        f.write("GO\n\n")
        f.write(create_sql)
        f.write("\nGO\n")
    
    print("\nCREATE TABLE script saved to: create_catMassHealthServiceLevels.sql")

