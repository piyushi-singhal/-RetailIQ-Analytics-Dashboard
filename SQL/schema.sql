-- RetailIQ / Superstore analytics schema
-- Dialect: PostgreSQL

CREATE SCHEMA IF NOT EXISTS retailiq;
SET search_path TO retailiq;

DROP TABLE IF EXISTS order_items;
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS products;
DROP TABLE IF EXISTS customers;
DROP TABLE IF EXISTS superstore_staging;

CREATE TABLE customers (
    customer_id VARCHAR(20) PRIMARY KEY,
    customer_name VARCHAR(120) NOT NULL,
    segment VARCHAR(40) NOT NULL
);

CREATE TABLE products (
    product_key BIGSERIAL PRIMARY KEY,
    product_id VARCHAR(30) NOT NULL,
    product_name TEXT NOT NULL,
    category VARCHAR(60) NOT NULL,
    sub_category VARCHAR(60) NOT NULL,
    CONSTRAINT uq_product_detail UNIQUE (product_id, product_name)
);

CREATE TABLE orders (
    order_id VARCHAR(30) PRIMARY KEY,
    order_date DATE NOT NULL,
    ship_date DATE NOT NULL,
    ship_mode VARCHAR(40) NOT NULL,
    customer_id VARCHAR(20) NOT NULL REFERENCES customers(customer_id),
    country VARCHAR(60) NOT NULL,
    city VARCHAR(80) NOT NULL,
    state VARCHAR(80) NOT NULL,
    postal_code VARCHAR(20),
    region VARCHAR(40) NOT NULL,
    shipping_days INT NOT NULL,
    order_year INT NOT NULL,
    order_month INT NOT NULL,
    order_quarter INT NOT NULL,
    CONSTRAINT valid_ship_date CHECK (ship_date >= order_date),
    CONSTRAINT valid_order_month CHECK (order_month BETWEEN 1 AND 12),
    CONSTRAINT valid_order_quarter CHECK (order_quarter BETWEEN 1 AND 4)
);

CREATE TABLE order_items (
    row_id INT PRIMARY KEY,
    order_id VARCHAR(30) NOT NULL REFERENCES orders(order_id),
    product_key BIGINT NOT NULL REFERENCES products(product_key),
    sales NUMERIC(12, 2) NOT NULL,
    quantity INT NOT NULL,
    discount NUMERIC(5, 2) NOT NULL,
    profit NUMERIC(12, 2) NOT NULL,
    profit_margin NUMERIC(8, 2),
    CONSTRAINT positive_quantity CHECK (quantity > 0),
    CONSTRAINT valid_discount CHECK (discount >= 0 AND discount <= 1)
);

CREATE TABLE superstore_staging (
    row_id INT,
    order_id VARCHAR(30),
    order_date DATE,
    ship_date DATE,
    ship_mode VARCHAR(40),
    customer_id VARCHAR(20),
    customer_name VARCHAR(120),
    segment VARCHAR(40),
    country VARCHAR(60),
    city VARCHAR(80),
    state VARCHAR(80),
    postal_code VARCHAR(20),
    region VARCHAR(40),
    product_id VARCHAR(30),
    category VARCHAR(60),
    sub_category VARCHAR(60),
    product_name TEXT,
    sales NUMERIC(12, 4),
    quantity INT,
    discount NUMERIC(5, 2),
    profit NUMERIC(12, 4),
    order_year INT,
    order_month INT,
    month_name VARCHAR(20),
    order_quarter INT,
    shipping_days INT,
    profit_margin NUMERIC(8, 4)
);

CREATE INDEX idx_orders_order_date ON orders(order_date);
CREATE INDEX idx_orders_region ON orders(region);
CREATE INDEX idx_orders_customer_id ON orders(customer_id);
CREATE INDEX idx_order_items_order_id ON order_items(order_id);
CREATE INDEX idx_products_product_id ON products(product_id);
CREATE INDEX idx_order_items_product_key ON order_items(product_key);
