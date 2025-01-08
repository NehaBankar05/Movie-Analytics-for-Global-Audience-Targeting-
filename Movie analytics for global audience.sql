USE imdb;

/* Now that you have imported the data sets, let’s explore some of the tables. 
 To begin with, it is beneficial to know the shape of the tables and whether any column has null values.
 Further in this segment, you will take a look at 'movies' and 'genre' tables.*/



-- Segment 1:




-- Q1. Find the total number of rows in each table of the schema?
-- Type your code below:

select 'director_mapping' as Table__Name , count(*) as TOTAL_ROWS from director_mapping
union all
select 'genre' as Table__Name, count(*) as TOTAL_ROWS from genre
union all 
select 'movie' as Table__Name, count(*) as TOTAL_ROWS from movie
union all 
select 'names' as Table__Name, count(*) as TOTAL_ROWS from names
union all 
select 'ratings' as Table__Name, count(*) as TOTAL_ROWS from ratings
union all 
select 'role_mapping' as Table__Name, count(*) as TOTAL_ROWS from role_mapping;






-- Q2. Which columns in the movie table have null values?
-- Type your code below:

SELECT 'id' AS column_name FROM movie WHERE id IS NULL
UNION
SELECT 'title' AS column_name FROM movie WHERE title IS NULL
UNION
SELECT 'year' AS column_name FROM movie WHERE year IS NULL
UNION
SELECT 'date_published' AS column_name FROM movie WHERE date_published IS NULL
UNION
SELECT 'duration' AS column_name FROM movie WHERE duration IS NULL
UNION
SELECT 'country' AS column_name FROM movie WHERE country IS NULL
UNION
SELECT 'worlwide_gross_income' AS column_name FROM movie WHERE worlwide_gross_income IS NULL
UNION
SELECT 'languages' AS column_name FROM movie WHERE languages IS NULL;








-- Now as you can see four columns of the movie table has null values. Let's look at the at the movies released each year. 
-- Q3. Find the total number of movies released each year? How does the trend look month wise? (Output expected)

/* Output format for the first part:

+---------------+-------------------+
| Year			|	number_of_movies|
+-------------------+----------------
|	2017		|	2134			|
|	2018		|		.			|
|	2019		|		.			|
+---------------+-------------------+


Output format for the second part of the question:
+---------------+-------------------+
|	month_num	|	number_of_movies|
+---------------+----------------
|	1			|	 134			|
|	2			|	 231			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

select 
 year(date_published) as Year,
 count(*) as number_of_movies
from movie
group by year(date_published)
order by Year; 

select 
 month(date_published) as month_num,
 count(*) as number_of_movies
 from movie
 group by month(date_published)
 order by month_num;






/*The highest number of movies is produced in the month of March.
So, now that you have understood the month-wise trend of movies, let’s take a look at the other details in the movies table. 
We know USA and India produces huge number of movies each year. Lets find the number of movies produced by USA or India for the last year.*/
  
-- Q4. How many movies were produced in the USA or India in the year 2019??
-- Type your code below:

select 
    count(*) AS number_of_movies
from movie
where year = 2019
and (country = 'USA' OR country = 'India');




/* USA and India produced more than a thousand movies(you know the exact number!) in the year 2019.
Exploring table Genre would be fun!! 
Let’s find out the different genres in the dataset.*/

-- Q5. Find the unique list of the genres present in the data set?
-- Type your code below:

select distinct genre
from genre;









/* So, RSVP Movies plans to make a movie of one of these genres.
Now, wouldn’t you want to know which genre had the highest number of movies produced in the last year?
Combining both the movie and genres table can give more interesting insights. */

-- Q6.Which genre had the highest number of movies produced overall?
-- Type your code below:

select genre,
count(*) as number_of_movies
from genre
group by genre
order by number_of_movies desc
limit 1;







/* So, based on the insight that you just drew, RSVP Movies should focus on the ‘Drama’ genre. 
But wait, it is too early to decide. A movie can belong to two or more genres. 
So, let’s find out the count of movies that belong to only one genre.*/

-- Q7. How many movies belong to only one genre?
-- Type your code below:

select count(*) as single_genre_movies
from (
    select movie_id
    from genre
    group by  movie_id
    having count(genre) = 1
) as single_genre_movies;






/* There are more than three thousand movies which has only one genre associated with them.
So, this figure appears significant. 
Now, let's find out the possible duration of RSVP Movies’ next project.*/

-- Q8.What is the average duration of movies in each genre? 
-- (Note: The same movie can belong to multiple genres.)


/* Output format:

+---------------+-------------------+
| genre			|	avg_duration	|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

select 
    g.genre, 
    avg(m.duration) as avg_duration
from genre g
join movie m on g.movie_id = m.id
group by g.genre
order by g.genre;








/* Now you know, movies of genre 'Drama' (produced highest in number in 2019) has the average duration of 106.77 mins.
Lets find where the movies of genre 'thriller' on the basis of number of movies.*/

-- Q9.What is the rank of the ‘thriller’ genre of movies among all the genres in terms of number of movies produced? 
-- (Hint: Use the Rank function)


/* Output format:
+---------------+-------------------+---------------------+
| genre			|		movie_count	|		genre_rank    |	
+---------------+-------------------+---------------------+
|drama			|	2312			|			2		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:

with genre_counts as (
    select
        g.genre, 
        COUNT(*) as movie_count
    from imdb.genre g
    group by g.genre
),
ranked_genres as (
    select 
        genre, 
        movie_count,
        rank() over (order by movie_count DESC) as genre_rank
    FROM genre_counts
)
select *
from ranked_genres
where genre = 'thriller';









/*Thriller movies is in top 3 among all genres in terms of number of movies
 In the previous segment, you analysed the movies and genres tables. 
 In this segment, you will analyse the ratings table as well.
To start with lets get the min and max values of different columns in the table*/




-- Segment 2:




-- Q10.  Find the minimum and maximum values in  each column of the ratings table except the movie_id column?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
| min_avg_rating|	max_avg_rating	|	min_total_votes   |	max_total_votes 	 |min_median_rating|min_median_rating|
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
|		0		|			5		|	       177		  |	   2000	    		 |		0	       |	8			 |
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+*/
-- Type your code below:

select
min(avg_rating) as min_avg_rating,
max(avg_rating) as max_avg_rating,
min(total_votes) as min_total_votes,
max(total_votes) as max_total_votes,
min(median_rating) as min_median_rating,
max(median_rating) as max_median_rating
from ratings;



    

/* So, the minimum and maximum values in each column of the ratings table are in the expected range. 
This implies there are no outliers in the table. 
Now, let’s find out the top 10 movies based on average rating.*/

-- Q11. Which are the top 10 movies based on average rating?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		movie_rank    |
+---------------+-------------------+---------------------+
| Fan			|		9.6			|			5	  	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:
-- It's ok if RANK() or DENSE_RANK() is used too

with ranked_movies AS (
    select 
        m.title,
        r.avg_rating,
        rank() over (order by  r.avg_rating DESC) as movie_rank
    from movie m
    join ratings r ON m.id = r.movie_id
)
select 
    title, 
    avg_rating, 
    movie_rank
from ranked_movies
where movie_rank <= 10
order by movie_rank
limit 10;







/* Do you find you favourite movie FAN in the top 10 movies with an average rating of 9.6? If not, please check your code again!!
So, now that you know the top 10 movies, do you think character actors and filler actors can be from these movies?
Summarising the ratings table based on the movie counts by median rating can give an excellent insight.*/

-- Q12. Summarise the ratings table based on the movie counts by median ratings.
/* Output format:

+---------------+-------------------+
| median_rating	|	movie_count		|
+-------------------+----------------
|	1			|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
-- Order by is good to have

select
    median_rating,
    count(*) AS movie_count
from imdb.ratings
GROUP BY median_rating
ORDER BY median_rating;









/* Movies with a median rating of 7 is highest in number. 
Now, let's find out the production house with which RSVP Movies can partner for its next project.*/

-- Q13. Which production house has produced the most number of hit movies (average rating > 8)??
/* Output format:
+------------------+-------------------+---------------------+
|production_company|movie_count	       |	prod_company_rank|
+------------------+-------------------+---------------------+
| The Archers	   |		1		   |			1	  	 |
+------------------+-------------------+---------------------+*/
-- Type your code below:

WITH hit_movies AS (
    select 
        m.production_company,
        count(*) AS movie_count
    from movie m
    join ratings r ON m.id = r.movie_id
    where r.avg_rating > 8
    and m.production_company IS NOT NULL
    group by m.production_company
),
ranked_production_companies AS (
    select 
        production_company,
        movie_count,
        rank() OVER (ORDER BY movie_count DESC) AS prod_company_rank
    from hit_movies
)
SELECT 
    production_company,
    movie_count,
    prod_company_rank
from ranked_production_companies
where prod_company_rank = 1;








-- It's ok if RANK() or DENSE_RANK() is used too
-- Answer can be Dream Warrior Pictures or National Theatre Live or both

-- Q14. How many movies released in each genre during March 2017 in the USA had more than 1,000 votes?
/* Output format:

+---------------+-------------------+
| genre			|	movie_count		|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

SELECT 
    g.genre,
    count(*) AS movie_count
from movie m
join ratings r ON m.id = r.movie_id
join genre g ON m.id = g.movie_id
where m.date_published >= '2017-03-01' 
  and m.date_published < '2017-04-01'
  and m.country = 'USA'
  and r.total_votes > 1000
GROUP BY g.genre
ORDER BY movie_count DESC;








-- Lets try to analyse with a unique problem statement.
-- Q15. Find movies of each genre that start with the word ‘The’ and which have an average rating > 8?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		genre	      |
+---------------+-------------------+---------------------+
| Theeran		|		8.3			|		Thriller	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:

SELECT 
    m.title,
    r.avg_rating,
    g.genre
from movie m
join ratings r ON m.id = r.movie_id
join genre g ON m.id = g.movie_id
where m.title LIKE 'The%'
  and r.avg_rating > 8
ORDER BY g.genre, m.title;








-- You should also try your hand at median rating and check whether the ‘median rating’ column gives any significant insights.
-- Q16. Of the movies released between 1 April 2018 and 1 April 2019, how many were given a median rating of 8?
-- Type your code below:


SELECT 
    count(*) AS movie_count
from movie m
join ratings r ON m.id = r.movie_id
where m.date_published >= '2018-04-01'
  AND m.date_published < '2019-04-01'
  AND r.median_rating = 8;







-- Once again, try to solve the problem given below.
-- Q17. Do German movies get more votes than Italian movies? 
-- Hint: Here you have to find the total number of votes for both German and Italian movies.
-- Type your code below:

SELECT 
    m.country,
    SUM(r.total_votes) AS total_votes
from movie m
join ratings r ON m.id = r.movie_id
where m.country IN ('Germany', 'Italy')
GROUP BY m.country
ORDER BY total_votes DESC;







-- Answer is Yes

/* Now that you have analysed the movies, genres and ratings tables, let us now analyse another table, the names table. 
Let’s begin by searching for null values in the tables.*/




-- Segment 3:



-- Q18. Which columns in the names table have null values??
/*Hint: You can find null values for individual columns or follow below output format
+---------------+-------------------+---------------------+----------------------+
| name_nulls	|	height_nulls	|date_of_birth_nulls  |known_for_movies_nulls|
+---------------+-------------------+---------------------+----------------------+
|		0		|			123		|	       1234		  |	   12345	    	 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:

SELECT 
    SUM(case when name IS NULL THEN 1 ELSE 0 END) AS name_nulls,
    SUM(case when height IS NULL THEN 1 ELSE 0 END) AS height_nulls,
    SUM(case when date_of_birth IS NULL THEN 1 ELSE 0 END) AS date_of_birth_nulls,
    SUM(case when known_for_movies IS NULL THEN 1 ELSE 0 END) AS known_for_movies_nulls
from names;







/* There are no Null value in the column 'name'.
The director is the most important person in a movie crew. 
Let’s find out the top three directors in the top three genres who can be hired by RSVP Movies.*/

-- Q19. Who are the top three directors in the top three genres whose movies have an average rating > 8?
-- (Hint: The top three genres would have the most number of movies with an average rating > 8.)
/* Output format:

+---------------+-------------------+
| director_name	|	movie_count		|
+---------------+-------------------|
|James Mangold	|		4			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

WITH top_genres AS (
    SELECT 
        g.genre,
        COUNT(m.id) AS movie_count
    from movie m
    join ratings r ON m.id = r.movie_id
    join genre g ON m.id = g.movie_id
    where r.avg_rating > 8
    GROUP BY g.genre
    ORDER BY movie_count DESC
    LIMIT 3
),
top_directors AS (
    SELECT 
        dm.name_id, 
        g.genre,
        COUNT(m.id) AS movie_count
    from movie m
    join ratings r ON m.id = r.movie_id
    join genre g ON m.id = g.movie_id
    join director_mapping dm ON m.id = dm.movie_id
    where r.avg_rating > 8
      AND g.genre IN (SELECT genre FROM top_genres)
    GROUP BY dm.name_id, g.genre
),
director_names AS (
    SELECT 
        d.name_id, 
        n.name AS director_name
    from names n
    join top_directors d ON n.id = d.name_id
)
SELECT 
    director_names.director_name, 
    SUM(top_directors.movie_count) AS movie_count
from director_names
join top_directors ON director_names.name_id = top_directors.name_id
GROUP BY director_names.director_name
ORDER BY movie_count DESC
LIMIT 3;








/* James Mangold can be hired as the director for RSVP's next project. Do you remeber his movies, 'Logan' and 'The Wolverine'. 
Now, let’s find out the top two actors.*/

-- Q20. Who are the top two actors whose movies have a median rating >= 8?
/* Output format:

+---------------+-------------------+
| actor_name	|	movie_count		|
+-------------------+----------------
|Christain Bale	|		10			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

WITH actors_movies AS (
    SELECT 
        rm.name_id, 
        COUNT(m.id) AS movie_count
    from movie m
    join ratings r ON m.id = r.movie_id
    join role_mapping rm ON m.id = rm.movie_id
    where r.median_rating >= 8
      AND rm.category = 'actor' 
    GROUP BY rm.name_id
),
actor_names AS (
    SELECT 
        am.name_id,
        n.name AS actor_name,
        am.movie_count
    from actors_movies am
    join names n ON am.name_id = n.id
)
SELECT 
    actor_name, 
    movie_count
from actor_names
ORDER BY movie_count DESC
LIMIT 2;







/* Have you find your favourite actor 'Mohanlal' in the list. If no, please check your code again. 
RSVP Movies plans to partner with other global production houses. 
Let’s find out the top three production houses in the world.*/

-- Q21. Which are the top three production houses based on the number of votes received by their movies?
/* Output format:
+------------------+--------------------+---------------------+
|production_company|vote_count			|		prod_comp_rank|
+------------------+--------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:

WITH production_votes AS (
    SELECT 
        m.production_company, 
        SUM(r.total_votes) AS vote_count
    from movie m
    join ratings r ON m.id = r.movie_id
    where m.production_company IS NOT NULL
    GROUP BY m.production_company
),
ranked_production_houses AS (
    SELECT 
        production_company, 
        vote_count,
        RANK() OVER (ORDER BY vote_count DESC) AS prod_comp_rank
    from production_votes
)
SELECT 
    production_company, 
    vote_count, 
    prod_comp_rank
from ranked_production_houses
ORDER BY prod_comp_rank
LIMIT 3;









/*Yes Marvel Studios rules the movie world.
So, these are the top three production houses based on the number of votes received by the movies they have produced.

Since RSVP Movies is based out of Mumbai, India also wants to woo its local audience. 
RSVP Movies also wants to hire a few Indian actors for its upcoming project to give a regional feel. 
Let’s find who these actors could be.*/

-- Q22. Rank actors with movies released in India based on their average ratings. Which actor is at the top of the list?
-- Note: The actor should have acted in at least five Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actor_name	|	total_votes		|	movie_count		  |	actor_avg_rating 	 |actor_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Yogi Babu	|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

WITH indian_movies AS (
    SELECT 
        m.id AS movie_id, 
        m.title, 
        m.country, 
        r.avg_rating, 
        r.total_votes
    from movie m
    join ratings r ON m.id = r.movie_id
    where m.country = 'India'
),
actors_with_indian_movies AS (
    SELECT 
        rm.name_id, 
        COUNT(im.movie_id) AS movie_count, 
        SUM(im.avg_rating * im.total_votes) / SUM(im.total_votes) AS weighted_avg_rating, 
        SUM(im.total_votes) AS total_votes
    from indian_movies im
    join role_mapping rm ON im.movie_id = rm.movie_id
    where rm.category = 'actor'
    GROUP BY rm.name_id
    HAVING COUNT(im.movie_id) >= 5 
),
actor_names AS (
    SELECT 
        awim.name_id, 
        n.name AS actor_name, 
        awim.movie_count, 
        awim.weighted_avg_rating, 
        awim.total_votes
    from actors_with_indian_movies awim
    join names n ON awim.name_id = n.id
)
SELECT 
    actor_name, 
    total_votes, 
    movie_count, 
    ROUND(weighted_avg_rating, 2) AS actor_avg_rating, 
    RANK() OVER (ORDER BY weighted_avg_rating DESC, total_votes DESC) AS actor_rank
from actor_names
ORDER BY actor_rank
LIMIT 1;








-- Top actor is Vijay Sethupathi

-- Q23.Find out the top five actresses in Hindi movies released in India based on their average ratings? 
-- Note: The actresses should have acted in at least three Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |	actress_avg_rating 	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Tabu		|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

WITH hindi_movies AS (
    SELECT 
        m.id AS movie_id, 
        m.title, 
        m.country, 
        m.languages, 
        r.avg_rating, 
        r.total_votes
    from movie m
    join ratings r ON m.id = r.movie_id
    where m.country = 'India' AND m.languages LIKE '%Hindi%'
),
actresses_with_hindi_movies AS (
    SELECT 
        rm.name_id, 
        COUNT(hm.movie_id) AS movie_count, 
        SUM(hm.avg_rating * hm.total_votes) / SUM(hm.total_votes) AS weighted_avg_rating, 
        SUM(hm.total_votes) AS total_votes
    from hindi_movies hm
    join role_mapping rm ON hm.movie_id = rm.movie_id
    join names n ON rm.name_id = n.id
    where rm.category = 'actress'
    GROUP BY rm.name_id
    HAVING COUNT(hm.movie_id) >= 3 
),
actress_names AS (
    SELECT 
        awhm.name_id, 
        n.name AS actress_name, 
        awhm.movie_count, 
        awhm.weighted_avg_rating, 
        awhm.total_votes
    from actresses_with_hindi_movies awhm
    join names n ON awhm.name_id = n.id
)
SELECT 
    actress_name, 
    total_votes, 
    movie_count, 
    ROUND(weighted_avg_rating, 2) AS actress_avg_rating, 
    RANK() OVER (ORDER BY weighted_avg_rating DESC, total_votes DESC) AS actress_rank
from actress_names
ORDER BY actress_rank
LIMIT 5;








/* Taapsee Pannu tops with average rating 7.74. 
Now let us divide all the thriller movies in the following categories and find out their numbers.*/


/* Q24. Select thriller movies as per avg rating and classify them in the following category: 

			Rating > 8: Superhit movies
			Rating between 7 and 8: Hit movies
			Rating between 5 and 7: One-time-watch movies
			Rating < 5: Flop movies
--------------------------------------------------------------------------------------------*/
-- Type your code below:

SELECT 
    m.title, 
    r.avg_rating, 
    CASE 
        when r.avg_rating > 8 THEN 'Superhit movies'
        when r.avg_rating BETWEEN 7 AND 8 THEN 'Hit movies'
        when r.avg_rating BETWEEN 5 AND 7 THEN 'One-time-watch movies'
        else 'Flop movies'
    END AS movie_category
from movie m
join genre g ON m.id = g.movie_id
join ratings r ON m.id = r.movie_id
where g.genre = 'Thriller'
ORDER BY r.avg_rating DESC;








/* Until now, you have analysed various tables of the data set. 
Now, you will perform some tasks that will give you a broader understanding of the data in this segment.*/

-- Segment 4:

-- Q25. What is the genre-wise running total and moving average of the average movie duration? 
-- (Note: You need to show the output table in the question.) 
/* Output format:
+---------------+-------------------+---------------------+----------------------+
| genre			|	avg_duration	|running_total_duration|moving_avg_duration  |
+---------------+-------------------+---------------------+----------------------+
|	comdy		|			145		|	       106.2	  |	   128.42	    	 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:

SELECT 
    g.genre, 
    AVG(m.duration) AS avg_duration,
    SUM(AVG(m.duration)) OVER (PARTITION BY g.genre ORDER BY m.id) AS running_total_duration,
    AVG(AVG(m.duration)) OVER (PARTITION BY g.genre ORDER BY m.id ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) AS moving_avg_duration
from movie m
join genre g ON m.id = g.movie_id
GROUP BY g.genre, m.id
ORDER BY g.genre;








-- Round is good to have and not a must have; Same thing applies to sorting


-- Let us find top 5 movies of each year with top 3 genres.

-- Q26. Which are the five highest-grossing movies of each year that belong to the top three genres? 
-- (Note: The top 3 genres would have the most number of movies.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| genre			|	year			|	movie_name		  |worldwide_gross_income|movie_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	comedy		|			2017	|	       indian	  |	   $103244842	     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

-- Top 3 Genres based on most number of movies

WITH TopGenres AS (
    SELECT 
        g.genre, 
        COUNT(m.id) AS movie_count
    from 
        genre g
    join 
        movie m ON g.movie_id = m.id
    GROUP BY 
        g.genre
    ORDER BY 
        movie_count DESC
    LIMIT 3
),

RankedMovies AS (
    SELECT 
        g.genre,
        m.year,
        m.title AS movie_name,
        m.worlwide_gross_income,
        ROW_NUMBER() OVER (PARTITION BY g.genre, m.year ORDER BY m.worlwide_gross_income DESC) AS movie_rank
    from 
        movie m
    join 
        genre g ON m.id = g.movie_id
    where 
        g.genre IN (SELECT genre FROM TopGenres)
)

SELECT 
    genre, 
    year, 
    movie_name, 
    worlwide_gross_income, 
    movie_rank
from 
    RankedMovies
where 
    movie_rank <= 5
ORDER BY 
    genre, year, movie_rank;









-- Finally, let’s find out the names of the top two production houses that have produced the highest number of hits among multilingual movies.
-- Q27.  Which are the top two production houses that have produced the highest number of hits (median rating >= 8) among multilingual movies?
/* Output format:
+-------------------+-------------------+---------------------+
|production_company |movie_count		|		prod_comp_rank|
+-------------------+-------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:

WITH MultilingualHits AS (
    SELECT 
        m.id AS movie_id,
        m.production_company,
        r.median_rating
    from movie m
    join ratings r ON m.id = r.movie_id
    where POSITION(',' IN m.languages) > 0 -- Checks if there is at least one comma
        AND r.median_rating >= 8
        AND m.production_company IS NOT NULL -- Exclude NULL production companies
)

SELECT 
    production_company, 
    COUNT(movie_id) AS movie_count,
    ROW_NUMBER() OVER (ORDER BY COUNT(movie_id) DESC) AS prod_comp_rank
from MultilingualHits
where production_company IS NOT NULL -- Exclude NULL production companies
GROUP BY production_company
ORDER BY movie_count DESC
LIMIT 2;







-- Multilingual is the important piece in the above question. It was created using POSITION(',' IN languages)>0 logic
-- If there is a comma, that means the movie is of more than one language


-- Q28. Who are the top 3 actresses based on number of Super Hit movies (average rating >8) in drama genre?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |actress_avg_rating	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Laura Dern	|			1016	|	       1		  |	   9.60			     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

WITH SuperHitDramaMovies AS (
    SELECT 
        m.id AS movie_id,
        m.production_company,
        r.avg_rating,
        r.total_votes,
        n.name AS actress_name
    from movie m
    join ratings r ON m.id = r.movie_id
    join role_mapping rm ON m.id = rm.movie_id
    join names n ON rm.name_id = n.id
    where r.avg_rating > 8
        AND m.id IN (
            select movie_id
            from genre
            where genre = 'Drama'
        )
)

SELECT 
    actress_name,
    SUM(total_votes) AS total_votes,
    COUNT(movie_id) AS movie_count,
    AVG(avg_rating) AS actress_avg_rating,
    ROW_NUMBER() OVER (ORDER BY COUNT(movie_id) DESC) AS actress_rank
from SuperHitDramaMovies
GROUP BY actress_name
ORDER BY movie_count DESC
LIMIT 3;







/* Q29. Get the following details for top 9 directors (based on number of movies)
Director id
Name
Number of movies
Average inter movie duration in days
Average movie ratings
Total votes
Min rating
Max rating
total movie durations

Format:
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
| director_id	|	director_name	|	number_of_movies  |	avg_inter_movie_days |	avg_rating	| total_votes  | min_rating	| max_rating | total_duration |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
|nm1777967		|	A.L. Vijay		|			5		  |	       177			 |	   5.65	    |	1754	   |	3.7		|	6.9		 |		613		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+

--------------------------------------------------------------------------------------------*/
-- Type you code below:

WITH MovieData AS (
    SELECT 
        dm.name_id AS director_id,
        n.name AS director_name,
        m.date_published,
        m.duration,
        r.avg_rating,      
        r.total_votes      
    FROM 
       director_mapping dm
    JOIN 
	   movie m ON dm.movie_id = m.id
    JOIN 
       ratings r ON m.id = r.movie_id
    JOIN 
       names n ON dm.name_id = n.id
),
DirectorStats AS (
    SELECT
        director_id,
        director_name,
        COUNT(*) AS number_of_movies,
        DATEDIFF(MAX(date_published), MIN(date_published)) AS total_days,  -- Using DATEDIFF for days
        AVG(avg_rating) AS avg_rating,             
        SUM(total_votes) AS total_votes,
        MIN(avg_rating) AS min_rating,
        MAX(avg_rating) AS max_rating,
        SUM(duration) AS total_duration
    FROM 
        MovieData
    GROUP BY 
        director_id, director_name
)

SELECT 
    director_id,
    director_name,
    number_of_movies,
    CASE 
        WHEN number_of_movies > 1 THEN total_days / (number_of_movies - 1) 
        ELSE NULL 
    END AS avg_inter_movie_days,  -- Calculate average days between movies
    avg_rating,
    total_votes,
    min_rating,
    max_rating,
    total_duration
FROM 
    DirectorStats
ORDER BY 
    number_of_movies DESC
LIMIT 9;









