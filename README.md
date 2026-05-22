# 🛒 Brazilian E-Commerce Data Pipeline
### End-to-end Data Engineering portfolio project using the Olist dataset

---

## 📌 Overview

A fully local data engineering pipeline that ingests 9 raw CSVs from the [Olist Brazilian E-Commerce dataset](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce) (~1.6M rows), loads them into a DuckDB warehouse, and transforms them into a star schema using dbt — including data quality tests and automated documentation.

---

## 🛠️ Tech Stack

| Layer | Tool |
|---|---|
| Ingestion | Python + pandas |
| Warehouse | DuckDB (local) |
| Transformation | dbt (dbt-duckdb) |
| Data Model | Star Schema |
| Version Control | Git + GitHub |

---

## 🏗️ Architecture

```
9 raw CSVs (Olist)
      │
      ▼
[Python ingestion]
load_raw.py → DuckDB (olist.duckdb)
      │
      ▼
[dbt transformation]
      ├── dim_customers
      ├── dim_sellers
      ├── dim_products
      └── fact_orders
      │
      ▼
[dbt tests — 15 data quality checks]
```

---

## 📊 Data Model — Star Schema

### `fact_orders`
One row per order. Aggregated metrics from order items, payments, and reviews.

| Column | Description |
|---|---|
| `order_id` | PK — unique order identifier |
| `customer_id` | FK → dim_customers |
| `order_status` | Order lifecycle status |
| `order_purchase_timestamp` | Purchase datetime |
| `order_delivered_customer_date` | Actual delivery datetime |
| `order_estimated_delivery_date` | Estimated delivery datetime |
| `delivery_days` | Days from purchase to delivery |
| `delivery_delay_days` | Days ahead/behind estimated delivery |
| `total_items` | Number of items in the order |
| `total_price` | Sum of item prices |
| `total_freight_value` | Sum of freight costs |
| `payment_value` | Total payment amount |
| `payment_type` | Payment method |
| `review_score` | Customer satisfaction score (1–5) |

### Dimensions
- **`dim_customers`** — unique customers with location data
- **`dim_sellers`** — sellers with city and state
- **`dim_products`** — products with category and physical dimensions

---

## ✅ Data Quality Tests

15 tests across all models, split into two types:

**Generic tests** (schema.yml)
- `unique` + `not_null` on all primary keys
- `relationships` — referential integrity between fact and dims
- `accepted_values` — valid order statuses

**Singular tests** (custom SQL)
- `assert_delivery_date_logic` — no delivery date before purchase date ✅
- `assert_positive_payment_values` — delivered orders should have payment value ⚠️

**Known data anomalies (documented as warnings):**
- 79–81 delivered orders with null `payment_value` — missing records in the raw payments CSV, not a pipeline bug
- Both warnings are explicitly configured with `severity: warn` so the pipeline does not break

**Final test results:** `PASS=13 WARN=2 ERROR=0`

---

## 📁 Project Structure

```
Brazilian E-Commerce Project/
├── olist.duckdb              # Local DuckDB warehouse
├── data_raw/                 # 9 raw CSVs from Olist
├── ingestion/
│   ├── load_raw.py           # Loads CSVs into DuckDB
│   └── explore.py            # Preview and exploration scripts
├── models/                   # Original SQL models
└── olist_pipeline/           # dbt project
    ├── models/
    │   ├── schema.yml        # Column definitions + generic tests
    │   ├── fact_orders.sql
    │   ├── dim_customers.sql
    │   ├── dim_sellers.sql
    │   └── dim_products.sql
    └── tests/
        ├── assert_delivery_date_logic.sql
        └── assert_positive_payment_values.sql
```

---

---

## 🔍 Key Engineering Decisions

- **Star schema over flat table** — separating dimensions enables reusable, queryable business entities
- **Aggregation at order level** — `fact_orders` is one row per order, not per item; freight and price are summed, reviews are deduplicated using `ROW_NUMBER()` to handle multiple reviews per order in the source data
- **Warnings over errors for known anomalies** — pipeline stays green while data issues are explicitly surfaced and documented

---

---

# 🛒 Pipeline de Datos — E-Commerce Brasileño
### Proyecto de portfolio de Data Engineering usando el dataset de Olist

---

## 📌 Descripción

Pipeline de data engineering completamente local que ingesta 9 CSVs crudos del [dataset de e-commerce de Olist](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce) (~1.6M filas), los carga en un warehouse DuckDB y los transforma en un star schema usando dbt — incluyendo tests de calidad de datos y documentación automatizada.

---

## 🛠️ Stack Técnico

| Capa | Herramienta |
|---|---|
| Ingesta | Python + pandas |
| Warehouse | DuckDB (local) |
| Transformación | dbt (dbt-duckdb) |
| Modelo de datos | Star Schema |
| Control de versiones | Git + GitHub |

---

## 🏗️ Arquitectura

```
9 CSVs crudos (Olist)
      │
      ▼
[Ingesta Python]
load_raw.py → DuckDB (olist.duckdb)
      │
      ▼
[Transformación dbt]
      ├── dim_customers
      ├── dim_sellers
      ├── dim_products
      └── fact_orders
      │
      ▼
[Tests dbt — 15 checks de calidad de datos]
```

---

## ✅ Tests de Calidad de Datos

15 tests distribuidos en todos los modelos:

**Tests genéricos** (schema.yml)
- `unique` + `not_null` en todas las claves primarias
- `relationships` — integridad referencial entre fact y dims
- `accepted_values` — estados de orden válidos

**Tests singulares** (SQL custom)
- `assert_delivery_date_logic` — ninguna entrega anterior a la fecha de compra ✅
- `assert_positive_payment_values` — órdenes entregadas deben tener valor de pago ⚠️

**Anomalías conocidas del dataset (documentadas como warnings):**
- 79–81 órdenes entregadas con `payment_value` nulo — registros faltantes en el CSV de pagos, no es un bug del pipeline
- Ambos warnings están configurados con `severity: warn` para que el pipeline no se rompa

**Resultado final de tests:** `PASS=13 WARN=2 ERROR=0`

---

## 🔍 Decisiones de Ingeniería

- **Star schema en lugar de tabla plana** — separar las dimensiones permite entidades de negocio reutilizables y consultables
- **Agregación a nivel de orden** — `fact_orders` tiene una fila por orden, no por ítem; precio y flete se suman, y las reseñas se deduplicaron con `ROW_NUMBER()` para manejar múltiples reseñas por orden en los datos fuente
- **Warnings en lugar de errores para anomalías conocidas** — el pipeline se mantiene verde mientras los problemas de datos se documentan explícitamente

---

*Dataset source: [Olist Brazilian E-Commerce Public Dataset](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce) — Kaggle*

