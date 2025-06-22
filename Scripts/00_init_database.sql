/*
=============================================================
Create Database and Schemas
=============================================================
Script Purpose:
    This script creates a new database named 'SQL_Data_Analytics' after checking if it already exists. 
    If the database exists, it is dropped and recreated.
	
*/

-- Create the 'SQL_Data_Analytics' database
DROP DATABASE IF EXISTS SQL_Data_Analytics;
CREATE DATABASE SQL_Data_Analytics;


USE SQL_Data_Analytics;


-- Create Tables

CREATE TABLE gold_dim_customers (
    customer_key INT PRIMARY KEY,
    customer_id INT NOT NULL,
    customer_number VARCHAR(50),
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    country VARCHAR(50),
    marital_status VARCHAR(50),
    gender VARCHAR(50),
    birthdate DATE,
    create_date DATE
);



CREATE TABLE gold_dim_products (
    product_key INT PRIMARY KEY,
    product_id INT NOT NULL,
    product_number VARCHAR(50),
    product_name VARCHAR(50),
    category_id VARCHAR(50),
    category VARCHAR(50),
    subcategory VARCHAR(50),
    maintenance VARCHAR(50),
    cost INT,
    product_line VARCHAR(50),
    start_date DATE
);


CREATE TABLE gold_fact_sales (
    order_number VARCHAR(50),
    product_key INT,
    customer_key INT,
    order_date DATE,
    shipping_date DATE,
    due_date DATE,
    sales_amount INT,
    quantity TINYINT,
    price INT,
    PRIMARY KEY (order_number, product_key, customer_key),
    FOREIGN KEY (product_key) REFERENCES gold_dim_products(product_key),
    FOREIGN KEY (customer_key) REFERENCES gold_dim_customers(customer_key)
);

-- Updating fact_sales Table Price Column values with the corresponding cost values from the dim_products
UPDATE gold_fact_sales gfs
JOIN gold_dim_products gdp ON gfs.product_key = gdp.product_key 
SET gfs.price = gdp.cost;

-- Updating Sales_Amount from fact_sales table
UPDATE gold_fact_sales
SET sales_amount = price * quantity;