"""
SQL Azure Database Comparison Tool
Compares table structures between two databases on the same SQL Azure server.
"""

import pyodbc
from collections import defaultdict
from typing import Dict, List, Tuple, Set
import sys


class DatabaseComparator:
    def __init__(self, server: str, username: str, password: str):
        """Initialize the database comparator with connection details."""
        self.server = server
        self.username = username
        self.password = password
        self.connection_string_template = (
            "Driver={{ODBC Driver 18 for SQL Server}};"
            "Server={server};"
            "Database={database};"
            "UID={username};"
            "PWD={password};"
            "Encrypt=yes;"
            "TrustServerCertificate=no;"
            "Connection Timeout=30;"
        )
    
    def get_connection(self, database: str):
        """Create and return a database connection."""
        connection_string = self.connection_string_template.format(
            server=self.server,
            database=database,
            username=self.username,
            password=self.password
        )
        try:
            return pyodbc.connect(connection_string)
        except Exception as e:
            print(f"Error connecting to {database}: {e}")
            sys.exit(1)
    
    def get_table_structure(self, database: str, schema: str = 'dbo') -> Dict:
        """Retrieve table structure information from a database."""
        conn = self.get_connection(database)
        cursor = conn.cursor()
        
        structure = {
            'tables': {},
            'columns': defaultdict(dict),
            'primary_keys': defaultdict(list),
            'foreign_keys': defaultdict(list),
            'indexes': defaultdict(list)
        }
        
        try:
            # Get all tables in the schema
            cursor.execute("""
                SELECT TABLE_NAME
                FROM INFORMATION_SCHEMA.TABLES
                WHERE TABLE_SCHEMA = ?
                AND TABLE_TYPE = 'BASE TABLE'
                ORDER BY TABLE_NAME
            """, schema)
            
            tables = [row[0] for row in cursor.fetchall()]
            structure['tables'] = {table: {} for table in tables}
            
            # Get column information
            cursor.execute("""
                SELECT 
                    TABLE_NAME,
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
                ORDER BY TABLE_NAME, ORDINAL_POSITION
            """, schema)
            
            for row in cursor.fetchall():
                table_name, col_name, pos, data_type, max_length, precision, scale, nullable, default = row
                
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
                
                structure['columns'][table_name][col_name] = {
                    'position': pos,
                    'data_type': type_str,
                    'is_nullable': nullable,
                    'default': default
                }
            
            # Get primary keys
            cursor.execute("""
                SELECT 
                    tc.TABLE_NAME,
                    kc.COLUMN_NAME,
                    kc.ORDINAL_POSITION
                FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS tc
                JOIN INFORMATION_SCHEMA.KEY_COLUMN_USAGE kc
                    ON tc.CONSTRAINT_NAME = kc.CONSTRAINT_NAME
                    AND tc.TABLE_SCHEMA = kc.TABLE_SCHEMA
                WHERE tc.CONSTRAINT_TYPE = 'PRIMARY KEY'
                    AND tc.TABLE_SCHEMA = ?
                ORDER BY tc.TABLE_NAME, kc.ORDINAL_POSITION
            """, schema)
            
            for row in cursor.fetchall():
                table_name, col_name, pos = row
                structure['primary_keys'][table_name].append((col_name, pos))
            
            # Get foreign keys
            cursor.execute("""
                SELECT 
                    tc.TABLE_NAME,
                    kc.COLUMN_NAME,
                    ccu.TABLE_NAME AS REFERENCED_TABLE,
                    ccu.COLUMN_NAME AS REFERENCED_COLUMN,
                    rc.DELETE_RULE,
                    rc.UPDATE_RULE
                FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS tc
                JOIN INFORMATION_SCHEMA.KEY_COLUMN_USAGE kc
                    ON tc.CONSTRAINT_NAME = kc.CONSTRAINT_NAME
                JOIN INFORMATION_SCHEMA.REFERENTIAL_CONSTRAINTS rc
                    ON tc.CONSTRAINT_NAME = rc.CONSTRAINT_NAME
                JOIN INFORMATION_SCHEMA.CONSTRAINT_COLUMN_USAGE ccu
                    ON rc.UNIQUE_CONSTRAINT_NAME = ccu.CONSTRAINT_NAME
                WHERE tc.CONSTRAINT_TYPE = 'FOREIGN KEY'
                    AND tc.TABLE_SCHEMA = ?
                ORDER BY tc.TABLE_NAME, kc.ORDINAL_POSITION
            """, schema)
            
            for row in cursor.fetchall():
                table_name, col_name, ref_table, ref_col, delete_rule, update_rule = row
                structure['foreign_keys'][table_name].append({
                    'column': col_name,
                    'referenced_table': ref_table,
                    'referenced_column': ref_col,
                    'delete_rule': delete_rule,
                    'update_rule': update_rule
                })
            
            # Get indexes (non-primary key)
            cursor.execute("""
                SELECT 
                    t.name AS TABLE_NAME,
                    i.name AS INDEX_NAME,
                    c.name AS COLUMN_NAME,
                    ic.key_ordinal,
                    i.is_unique,
                    i.is_primary_key
                FROM sys.tables t
                INNER JOIN sys.indexes i ON t.object_id = i.object_id
                INNER JOIN sys.index_columns ic ON i.object_id = ic.object_id AND i.index_id = ic.index_id
                INNER JOIN sys.columns c ON ic.object_id = c.object_id AND ic.column_id = c.column_id
                INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
                WHERE s.name = ?
                    AND i.is_primary_key = 0
                    AND i.type > 0
                ORDER BY t.name, i.name, ic.key_ordinal
            """, schema)
            
            for row in cursor.fetchall():
                table_name, index_name, col_name, key_ordinal, is_unique, is_pk = row
                structure['indexes'][table_name].append({
                    'index_name': index_name,
                    'column': col_name,
                    'ordinal': key_ordinal,
                    'is_unique': bool(is_unique)
                })
            
        finally:
            conn.close()
        
        return structure
    
    def compare_structures(self, db1_name: str, db2_name: str, schema: str = 'dbo'):
        """Compare table structures between two databases."""
        print(f"\n{'='*80}")
        print(f"Comparing database structures: {db1_name} vs {db2_name}")
        print(f"Schema: {schema}")
        print(f"{'='*80}\n")
        
        print("Retrieving structure from first database...")
        struct1 = self.get_table_structure(db1_name, schema)
        
        print("Retrieving structure from second database...")
        struct2 = self.get_table_structure(db2_name, schema)
        
        # Compare tables
        tables1 = set(struct1['tables'].keys())
        tables2 = set(struct2['tables'].keys())
        
        only_in_db1 = tables1 - tables2
        only_in_db2 = tables2 - tables1
        common_tables = tables1 & tables2
        
        print(f"\n{'='*80}")
        print("TABLE COMPARISON")
        print(f"{'='*80}")
        print(f"\nTables only in {db1_name}: {len(only_in_db1)}")
        if only_in_db1:
            for table in sorted(only_in_db1):
                print(f"  - {table}")
        
        print(f"\nTables only in {db2_name}: {len(only_in_db2)}")
        if only_in_db2:
            for table in sorted(only_in_db2):
                print(f"  - {table}")
        
        print(f"\nCommon tables: {len(common_tables)}")
        
        # Compare columns for common tables
        print(f"\n{'='*80}")
        print("COLUMN COMPARISON")
        print(f"{'='*80}")
        
        differences_found = False
        
        for table in sorted(common_tables):
            cols1 = struct1['columns'].get(table, {})
            cols2 = struct2['columns'].get(table, {})
            
            cols1_set = set(cols1.keys())
            cols2_set = set(cols2.keys())
            
            only_in_db1_cols = cols1_set - cols2_set
            only_in_db2_cols = cols2_set - cols1_set
            common_cols = cols1_set & cols2_set
            
            if only_in_db1_cols or only_in_db2_cols:
                differences_found = True
                print(f"\nTable: {table}")
                if only_in_db1_cols:
                    print(f"  Columns only in {db1_name}:")
                    for col in sorted(only_in_db1_cols):
                        col_info = cols1[col]
                        print(f"    - {col} ({col_info['data_type']}, "
                              f"Nullable: {col_info['is_nullable']}, "
                              f"Position: {col_info['position']})")
                
                if only_in_db2_cols:
                    print(f"  Columns only in {db2_name}:")
                    for col in sorted(only_in_db2_cols):
                        col_info = cols2[col]
                        print(f"    - {col} ({col_info['data_type']}, "
                              f"Nullable: {col_info['is_nullable']}, "
                              f"Position: {col_info['position']})")
            
            # Compare column properties for common columns
            for col in sorted(common_cols):
                col1 = cols1[col]
                col2 = cols2[col]
                
                differences = []
                if col1['data_type'] != col2['data_type']:
                    differences.append(f"Data type: {col1['data_type']} vs {col2['data_type']}")
                if col1['is_nullable'] != col2['is_nullable']:
                    differences.append(f"Nullable: {col1['is_nullable']} vs {col2['is_nullable']}")
                if col1['default'] != col2['default']:
                    diff1 = col1['default'] if col1['default'] else '(NULL)'
                    diff2 = col2['default'] if col2['default'] else '(NULL)'
                    differences.append(f"Default: {diff1} vs {diff2}")
                if col1['position'] != col2['position']:
                    differences.append(f"Position: {col1['position']} vs {col2['position']}")
                
                if differences:
                    differences_found = True
                    if not (only_in_db1_cols or only_in_db2_cols):
                        print(f"\nTable: {table}")
                    print(f"  Column '{col}' differences:")
                    for diff in differences:
                        print(f"    - {diff}")
        
        if not differences_found and not only_in_db1_cols and not only_in_db2_cols:
            print("\nNo column differences found in common tables.")
        
        # Compare primary keys
        print(f"\n{'='*80}")
        print("PRIMARY KEY COMPARISON")
        print(f"{'='*80}")
        
        pk_differences = False
        for table in sorted(common_tables):
            pk1 = sorted(struct1['primary_keys'].get(table, []))
            pk2 = sorted(struct2['primary_keys'].get(table, []))
            
            if pk1 != pk2:
                pk_differences = True
                print(f"\nTable: {table}")
                pk1_str = ', '.join([f"{col}({pos})" for col, pos in pk1]) if pk1 else "None"
                pk2_str = ', '.join([f"{col}({pos})" for col, pos in pk2]) if pk2 else "None"
                print(f"  {db1_name}: {pk1_str}")
                print(f"  {db2_name}: {pk2_str}")
        
        if not pk_differences:
            print("\nNo primary key differences found.")
        
        # Compare foreign keys
        print(f"\n{'='*80}")
        print("FOREIGN KEY COMPARISON")
        print(f"{'='*80}")
        
        fk_differences = False
        for table in sorted(common_tables):
            fk1 = struct1['foreign_keys'].get(table, [])
            fk2 = struct2['foreign_keys'].get(table, [])
            
            # Create comparable representations
            fk1_set = set()
            for fk in fk1:
                fk1_set.add((fk['column'], fk['referenced_table'], fk['referenced_column']))
            
            fk2_set = set()
            for fk in fk2:
                fk2_set.add((fk['column'], fk['referenced_table'], fk['referenced_column']))
            
            if fk1_set != fk2_set:
                fk_differences = True
                print(f"\nTable: {table}")
                only_fk1 = fk1_set - fk2_set
                only_fk2 = fk2_set - fk1_set
                
                if only_fk1:
                    print(f"  Foreign keys only in {db1_name}:")
                    for fk in sorted(only_fk1):
                        print(f"    - {fk[0]} -> {fk[1]}.{fk[2]}")
                
                if only_fk2:
                    print(f"  Foreign keys only in {db2_name}:")
                    for fk in sorted(only_fk2):
                        print(f"    - {fk[0]} -> {fk[1]}.{fk[2]}")
        
        if not fk_differences:
            print("\nNo foreign key differences found.")
        
        print(f"\n{'='*80}")
        print("COMPARISON COMPLETE")
        print(f"{'='*80}\n")
    
    def get_tables_with_new_fields(self, db1_name: str, db2_name: str, schema: str = 'dbo') -> Dict:
        """
        Get a list of tables in db1 that have columns that don't exist in the same tables in db2.
        Returns a dictionary mapping table names to lists of missing columns.
        """
        print(f"\n{'='*80}")
        print(f"Finding tables in {db1_name} with new fields not in {db2_name}")
        print(f"Schema: {schema}")
        print(f"{'='*80}\n")
        
        print(f"Retrieving structure from {db1_name}...")
        struct1 = self.get_table_structure(db1_name, schema)
        
        print(f"Retrieving structure from {db2_name}...")
        struct2 = self.get_table_structure(db2_name, schema)
        
        # Find common tables
        tables1 = set(struct1['tables'].keys())
        tables2 = set(struct2['tables'].keys())
        common_tables = tables1 & tables2
        
        # Find tables with new fields
        tables_with_new_fields = {}
        
        for table in sorted(common_tables):
            cols1 = struct1['columns'].get(table, {})
            cols2 = struct2['columns'].get(table, {})
            
            cols1_set = set(cols1.keys())
            cols2_set = set(cols2.keys())
            
            # Columns in db1 but not in db2
            new_fields = cols1_set - cols2_set
            
            if new_fields:
                tables_with_new_fields[table] = []
                for col in sorted(new_fields):
                    col_info = cols1[col]
                    tables_with_new_fields[table].append({
                        'name': col,
                        'data_type': col_info['data_type'],
                        'is_nullable': col_info['is_nullable'],
                        'position': col_info['position'],
                        'default': col_info['default']
                    })
        
        # Print results
        print(f"\n{'='*80}")
        print("TABLES WITH NEW FIELDS")
        print(f"{'='*80}\n")
        
        if tables_with_new_fields:
            print(f"Found {len(tables_with_new_fields)} table(s) with new fields:\n")
            for table in sorted(tables_with_new_fields.keys()):
                print(f"Table: {table}")
                print(f"  New fields ({len(tables_with_new_fields[table])}):")
                for field in tables_with_new_fields[table]:
                    nullable_str = "NULL" if field['is_nullable'] == 'YES' else "NOT NULL"
                    default_str = f", Default: {field['default']}" if field['default'] else ""
                    print(f"    - {field['name']} ({field['data_type']}, {nullable_str}{default_str})")
                print()
        else:
            print("No tables found with new fields.\n")
        
        print(f"{'='*80}\n")
        
        return tables_with_new_fields


def main():
    """Main function to run the comparison."""
    server = "tillsqlserver.database.windows.net"
    username = "tillsqladmin"
    password = "Purpl3R31gn"
    database1 = "TILLDB"
    database2 = "TILLDBWeb_Prod"
    schema = "dbo"
    
    comparator = DatabaseComparator(server, username, password)
    
    # Get tables with new fields (primary use case)
    tables_with_new_fields = comparator.get_tables_with_new_fields(database1, database2, schema)
    
    # Optionally run full comparison (uncomment if needed)
    # comparator.compare_structures(database1, database2, schema)


if __name__ == "__main__":
    main()

