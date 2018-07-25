1. /* Bigger than Russia  */
  SELECT name FROM world
  WHERE population >
     (SELECT population 
      FROM world
      WHERE name='Russia')
      
2. /* Richer than UK */
  SELECT name
  FROM world
  WHERE continent='Europe' and 
     (gdp/population) > 
     (SELECT (gdp/population) 
      FROM world 
      WHERE name='United Kingdom')
      
3. /* Neighbours of Argentina and Australia */
  SELECT name,continent
  FROM world
  WHERE continent IN (SELECT continent FROM world WHERE name IN ('Argentina','Australia'))
  ORDER BY name
  
4. /* Between Canada and Poland */
  SELECT name, population
  FROM world
  WHERE population > (SELECT population FROM world WHERE name='Canada') 
       and population<(SELECT population FROM world WHERE name='Poland')
       
5. /* Percentages of Germany */
  SELECT name, CONCAT(ROUND(100*population/
      (SELECT population FROM world WHERE name='Germany')),'%')
  FROM world
  WHERE continent='Europe'
  
6. /* Bigger than every country in Europe */
  SELECT name
  FROM world
  WHERE gdp > ALL(SELECT gdp FROM world WHERE continent='Europe' and gdp>0)
  
7. /* Largest in each continent */
  SELECT continent, name, area 
  FROM world x
  WHERE area >= ALL(SELECT area FROM world y WHERE y.continent=x.continent AND area>0)
  
8. /* First country of each continent (alphabetically) */
  SELECT continent,name
  FROM world x
  WHERE name=(SELECT name FROM world y WHERE y.continent=x.continent ORDER BY name LIMIT 1)
  
9. /* Find the continents where all countries have a population <= 25000000. */
   /* Then find the names of the countries associated with these continents. */
  SELECT name,continent,population
  FROM world x
  WHERE 25000000>=ALL(SELECT population FROM world y WHERE y.continent=x.continent)
   
10. /* Some countries have populations more than three times that of any of their neighbours (in the same continent). */
  SELECT name, continent
  FROM world x
  WHERE population >= ALL(SELECT 3*population FROM world y WHERE y.continent=x.continent and NOT(y.name=x.name))
