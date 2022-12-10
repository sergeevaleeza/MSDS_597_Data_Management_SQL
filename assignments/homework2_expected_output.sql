SELECT * FROM imdb.actors;
SELECT * FROM imdb.movies;
SELECT * FROM imdb.actors;

/*
Question 1
List the name and height of the actresses who have been married to Tom Cruise
Order by name alphabetically
*/
SELECT name, height
FROM imdb.actors
WHERE spouses_string LIKE '%Tom Cruise%'
LIMIT 3;
+-------------+------+
|name         |height|
+-------------+------+
|Katie Holmes |175   |
|Mimi Rogers  |173   |
|Nicole Kidman|180   |
+-------------+------+


/*
Question 2
List the name, # of spouses, and # of divorces of the top 5 actors by number of divorces, then by name
 */

SELECT name, spouses, divorces
FROM imdb.actors
ORDER BY divorces DESC
LIMIT 5;

+----------------+-------+--------+
|name            |spouses|divorces|
+----------------+-------+--------+
|Tahiyyah Karyuka|12     |12      |
|Nagwa Fouad     |9      |9       |
|Eddie Barclay   |8      |8       |
|Norman Selby    |9      |8       |
|Soheir Ramzy    |9      |8       |
+----------------+-------+--------+



/*
Question 3
The original title, year, genre, country, average rating, and number of votes of
the top 5 Horror movies made in the USA with at least 10,000 votes
Break ties in avg_rating with the original_title (alphabetically).
 */
SELECT original_title, year, genre, country, avg_vote, votes
FROM movies
WHERE genre LIKE '%Horror%' AND
      country LIKE '%USA%' AND
      votes >= 10000
ORDER BY avg_vote DESC, original_title ASC
LIMIT 5;

+--------------------------------+----+-------------------------+-------+--------+------+
|original_title                  |year|genre                    |country|avg_vote|votes |
+--------------------------------+----+-------------------------+-------+--------+------+
|Psycho                          |1960|Horror, Mystery, Thriller|USA    |8.5     |586765|
|Alien                           |1979|Horror, Sci-Fi           |UK, USA|8.4     |768874|
|The Shining                     |1980|Drama, Horror            |UK, USA|8.4     |869480|
|The Thing                       |1982|Horror, Mystery, Sci-Fi  |USA    |8.1     |360147|
|What Ever Happened to Baby Jane?|1962|Drama, Horror, Thriller  |USA    |8.1     |48788 |
+--------------------------------+----+-------------------------+-------+--------+------+


/*
Question 4
Name, date of birth, and place of birth of the
top 10 youngest living actors who were born on Feb 29 in the USA.
Order by youngest to oldest, then by name alphabetically.
*/

SELECT name, date_of_birth, place_of_birth
FROM actors
WHERE date_of_birth LIKE '%-02-29' AND
      place_of_birth LIKE '%USA%'
ORDER BY date_of_birth DESC
LIMIT 10;

+---------------------+-------------+--------------------------------------------+
|name                 |date_of_birth|place_of_birth                              |
+---------------------+-------------+--------------------------------------------+
|Caitlin E.J. Meyer   |1992-02-29   |Salt Lake City, Utah, USA                   |
|James Cullen Bressack|1992-02-29   |Los Angeles, California, USA                |
|Jessie T. Usher      |1992-02-29   |Maryland, USA                               |
|Travis Huff          |1984-02-29   |Greenville, Ohio, USA                       |
|Christine Cowden     |1980-02-29   |Fort Lauderdale, Florida, USA               |
|Peter Scanavino      |1980-02-29   |Denver, Colorado, USA                       |
|Phil Haney           |1980-02-29   |Syracuse, New York, USA                     |
|Ja Rule              |1976-02-29   |Hollis, Queens, New York City, New York, USA|
|Saul Williams        |1972-02-29   |Newburgh, New York, USA                     |
|Dallas Barnett       |1964-02-29   |Rochester, New York, USA                    |
+---------------------+-------------+--------------------------------------------+


/*
Question 5
What is the original title and duration of the longest movie made by the production company 'Marvel Studios'?
Rename the column 'original_title' to 'movie_title' and 'duration' to 'length_in_minutes'
 */

SELECT original_title AS movie_title,
       duration AS length_in_minutes
FROM movies
WHERE production_company LIKE '%Marvel Studios%'
ORDER BY length_in_minutes DESC
LIMIT 1;

+-----------------+-----------------+
|movie_title      |length_in_minutes|
+-----------------+-----------------+
|Avengers: Endgame|181              |
+-----------------+-----------------+


/*
Question 6
Which production companies have made movies with at least an avg_vote of 8.8 over at least 100,000 votes?
Return the list in alphabetical order.
*/

SELECT DISTINCT production_company
FROM movies
WHERE avg_vote >= 8.8 AND
      votes >= 100000
ORDER BY production_company ASC;


+----------------------------------+
|production_company                |
+----------------------------------+
|3leven                            |
|Castle Rock Entertainment         |
|Fox 2000 Pictures                 |
|Fox STAR Studios                  |
|Miramax                           |
|New Line Cinema                   |
|Orion-Nova Productions            |
|Paramount Pictures                |
|Produzioni Europee Associate (PEA)|
|Universal Pictures                |
|Warner Bros.                      |
+----------------------------------+


/*
Question 7
List the movies published between Christmas 2017 (2017-12-25) and New Years 2018 (2018-01-01)
Only include movies with at least 10,000 votes.
Order them by avg_vote, highest to lowest.
*/

SELECT original_title, date_published, avg_vote
FROM movies
WHERE votes >= 10000 AND
      date_published >= '2017-12-25' AND
      date_published <= '2018-01-01'
ORDER BY avg_vote DESC;

+------------------------------+--------------+--------+
|original_title                |date_published|avg_vote|
+------------------------------+--------------+--------+
|Coco                          |2017-12-28    |8.4     |
|The Greatest Showman          |2017-12-25    |7.6     |
|Den 12. mann                  |2017-12-25    |7.4     |
|Jumanji: Welcome to the Jungle|2018-01-01    |6.9     |
+------------------------------+--------------+--------+


/*
Question 8
Find the original_title, year, budget, and world-wide gross income of the
top 5 highest world-wide grossing zombie movies
Hint: You may need to use LTRIM to trim the '$ ' from worldwide_gross_income
*/
SELECT
       original_title,
       year,
       budget,
       worlwide_gross_income
FROM
     movies
WHERE
      LOWER(description) LIKE '%zombie%' AND
      budget LIKE '%$%' AND
      worlwide_gross_income LIKE '%$%'
ORDER BY
    CAST(
        (TRIM('$ ' FROM worlwide_gross_income))
        AS NUMERIC
        ) DESC
LIMIT 5;

+-------------------------+----+-----------+---------------------+
|original_title           |year|budget     |worlwide_gross_income|
+-------------------------+----+-----------+---------------------+
|World War Z              |2013|$ 190000000|$ 540007876          |
|Resident Evil: Apocalypse|2004|$ 45000000 |$ 129342769          |
|Zombieland: Double Tap   |2019|$ 42000000 |$ 122810399          |
|Warm Bodies              |2013|$ 35000000 |$ 116980662          |
|ParaNorman               |2012|$ 60000000 |$ 107139399          |
+-------------------------+----+-----------+---------------------+


/*
Question 9
Find the top 10 actors by height (order by name, alphabetically, to break ties in height)
List the name, height (renamed to height_cm), and height_ft, which is height in feet/inches (e.g. 6 feet 5 inches),
rounded to the nearest inch.
There are 2.54 cm in 1 inch.  There are 12 inches in one foot.
Exclude any actors with a height >= 300 (as I believe there are some data errors)

Hint: To convert from one data type to another, use CAST(x AS <desired data type>)
You can use VARCHAR (for strings), INT (for integers), NUMERIC or DECIMAL (for floats)
*/

SELECT
       name,
       height AS height_cm,
       concat(floor(height / (2.54 * 12)), ' feet ',
              round(height / 2.54) % 12, ' inches') AS height_ft
FROM
     actors
WHERE
      height <= 300
ORDER BY
         height_cm DESC,
         name
LIMIT 10;

+------------------+---------+----------------+
|name              |height_cm|height_ft       |
+------------------+---------+----------------+
|Bart the Bear     |293      |9 feet 7 inches |
|Max Palmer        |249      |8 feet 2 inches |
|Thomas H. McDaniel|241      |7 feet 11 inches|
|Jerald Sokolowski |234      |7 feet 8 inches |
|Gheorghe Muresan  |231      |7 feet 7 inches |
|Baocheng Jiang    |230      |7 feet 7 inches |
|John Bloom        |224      |7 feet 4 inches |
|John Aasen        |220      |7 feet 3 inches |
|Johnny Rosenthal  |220      |7 feet 3 inches |
|Kevin Peter Hall  |220      |7 feet 3 inches |
+------------------+---------+----------------+


/*
Question 10
List the original_title, usa_gross_income, worlwide_gross_income, and pct_gross_income_usa,
defined as the percentage of USA gross income out of total income,
for Tom Hanks movies.  Return the lowest 10 movies only by pct_gross_income_usa (i.e. the 10 movies that
had the lowest pct_gross_income_usa).
Round pct_gross_income_usa to one decimal place.
*/

SELECT
       original_title,
       usa_gross_income,
       worlwide_gross_income,
       ROUND(
           (ROUND(
               CAST(
                   (TRIM('$ ' FROM usa_gross_income))
                   AS NUMERIC), 1) /
            ROUND(
                CAST(
                    (TRIM('$ ' FROM worlwide_gross_income))
                    AS NUMERIC), 1) * 100
               ), 1)
           AS pct_gross_income_usa
FROM
     imdb.movies
WHERE
      LOWER(director) LIKE '%tom hanks%' OR
      LOWER(actors) LIKE '%tom hanks%'
ORDER BY
         pct_gross_income_usa ASC
LIMIT 10;

+-----------------+----------------+---------------------+--------------------+
|original_title   |usa_gross_income|worlwide_gross_income|pct_gross_income_usa|
+-----------------+----------------+---------------------+--------------------+
|Inferno          |$ 34343574      |$ 220021259          |15.6                |
|Cloud Atlas      |$ 27108272      |$ 130482868          |20.8                |
|Angels & Demons  |$ 133375846     |$ 485930816          |27.4                |
|The Da Vinci Code|$ 217536138     |$ 760006945          |28.6                |
|The Terminal     |$ 77872883      |$ 219100084          |35.5                |
|Philadelphia     |$ 77446440      |$ 206678440          |37.5                |
|Toy Story 3      |$ 415004880     |$ 1066969703         |38.9                |
|Toy Story 4      |$ 434038008     |$ 1073394593         |40.4                |
|The Post         |$ 81903458      |$ 192938646          |42.5                |
|Bridge of Spies  |$ 72313754      |$ 165478348          |43.7                |
+-----------------+----------------+---------------------+--------------------+




