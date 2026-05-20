# Retail Sales SQL Analysis Project

## Project Overview

This project focuses on analyzing a retail sales dataset using SQL. The objective of this project is to perform end-to-end SQL analysis starting from raw retail data and transforming it into meaningful business insights.

The project includes:

- Data Exploration
- Data Cleaning
- Database Normalization
- Business Analysis
- Revenue & Profit Analysis
- Time-Based Analysis

The project was built using PostgreSQL and PGAdmin.

---

# Dataset Information

The dataset contains retail transaction-level data with the following columns:

- Order ID
- Order Date
- Ship Mode
- Segment
- Country
- City
- State
- Postal Code
- Region
- Category
- Sub Category
- Product ID
- Cost Price
- List Price
- Quantity
- Discount Percentage

---

# Project Workflow

## 1. Schema Creation

Created the `retail` table with proper SQL data types for all columns.

---

## 2. Data Exploration

Performed exploratory analysis to understand the structure and quality of the dataset.

### Exploration Tasks

- Count total rows
- View sample records
- Check NULL values
- Find duplicate rows
- Check distinct categories and sub-categories
- Validate ship modes
- Check zero and negative values
- Validate business logic (`cost_price > list_price`)
- Analyze overall date range

---

# 3. Data Cleaning

Performed cleaning operations to improve data quality.

### Cleaning Steps

- Replaced zero values in `cost_price` and `list_price` with NULL
- Standardized inconsistent ship mode values
- Checked invalid pricing conditions
- Handled inconsistent records

---

# 4. Database Normalization

The original retail table was normalized into separate tables to reduce redundancy and improve database structure.

## Tables Created

### Customers Table
Contains:
- customer_id
- segment
- country
- city
- state
- postal_code
- region

### Products Table
Contains:
- product_id
- category
- sub_category

### Orders Table
Contains:
- order_id
- order_date
- ship_mode
- customer_id

### Order Details Table
Contains:
- order_id
- product_id
- cost_price
- list_price
- quantity
- discount_percentage

---

# Analysis Performed

## Basic Analysis

- Total number of orders
- Total quantity sold
- Total revenue
- Average order value
- Unique customer count
- Unique product count

---

# Category & Segment Analysis

- Total sales by category
- Total sales by sub-category
- Highest revenue-generating category
- Sales distribution by segment
- Top 5 sub-categories by revenue
- Category with highest average discount

---

# Regional Analysis

- Total sales by region
- Top 5 cities by sales
- State with highest number of orders
- Region with lowest sales
- Average order value per city

---

# Product Analysis

- Top 10 products by revenue
- Top 10 products by quantity sold
- Products with highest discounts
- Least selling products

---

# Shipping Analysis

- Most used shipping mode
- Revenue by ship mode
- Quantity handled by ship mode

---

# Time-Based Analysis

- Monthly sales analysis
- Yearly sales analysis

---

# Discount & Pricing Analysis

- Total discount given
- Average discount by category
- High discount orders
- Relationship between discount and quantity sold

---

# Profit Analysis

- Total profit
- Profit by category

---

# SQL Concepts Used

This project demonstrates practical implementation of:

- DDL Commands
- DML Commands
- Joins
- Aggregations
- GROUP BY
- ORDER BY
- Subqueries
- Date Functions
- Data Cleaning
- Database Normalization
- Business KPI Calculations

---

# Tools Used

- PostgreSQL
- PGAdmin

---

# Key Insights

- Identified top-performing categories and products
- Analyzed customer purchasing behavior
- Evaluated the impact of discounts on sales
- Measured yearly and monthly sales trends
- Compared regional sales performance
- Analyzed shipping mode contribution to revenue

---

# Conclusion

This project demonstrates end-to-end SQL analysis using a retail sales dataset. It showcases skills in database design, data cleaning, normalization, SQL querying, and business analysis that are relevant for Data Analyst roles.

