-- Lab 6
-- Dataset: amazon_bestsellers

/*
 Question 1
 Practicing UNION ALL and Subqueries

 Compare the number of best sellers and the avg user rating
 between "Cook Books" and "Diet Books".  "Cook Books" contain
 the word "cook" in the title, while "Diet Books" contain the
 word "diet".

 Recommended Steps:
 1) Write 2 subqueries, filtering to DISTINCT books of each type
 (as long as you leave out the year, it will become distinct by book)
 2) Wrap each subquery in an outer query that creates a new column 'category' which will be
 either 'Cook books' or 'Diet books' as appropriate.  The outer query should also aggregate
 the inner query with a COUNT (to count the number of books) and an AVG (to get the avg user_rating)
 3) Finally, UNION ALL these two queries together to get a final result that looks like this

 +----------+---------+------------------+
|category  |num_books|avg_user_rating   |
+----------+---------+------------------+
|Cook books|13       |4.6538461538461538|
|Diet books|6        |4.3333333333333333|
+----------+---------+------------------+

*/

SELECT

/*
 Question 2
 Practice filtering with a subquery

 List all the books and review counts from the author that has the most
 total book reviews in this dataset.
 Remember to de-dupe the books before aggregating.

 Recommended Steps
 1) Create a subquery where you de-dupe the books by doing a SELECT DISTINCT on name, author, reviews
 2) Wrap this subquery in an outer query that aggregates this by author,
 summing the reviews per author and limiting the output to the one author that has the most reviews
 3) Use the query from step 2, which will give you an author name, to either filter in a WHERE clause
 or filter using an INNER JOIN
 4) SELECT DISTINCT name, author, and reviews from the data produced by step 3

+---------+----------------------------------------------------------------------------------------------------------+-------+
|author   |name                                                                                                      |reviews|
+---------+----------------------------------------------------------------------------------------------------------+-------+
|E L James|Fifty Shades of Grey: Book One of the Fifty Shades Trilogy (Fifty Shades of Grey Series)                  |47265  |
|E L James|Grey: Fifty Shades of Grey as Told by Christian (Fifty Shades of Grey Series)                             |25624  |
|E L James|Fifty Shades Darker                                                                                       |23631  |
|E L James|Fifty Shades Freed: Book Three of the Fifty Shades Trilogy (Fifty Shades of Grey Series) (English Edition)|20262  |
|E L James|Fifty Shades Trilogy (Fifty Shades of Grey / Fifty Shades Darker / Fifty Shades Freed)                    |13964  |
+---------+----------------------------------------------------------------------------------------------------------+-------+

*/

SELECT
    DISTINCT author, name, reviews
FROM amazon_bestsellers
WHERE author IN (
    SELECT author
    FROM (
        SELECT DISTINCT name,
                author,
                reviews
        FROM amazon_bestsellers) author_list
GROUP BY 1
ORDER BY SUM(reviews) DESC
LIMIT 1)
ORDER BY reviews DESC
;



/*
 Question 3
 Practice analytic functions

 List the most reviewed book from each year

 Recommended Steps:
 1) Write a subquery which ranks all books in a year by the review count. 
 Use an analytic function to create this additional column that contains the rank and
 name it yearly_review_rank
 2) Wrap the subquery from 1) in an outer query that filters to only the rows that have
 yearly_review_rank = 1

 +-------------------------------------------+----------------+----+-----------+-------+------------------+
|name                                       |author          |year|user_rating|reviews|yearly_review_rank|
+-------------------------------------------+----------------+----+-----------+-------+------------------+
|The Shack: Where Tragedy Confronts Eternity|William P. Young|2009|4.6        |19720  |1                 |
|The Hunger Games                           |Suzanne Collins |2010|4.7        |32122  |1                 |
|The Hunger Games (Book 1)                  |Suzanne Collins |2011|4.7        |32122  |1                 |
|Gone Girl                                  |Gillian Flynn   |2012|4          |57271  |1                 |
|Gone Girl                                  |Gillian Flynn   |2013|4          |57271  |1                 |
|Gone Girl                                  |Gillian Flynn   |2014|4          |57271  |1                 |
|The Girl on the Train                      |Paula Hawkins   |2015|4.1        |79446  |1                 |
|The Girl on the Train                      |Paula Hawkins   |2016|4.1        |79446  |1                 |
|The Handmaid's Tale                        |Margaret Atwood |2017|4.3        |29442  |1                 |
|Becoming                                   |Michelle Obama  |2018|4.8        |61133  |1                 |
|Where the Crawdads Sing                    |Delia Owens     |2019|4.8        |87841  |1                 |
+-------------------------------------------+----------------+----+-----------+-------+------------------+

*/

SELECT *
FROM (
    SELECT name, author, year, user_rating, reviews,
       RANK() OVER (PARTITION BY year ORDER BY reviews DESC) AS yearly_review_rank
FROM amazon_bestsellers) r
WHERE yearly_review_rank = 1;

/*
Question 4
More analytic functions

Of books written by authors with at least 3 different books in this dataset,
find the top books by the % their price is over the average price for that author.
For example, if Dr. Seuss has 5 books with an average price of $10, and one of those books
had a price of $15, it would be 50% over the average price for Dr. Seuss.

Recommended Steps:
1) Create a subquery that produces authors with at least 3 different books
(Hint: use a COUNT(DISTINCT) in the HAVING clause)
2) Use the subquery from step 1 to filter the original table using WHERE or INNER JOIN
3) SELECT DISTINCT the name, author, price to create a dataset unique by book
4) Add additional columns with an analytic function that calculate the
-- AVG price per author:  Average price of books written by the author
-- % over author avg:  (price - avg_price)*100.0/(avg_price)
5) Order by % over author avg

+--------------------------------------+----------------+-----------+-------+-----+--------------------+---------------------+
|name                                  |author          |user_rating|reviews|price|avg_price_per_author|pct_over_author_avg  |
+--------------------------------------+----------------+-----------+-------+-----+--------------------+---------------------+
|The Twilight Saga Collection          |Stephenie Meyer |4.7        |3801   |82   |19.8571428571428571 |312.94964028776978506|
|Sookie Stackhouse                     |Charlaine Harris|4.7        |973    |25   |10.25               |143.9024390243902439 |
|Diary of a Wimpy Kid: The Long Haul   |Jeff Kinney     |4.8        |6540   |22   |9.25                |137.83783783783783784|
|Killing Kennedy: The End of Camelot   |Bill O'Reilly   |4.6        |8634   |25   |10.5714285714285714 |136.48648648648648713|
|The Hunger Games Trilogy Boxed Set (1)|Suzanne Collins |4.8        |16949  |30   |13.3636363636363636 |124.48979591836734755|
+--------------------------------------+----------------+-----------+-------+-----+--------------------+---------------------+

*/


