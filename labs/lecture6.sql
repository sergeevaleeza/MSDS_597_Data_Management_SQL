-- Use the Northwind data for these
-- Slide 5
SELECT
    by_country_product."ShipCountry",
    by_country_product."ProductID",
    by_country_product.quantity,
    by_country_product.quantity * 100.0 / by_country.total_quantity AS pct_total
FROM (
     SELECT
         "ShipCountry",
         "ProductID",
         SUM("Quantity") AS quantity
     FROM orders
     INNER JOIN order_details od on orders."OrderID" = od."OrderID"
    GROUP BY 1,2
) by_country_product
LEFT JOIN (
    SELECT
        "ShipCountry",
        SUM("Quantity") AS total_quantity
    FROM orders
    INNER JOIN order_details od2 ON orders."OrderID" = od2."OrderID"
    GROUP BY 1
) by_country
ON by_country_product."ShipCountry" = by_country."ShipCountry"
ORDER BY 4 DESC;

-- Slide 6
-- Filter with subquery in WHERE clause
SELECT
    *
FROM products
WHERE "ProductID" IN (
    SELECT
        od."ProductID"
    FROM orders
    JOIN order_details od on orders."OrderID" = od."OrderID"
    GROUP BY 1
    ORDER BY SUM(od."UnitPrice"*"Quantity"*(1-"Discount")) DESC
    LIMIT 3
);

-- Slide 7
-- Subquery to filter data with JOIN
SELECT
    *
FROM products p
JOIN (
    SELECT
        od."ProductID",
        SUM(
            od."UnitPrice" *
            "Quantity" *
            (1-"Discount")
        ) AS sales
    FROM orders
    JOIN order_details od on orders."OrderID" = od."OrderID"
    GROUP BY 1
    ORDER BY 2 DESC
    LIMIT 3
    ) s
ON p."ProductID" = s."ProductID";


-- Slide 8
-- Subquery to aggregate in multiple stages
-- What are the average orders per day of week over every month?
SELECT
    DATE_PART('month', "OrderDate"::TIMESTAMP) AS month,
    dow,
    AVG(num_orders) AS avg_orders
FROM (
    SELECT
        "OrderDate",
        DATE_PART('dow', "OrderDate"::TIMESTAMP) AS dow,
        COUNT(1) AS num_orders
    FROM orders
    GROUP BY 1,2
    ORDER BY 1,2
) a
GROUP BY 1,2
ORDER BY 1,2;

-- Slide 9
-- CTE example
WITH orders_by_date AS (
    SELECT
        "OrderDate",
        DATE_PART('dow', "OrderDate"::TIMESTAMP) AS dow,
        COUNT(1) AS num_orders
    FROM orders
    GROUP BY 1,2
    ORDER BY 1,2
)
SELECT
    DATE_PART('month', "OrderDate"::TIMESTAMP) AS month,
    dow,
    AVG(num_orders) AS avg_orders
FROM orders_by_date
GROUP BY 1,2
ORDER BY 1,2;


-- Create table
-- I recommend doing everything below this in a new schema to separate from the Northwind data
CREATE TABLE IF NOT EXISTS monthly_product_sales
(
    month        VARCHAR,
    product_name VARCHAR,
    sales        BIGINT
);

INSERT INTO monthly_product_sales
VALUES ('2020-01', 'Apples', 300),
       ('2020-01', 'Bananas', 500),
       ('2020-02', 'Apples', 200),
       ('2020-02', 'Bananas', 300),
       ('2020-03', 'Apples', 150);

-- Slide 12
SELECT month,
       product_name,
       sales,
       -- SUMs all sales and attaches to each row
       SUM(sales) OVER ()                                    AS overall_sales,
       -- SUMs all sales per product and attaches to each row
       SUM(sales) OVER (PARTITION BY product_name)           AS total_product_sales,
       -- SUMs all sales per product over all preceding months
       SUM(sales) OVER (
           PARTITION BY product_name
           ORDER BY month
           ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS cumulative_sum
FROM monthly_product_sales;

-- Numbering functions
WITH numbers AS
         (SELECT 1 as x
          UNION ALL
          SELECT 2
          UNION ALL
          SELECT 2
          UNION ALL
          SELECT 5
          UNION ALL
          SELECT 8
          UNION ALL
          SELECT 10
          UNION ALL
          SELECT 10
         )
SELECT x,
       RANK() OVER (ORDER BY x)       AS rank,
       DENSE_RANK() OVER (ORDER BY x) AS dense_rank,
       ROW_NUMBER() OVER (ORDER BY x) AS row_num
FROM numbers;

-- What is the top selling month for each product?
SELECT
    *
FROM (
         SELECT month,
                product_name,
                sales,
                ROW_NUMBER() OVER (PARTITION BY product_name ORDER BY sales DESC) AS sales_rank
         FROM monthly_product_sales
) a
WHERE
    sales_rank = 1;

SELECT * FROM monthly_product_sales;


-- Navigation
SELECT month,
       product_name,
       sales,
       FIRST_VALUE(sales) OVER (
           PARTITION BY product_name
           ORDER BY month
           ) AS sales_first_month,
       LAG(sales, 1) OVER (
           PARTITION BY product_name
           ORDER BY month
           ) AS prev_month_sales,
       LEAD(sales, 1) OVER (
           PARTITION BY product_name
           ORDER BY month
           ) AS next_month_sales
FROM monthly_product_sales;
