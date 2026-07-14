import duckdb

# Connect to the same DuckDB file dbt has been building into
con = duckdb.connect('dev.duckdb')

tables = ['dim_customer', 'dim_product', 'dim_date', 'fact_sales']

for table in tables:
    output_path = f'exports/{table}.csv'
    con.execute(f"COPY main.{table} TO '{output_path}' (HEADER, DELIMITER ',')")
    print(f"Exported {table} to {output_path}")

con.close()
print("All exports complete.")
