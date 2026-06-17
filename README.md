# RetailIQ – Retail Analytics & Business Intelligence Dashboard

## Overview

RetailIQ is an end-to-end Retail Analytics and Business Intelligence project that transforms raw retail transaction data into actionable business insights. The project integrates Python, MySQL, SQL Analytics, Forecasting, and Tableau to analyze customer behavior, regional performance, product profitability, and sales trends across 9,994 retail transactions.

This project demonstrates a complete analytics workflow from data cleaning and database modeling to business analysis, forecasting, and interactive dashboard development.

---

## Business Problem

Retail organizations generate vast amounts of transactional data but often struggle to convert it into strategic business decisions.

This project addresses the following key business questions:

* Which regions generate the highest revenue and profit?
* Who are the most valuable customers?
* Which customer segments contribute most to business growth?
* How do discounts impact profitability?
* Which product categories drive revenue and profit?
* What future sales trends can be expected?

---

## Dataset Summary

| Metric               | Value     |
| -------------------- | --------- |
| Total Transactions   | 9,994     |
| Unique Customers     | 793       |
| Unique Products      | 1,862     |
| Geographic Locations | 631       |
| Time Period          | 2014–2017 |

---

## Technology Stack

| Category           | Technologies          |
| ------------------ | --------------------- |
| Programming        | Python                |
| Data Processing    | Pandas, NumPy         |
| Database           | MySQL                 |
| SQL Integration    | SQLAlchemy, PyMySQL   |
| Forecasting        | Exponential Smoothing |
| Data Visualization | Tableau               |
| Version Control    | Git & GitHub          |

---

## Project Architecture

Raw Retail Data

↓

Data Cleaning & Validation

↓

Dimensional Data Modeling

↓

MySQL Database Integration

↓

SQL-Based Business Analysis

↓

Sales Forecasting

↓

Interactive Tableau Dashboards

↓

Business Recommendations

---

## Data Engineering & Preparation

The dataset underwent extensive preprocessing and quality validation, including:

* Missing value analysis and treatment
* Duplicate record detection and removal
* Customer dimension preparation
* Product dimension preparation
* Geography dimension preparation
* Data type standardization
* Data consistency validation
* Relational schema creation

---

## Database Design

The project follows a dimensional modeling approach using MySQL.

### Customer Dimension

* Customer ID
* Customer Name
* Segment
* Region

### Product Dimension

* Product ID
* Category
* Sub-Category

### Geography Dimension

* Postal Code
* City
* State
* Region
* Country

### Sales Fact Table

* Order ID
* Customer ID
* Product ID
* Sales
* Quantity
* Discount
* Profit
* Order Date

---

## SQL Business Analysis

Performed 12 SQL-based business analyses to uncover operational and strategic insights:

1. Top Customers by Revenue
2. Sales by Region
3. Profit by Region
4. Sales by Customer Segment
5. Profit by Customer Segment
6. Category Performance Analysis
7. Sub-Category Performance Analysis
8. Discount Impact Analysis
9. Monthly Revenue Trends
10. Customer Contribution Analysis
11. Geographic Performance Analysis
12. Revenue and Profitability Breakdown

---

## Forecasting

Implemented time-series forecasting using Exponential Smoothing to estimate future sales performance and support strategic planning.

### Forecasting Outcomes

* Future sales trend estimation
* Monthly sales projections
* Demand planning support
* Revenue forecasting insights

---

## Tableau Dashboards

### Dashboard 1 – Executive Overview

Provides a high-level business performance snapshot:

* Total Sales
* Total Profit
* Total Orders
* Profit Margin
* Monthly Sales Trend
* Sales by Region
* Profit by Region

**Dashboard Screenshot**

![Executive Overview](screenshots/dashboard1.png)

---

### Dashboard 2 – Customer Analytics

Analyzes customer behavior and segment performance:

* Top Customers by Revenue
* Sales by Segment
* Profit by Segment
* Customer Performance Analysis

**Dashboard Screenshot**

![Customer Analytics](screenshots/dashboard2.png)

---

### Dashboard 3 – Product Analytics

Evaluates category and product-group performance:

* Sales by Category
* Profit by Category
* Sales by Sub-Category
* Top Performing Product Groups

**Dashboard Screenshot**

![Product Analytics](screenshots/dashboard3.png)

---

### Dashboard 4 – Profitability Analytics

Focuses on profitability optimization and discount effectiveness:

* Profit by Region
* Profit by Category
* Discount vs Profit Analysis
* Sales vs Profit Analysis
* Profit Margin Analysis

**Dashboard Screenshot**

![Profitability Analytics](screenshots/dashboard4.png)

---

## Key Insights

### Revenue Leadership

The West region generated the highest overall revenue contribution across the observed period.

### Customer Concentration

A relatively small group of customers contributed a disproportionately large share of total revenue.

### Profitability Trends

Technology-related product categories demonstrated stronger profitability compared to several other categories.

### Discount Impact

Higher discount levels showed a negative relationship with profitability, highlighting the need for optimized discount strategies.

### Business Growth

Sales exhibited a consistent upward trend over time, indicating positive business growth potential.

---

## Business Recommendations

### Optimize Discount Strategy

Reduce excessive discounting within low-margin categories to improve profitability.

### Strengthen Customer Retention

Implement retention initiatives targeting high-value customers responsible for a significant share of revenue.

### Expand High-Profit Categories

Allocate resources toward categories demonstrating strong profit margins and growth potential.

### Replicate Regional Success

Analyze and replicate sales practices from high-performing regions within lower-performing markets.

---

## Results

* Processed and analyzed 9,994 retail transactions
* Built a relational MySQL analytics database
* Conducted 12 SQL-based business analyses
* Developed forecasting models for future sales prediction
* Designed 4 interactive Tableau dashboards
* Generated actionable business recommendations

---

## Skills Demonstrated

* Data Cleaning & Preprocessing
* Exploratory Data Analysis (EDA)
* SQL Querying & Optimization
* Database Design & Modeling
* Business Intelligence
* Dashboard Development
* Forecasting & Trend Analysis
* Data Visualization
* Business Analytics
* Data Storytelling

