




'/ CASE statements and Aggregations'
SELECT 
    CASE WHEN LOWER(variety) LIKE '%chicken%' THEN 'Chicken'
         WHEN LOWER(variety) LIKE '%beef%' THEN 'Beef'
         WHEN LOWER(variety) LIKE '%shrimp%' THEN 'Shrimp'
         WHEN LOWER(variety) LIKE '%seafood%' THEN 'Seafood'
         ELSE 'Other' END AS flavor,
         AVG(stars) AS avg_stars,
         COUNT(1) AS num_reviews
FROM ramen_ratings
GROUP BY 1
ORDER BY 2 DESC;

SELECT
    COUNT(CASE WHEN country = 'Japan' THEN country ELSE NULL END) * 100.0 / COUNT(1),
    AVG(CASE WHen country = 'Japan' THEN 1 ELSE 0 END) * 100.0
FROM ramen_ratings;



'/ Multilevel Aggregations and the HAVING clause'
SELECT
    avg_price,
    COUNT(1) AS num_authors
FROM (
    SELECT author,
           ROUND(AVG(price), 1) AS avg_price
    FROM (
        SELECT DISTINCT name,
                        author,
                        user_rating,
                        reviews,
                        price,
        FROM amazon_bestsellers
    ) distinct_books
    GROUP BY 1
    ORDER BY 2 DESC
) avg_price_by_author
GROUP BY 1
ORDER BY 1;

SELECT
    brand,
    AVG(stars) AS avg_stars,
    COUNT(1) AS num_reviews
FROM ramen_ratings
GROUP BY 1
HAVING COUNT(1) >= 10 AND AVG(stars) >= 4
ORDER BY 2 DESC;


'/Date data types and date manipulations'
SELECT ds,
       DATE_PART('year', ds) AS yr,
       DATE_PART('month', ds) AS month,
       DATE_PART('day', ds) AS day,
       DATE_TRUNC('year', ds) AS yr_date_trunc,
       DATE_TRUNC('month', ds) AS month_date_trunc,
       DATE_TRUNC('day', ds) AS day_date_trunc
FROM dates;
       
