/*
===================================================================================================
EXPLORATORY DATA ANALYSIS
===================================================================================================
Objective: Profile a new e-commerce dataset to understand customer demographics, 
product catalog structure, and baseline revenue metrics.
===================================================================================================
*/

/* ---------------------------------------------------------------------------------------------------
PHASE 1: BOUNDARY CHECKING & DATA PROFILING
Business Goal: What is the footprint of our business, and what is the timeframe of our data?
--------------------------------------------------------------------------------------------------- */

-- Where are our customers located? (Geographic Footprint)
SELECT DISTINCT Country 
FROM dim_customers;

-- What exactly do we sell? (Product Hierarchy)
SELECT DISTINCT 
    Category, 
    Subcategory, 
    Product_Name
FROM dim_products
ORDER BY 1, 2, 3;

-- Data Timeframe: Finding the lifespan of our sales data.
SELECT
    MIN(Order_Date) AS First_Order,
    MAX(Order_Date) AS Last_Order,
    DATEDIFF(month, MIN(Order_Date), MAX(Order_Date)) AS Data_LifeSpan_Months 
FROM fact_sales;

-- Demographics: What is the age range of our audience?
SELECT
    MAX(birthdate) AS Youngest_Customer_DOB,
    MIN(birthdate) AS Oldest_Customer_DOB,
    DATEDIFF(year, MIN(birthdate), GETDATE()) AS Oldest_Age,
    DATEDIFF(year, MAX(birthdate), GETDATE()) AS Youngest_Age
FROM dim_customers;


/* ---------------------------------------------------------------------------------------------------
PHASE 2: MACRO METRICS & THE "EXECUTIVE DASHBOARD"
Business Goal: Calculate the absolute baseline KPIs that leadership cares about.
--------------------------------------------------------------------------------------------------- */

-- The "Everything" Query: High-level overview of our volume and pricing.
SELECT
    COUNT(DISTINCT f.order_number) AS total_orders,
    COUNT(DISTINCT p.product_key) AS total_products,
    COUNT(f.customer_key) AS total_customers,
    COUNT(DISTINCT c.customer_key) AS total_customers_who_placed_order,
    SUM(f.sales_amount) AS total_sales,
    SUM(f.quantity) AS total_quantity,
    ROUND(CAST(SUM(f.sales_amount)AS FLOAT) / SUM(f.quantity), 2) AS avg_selling_price
FROM fact_sales f
LEFT JOIN dim_customers c ON f.customer_key = c.customer_key
LEFT JOIN Dim_products p ON f.product_key = p.product_key;

-- THE EXECUTIVE DASHBOARD: Using UNION ALL to pivot core KPIs into a clean, single-column summary.
SELECT 'Total Sales' AS Measure_Name, SUM(sales_amount) AS Measure_Value FROM fact_sales
UNION ALL
SELECT 'Total Quantity', SUM(quantity) FROM fact_sales
UNION ALL
SELECT 'Average Price', AVG(price) FROM fact_sales
UNION ALL
SELECT 'Total Nr. Orders', COUNT(DISTINCT order_number) FROM fact_sales
UNION ALL
SELECT 'Total Nr. Products', COUNT(product_name) FROM dim_products
UNION ALL
SELECT 'Total Nr. Customers', COUNT(customer_key) FROM dim_customers;


/* ---------------------------------------------------------------------------------------------------
PHASE 3: AUDIENCE & CATALOG PROFILING
Business Goal: Segment our volume by key dimensions (Geography, Gender, Category).
--------------------------------------------------------------------------------------------------- */

-- Customer concentration by Country
SELECT Country, COUNT(customer_key) AS Total_Nr_of_Customers
FROM dim_customers
GROUP BY country
ORDER BY COUNT(customer_key) DESC;

-- Audience split by Gender
SELECT Gender, COUNT(customer_key) AS Total_Customers
FROM dim_customers
GROUP BY gender
ORDER BY COUNT(customer_key) DESC;

-- Catalog depth: How many unique products sit within each category?
SELECT Category, COUNT(Product_key) AS Total_Products
FROM dim_products
GROUP BY Category
ORDER BY COUNT(Product_key) DESC;

-- Cost Analysis: What is the average manufacturing/acquisition cost per category?
SELECT Category, AVG(cost) AS AVG_Cost
FROM dim_products
GROUP BY category
ORDER BY AVG(cost) DESC;


/* ---------------------------------------------------------------------------------------------------
PHASE 4: REVENUE DISTRIBUTION & TOP PERFORMERS
Business Goal: Follow the money. Where is our revenue actually coming from?
--------------------------------------------------------------------------------------------------- */

-- Revenue Contribution by Category
SELECT p.Category, SUM(f.Sales_amount) AS Total_Sales
FROM fact_sales f
LEFT JOIN dim_products p ON f.product_key = p.product_key
GROUP BY p.Category
ORDER BY SUM(f.Sales_amount) DESC;

-- "Whale" Hunting: Identifying our highest-spending individual customers.
SELECT
    c.Customer_Key, c.First_Name, c.Last_Name,
    SUM(f.Sales_amount) AS Revenue
FROM fact_sales f
LEFT JOIN dim_customers c ON f.customer_key = c.customer_key
GROUP BY c.Customer_Key, c.First_name, c.Last_Name
ORDER BY SUM(f.Sales_amount) DESC;

-- Global Volume Distribution: Calculating the % of total quantity sold per country.
SELECT
    Country,
    Total_Quantity,
    CONCAT(ROUND(CAST(Total_Quantity AS FLOAT) / SUM(Total_Quantity) OVER() * 100, 2), '%') AS Percentage_of_Global_Volume,
    SUM(Total_Quantity) OVER() AS Overall_Quantity_Sold
FROM (
    SELECT c.Country, SUM(f.Quantity) AS Total_Quantity
    FROM fact_sales f
    LEFT JOIN dim_customers c ON f.customer_key = c.customer_key
    GROUP BY c.Country
) t
ORDER BY Total_Quantity DESC;

-- THE WINNERS: Top 5 Highest Grossing Products (Using ROW_NUMBER for precise ranking).
SELECT Product_Key, Product_Name, Revenue, Rank
FROM (
    SELECT
        p.Product_Key, p.Product_Name,
        SUM(f.Sales_amount) AS Revenue,
        ROW_NUMBER() OVER(ORDER BY SUM(f.Sales_amount) DESC) AS Rank
    FROM fact_sales f
    LEFT JOIN dim_Products p ON f.product_key = p.product_key
    GROUP BY p.Product_Key, p.Product_Name
) t
WHERE rank <= 5;

-- THE DEAD WEIGHT: Bottom 5 Underperforming Products (Candidate for discontinuation).
SELECT TOP 5
    p.Product_Key, p.Product_Name,
    SUM(f.Sales_amount) AS Revenue
FROM fact_sales f
LEFT JOIN dim_Products p ON f.product_key = p.product_key
GROUP BY p.Product_Key, p.Product_Name
ORDER BY SUM(f.Sales_amount) ASC; -- Ascending order bubbles the lowest revenue to the top