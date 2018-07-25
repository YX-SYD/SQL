1. /* 1962 movies: List the films where the yr is 1962 [Show id, title] */
  SELECT id, title
  FROM movie
  WHERE yr=1962
  
2. /* When was Citizen Kane released? */
  SELECT yr
  FROM movie
  WHERE title='Citizen Kane'
  
3. /* Star Trek movies */
  SELECT id, title, yr
  FROM movie
  WHERE title like '%Star Trek%'
  ORDER BY yr
  
4. /* id for actor Glenn Close */
  SELECT id
  FROM actor
  WHERE name='Glenn Close'
  
5. /* id for Casablanca */
  SELECT id
  FROM movie
  WHERE title= 'Casablanca'
  
6. /* Cast list for Casablanca */
  SELECT name 
  FROM actor 
  INNER JOIN casting on actor.id = casting.actorid
  INNER JOIN movie on casting.movieid = movie.id
  WHERE movie.id = 11768
  
7. /* Alien cast list */
  SELECT name 
  FROM actor 
  INNER JOIN casting on actor.id = casting.actorid
  INNER JOIN movie on casting.movieid = movie.id
  WHERE movie.title =  'Alien'
  
8. /* Harrison Ford movies */
  SELECT title
  FROM movie
  INNER JOIN casting ON movie.id = casting.movieid
  INNER JOIN actor ON casting.actorid = actor.id
  WHERE actor.name =  'Harrison Ford'
  
9. /* Harrison Ford as a supporting actor */
  SELECT title
  FROM movie
  INNER JOIN casting ON movie.id = casting.movieid
  INNER JOIN actor ON casting.actorid = actor.id
  WHERE actor.name =  'Harrison Ford' and NOT (casting.ord = 1)
  
10. /* Lead actors in 1962 movies */
  SELECT movie.title, actor.name
  FROM movie
  INNER JOIN casting ON movie.id = casting.movieid
  INNER JOIN actor ON casting.actorid = actor.id
  WHERE movie.yr = 1962 and casting.ord=1
  
11. /* Busy years for John Travolta */
  SELECT yr, COUNT(title) as n
  FROM movie
  INNER JOIN casting ON movie.id = casting.movieid
  INNER JOIN actor on casting.actorid = actor.id
  WHERE actor.name= 'John Travolta'
  GROUP BY yr
  HAVING  n = ( SELECT MAX(c)
              FROM (
              SELECT COUNT(*) AS c
              FROM movie
              INNER JOIN casting ON movie.id = casting.movieid
              INNER JOIN actor on casting.actorid = actor.id
              WHERE actor.name = 'John Travolta'
              GROUP BY movie.yr
              ) As t
            )
12. /* Lead actor in Julie Andrews movies */
  SELECT title, actor.name
  FROM movie
  INNER JOIN casting ON casting.movieid=movie.id
  INNER JOIN actor ON casting.actorid = actor.id
  WHERE movie.id IN 
  (
  SELECT movieid
  FROM casting
  WHERE actorid in (
    SELECT id 
    FROM actor
    WHERE name='Julie Andrews' 
   )
  ) and casting.ord=1

13. /* Actors with 30 leading roles */
  SELECT name
  FROM actor
  WHERE actor.id in (
  SELECT actorid
  FROM (
    SELECT actorid, COUNT(movieid) as c
    FROM casting
    WHERE ord=1
    GROUP BY actorid
    HAVING c>=30
    ) AS t
  )
  ORDER BY name

14. /* List the films released in the year 1978 ordered by the number of actors in the cast, then by title. */
  SELECT movie.title, COUNT(actor.id)
  FROM movie
  JOIN casting ON movie.id = casting.movieid
  JOIN actor ON casting.actorid = actor.id
  WHERE movie.yr = 1978
  GROUP BY movie.title
  ORDER BY COUNT(actor.id) DESC, movie.title
  
15. /* List all the people who have worked with 'Art Garfunkel'. */
   SELECT name
  FROM actor
  JOIN casting ON casting.actorid = actor.id
  JOIN movie ON movie.id = casting.movieid
  WHERE movie.id IN
  (
  SELECT movie.id
  FROM movie
  JOIN casting ON movie.id = casting.movieid
  JOIN actor ON casting.actorid = actor.id
  WHERE actor.name = 'Art Garfunkel'
  ) and NOT (actor.name = 'Art Garfunkel')

