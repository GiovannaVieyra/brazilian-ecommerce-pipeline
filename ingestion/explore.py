import duckdb
from pathlib import Path

DB_PATH = r"c:\Users\cebal\OneDrive\Escritorio\Brazilian E-Commerce Proyect\olist.duckdb"

con = duckdb.connect(str(DB_PATH))

tablas = [
    "olist_customers_dataset",
    "olist_geolocation_dataset",
    "olist_order_items_dataset",
    "olist_order_payments_dataset",
    "olist_order_reviews_dataset",
    "olist_orders_dataset",
    "olist_products_dataset",
    "olist_sellers_dataset",
    "product_category_name_translation",
]

for tabla in tablas:
    print(f"\n {tabla}")
    print(con.execute(f"DESCRIBE {tabla}").df().to_string())

print("\n fact_orders preview")
query = open(r"c:\Users\cebal\OneDrive\Escritorio\Brazilian E-Commerce Proyect\models\fact_orders.sql").read()
print(con.execute(query).df().head(5).to_string())

dimensiones = ["dim_customers", "dim_sellers", "dim_products"]

for dim in dimensiones:
    print(f"\n {dim} preview")
    query = open(rf"c:\Users\cebal\OneDrive\Escritorio\Brazilian E-Commerce Proyect\models\{dim}.sql").read()
    print(con.execute(query).df().head(3).to_string())

con.close()