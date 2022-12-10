-- Lab 2
SELECT * FROM amazon_bestsellers;
-- Question 1
-- What was the most reviewed non-fiction book between 2014 and 2016? (return one name only)
SELECT name
FROM amazon_bestsellers
WHERE
    genre = 'Non Fiction'
    AND year BETWEEN 2014 AND 2016
ORDER BY reviews DESC
LIMIT 1;

-- Question 2
-- Return a distinct list of authors in the dataset, sorted alphabetically
SELECT DISTINCT author
FROM amazon_bestsellers
ORDER BY author ASC;

-- Question 3
-- What are the bottom 5 best sellers by user rating? Return a distinct list of name, author, and user_rating
SELECT DISTINCT name, author, user_rating
FROM amazon_bestsellers
ORDER BY user_rating ASC
LIMIT 5;

-- Question 4
-- Of best sellers with at least 10,000 reviews, which Fiction book costs the most? (return one row)
SELECT name, author, reviews, price
FROM amazon_bestsellers
WHERE
    genre = 'Fiction'
    AND reviews >= 10000
ORDER BY price DESC
LIMIT 1;

-- Question 5
-- Create a new column which is the user_rating on a 100 point scale.  The user_rating in the dataset is on a
-- 5 point scale. Call this new column "user_rating_100".  Sort by this column (highest to lowest).
-- Break ties with the number of reviews (highest to lowest).
SELECT DISTINCT
        name,
        author,
        reviews,
        user_rating * 20 AS user_rating_100
FROM amazon_bestsellers
ORDER BY user_rating_100 DESC,
         reviews DESC;

-- Question 6
-- Order all Harry Potter books (name contains Harry Potter and author is J.K. Rowling) by user_rating,
-- lowest to highest
SELECT name, author, user_rating
FROM amazon_bestsellers
WHERE name ILIKE '%Harry Potter%' AND
      (author LIKE '%J.K. Rowling%' OR
      author LIKE '%J. K. Rowling%')
ORDER BY user_rating ASC;

-- Question 7
-- Let's use # of reviews as a proxy for # of purchases.  Create a new column called est_revenue which is the
-- product of reviews and price.  What are the top 10 distinct books by est_revenue? (Hint: we see duplicate books
-- because they are best sellers across multiple years)
SELECT DISTINCT
        name,
        author,
        reviews,
        price,
        reviews * price AS est_revenue
FROM amazon_bestsellers
ORDER BY est_revenue DESC
LIMIT 10;

-- Question 8
-- What are the top 10 longest and top 10 shortest book titles in this dataset? De-dupe the titles and also
-- return the length.
-- Write two queries


-- Question 9
-- (Freeform) Find the books on dieting/weight loss in this dataset




-- Question 10
-- (Freeform) Create a new column user_rating_category which
-- categorizes the user_rating column into several different buckets.
-- You can choose yourself how to define these buckets.



-- Question 11
-- Create a new column review_count_thousands
-- The values in this column will be the number of reviews
-- to the nearest hundred, expressed in thousands followed by K
-- For example
-- 7388 => 7.4K
-- 25221 => 25.2K
-- 349 => 0.3K
-- Hint: To convert a numeric value to a string, use CAST(x AS VARCHAR)
SELECT
  name,
  reviews,
CONCAT(
    CAST(
        ROUND(ROUND(reviews, -2) / 1000.0, 1)
        AS VARCHAR
        ),
    'K'
    ) AS review_count_thousands
FROM amazon_bestsellers;

-- Question 12
-- What are the top 5 lowest rated best sellers written by
-- authors who also have a book rated >= 4.5 ?

SELECT 1/2;