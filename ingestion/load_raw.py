import duckdb
import pandas as pd
from pathlib import Path

PROJECT_ROOT = Path(__file__).parent.parent
DATA_RAW = PROJECT_ROOT / "data_raw"
DB_PATH = PROJECT_ROOT / "olist.duckdb"

CSV_FILES = [
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

def load_csv_to_duckdb():
    con = duckdb.connect(str(DB_PATH))
    
    for name in CSV_FILES:
        csv_path = DATA_RAW / f"{name}.csv"
        
        if not csv_path.exists():
            print(f"No encontrado: {name}.csv - verifica el nombre del archivo")
            continue
        
        df = pd.read_csv(csv_path)
        
        con.execute(f"CREATE OR REPLACE TABLE {name} AS SELECT * FROM df")
        
        print(f"Cargado: {name} - {len(df)} filas")
        
    con.close()
    print("/n Ingesta completa. Base de datos guardada en olist.duckdb")
    
if __name__ == "__main__":
    load_csv_to_duckdb()