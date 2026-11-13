import pandas as pd
from getpass import getpass
from sqlalchemy import create_engine, text
from sqlalchemy.engine import URL

clean = pd.read_parquet("data/loans_clean.parquet")
for col in clean.select_dtypes("category").columns:
    clean[col] = clean[col].astype("string")

url = URL.create("postgresql+psycopg2", username="postgres",
                 password=getpass("PostgreSQL password: "),
                 host="localhost", port=5432, database="bondora")
engine = create_engine(url)

with engine.begin() as conn:
    conn.execute(text("CREATE SCHEMA IF NOT EXISTS raw"))

clean.to_sql("loans", engine, schema="raw", if_exists="replace",
             index=False, chunksize=10_000)
print("Loaded:", len(clean))   # should print 410865