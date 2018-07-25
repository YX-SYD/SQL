1. /* How many stops are in the database. */
  SELECT COUNT(*)
  FROM stops
  
2. /* Find the id value for the stop 'Craiglockhart' */
  SELECT id
  FROM stops
  WHERE name='Craiglockhart'
  
3. /* Give the id and the name for the stops on the '4' 'LRT' service. */
  SELECT id,name
  FROM  stops
  JOIN route ON stops.id = route.stop
  WHERE route.num=4 and route.company='LRT'
  
4. /* The query shown gives the number of routes that visit either London Road (149) or Craiglockhart (53). 
   Run the query and notice the two services that link these stops have a count of 2. 
   Add a HAVING clause to restrict the output to these two routes. */
  SELECT company, num, COUNT(*) AS c
  FROM route WHERE stop=149 OR stop=53
  GROUP BY company, num
  HAVING c=2
   
5. /* Execute the self join shown and observe that b.stop gives all the places you can get to from Craiglockhart, 
      without changing routes. Change the query so that it shows the services from Craiglockhart to London Road. */
  SELECT a.company, a.num, a.stop, b.stop
  FROM route a JOIN route b ON (a.company=b.company AND a.num=b.num)
  WHERE a.stop=53 and b.stop = 149
  
6. /* Joining two copies of the stops table we can refer to stops by name rather than by number. 
      Change the query so that the services between 'Craiglockhart' and 'London Road' are shown. 
      If you are tired of these places try 'Fairmilehead' against 'Tollcross' */
  SELECT a.company, a.num, stopa.name, stopb.name
  FROM route a 
    JOIN route b ON (a.company=b.company AND a.num=b.num)
    JOIN stops stopa ON (a.stop=stopa.id)
    JOIN stops stopb ON (b.stop=stopb.id)
  WHERE stopa.name='Craiglockhart' and stopb.name='London Road'

7. /* Give a list of all the services which connect stops 115 and 137 ('Haymarket' and 'Leith') */
  SELECT DISTINCT a.company, a.num
  FROM route a 
    JOIN route b ON (a.company=b.company AND a.num=b.num)
    JOIN stops stopa ON (a.stop=stopa.id)
    JOIN stops stopb ON (b.stop=stopb.id)
  WHERE stopa.name='Haymarket' and stopb.name= 'Leith'
  
8. /* Give a list of the services which connect the stops 'Craiglockhart' and 'Tollcross' */
  SELECT DISTINCT a.company, a.num
  FROM route a 
    JOIN route b ON (a.company=b.company AND a.num=b.num)
    JOIN stops stopa ON (a.stop=stopa.id)
    JOIN stops stopb ON (b.stop=stopb.id)
  WHERE stopa.name= 'Craiglockhart'  and stopb.name= 'Tollcross'
  
9. /* Give a distinct list of the stops which may be reached from 'Craiglockhart' by taking one bus, 
      including 'Craiglockhart' itself, offered by the LRT company. Include the company and bus no. of the relevant services.  */
  SELECT DISTINCT stopb.name,a.company, a.num
  FROM route a 
    JOIN route b ON (a.company=b.company AND a.num=b.num)
    JOIN stops stopa ON (a.stop=stopa.id)
    JOIN stops stopb ON (b.stop=stopb.id)
  WHERE stopa.name= 'Craiglockhart' and a.company='LRT'
  
10. /* Find the routes involving two buses that can go from Craiglockhart to Sighthill.
       Show the bus no. and company for the first bus, the name of the stop for the transfer,
       and the bus no. and company for the second bus. */
  WITH 
  from_stop AS (
    SELECT DISTINCT a.company, a.num,stopb.name AS inter_stop
    FROM route a 
      JOIN route b ON (a.company=b.company AND a.num=b.num)
      JOIN stops stopa ON (a.stop=stopa.id)
      JOIN stops stopb ON (b.stop=stopb.id)
    WHERE stopa.name='Craiglockhart'
  ),

  to_stop As (
  SELECT DISTINCT c.company, c.num, stopc.name AS inter_stop
  FROM route c 
    JOIN route d ON (c.company=d.company AND c.num=d.num)
    JOIN stops stopc ON (c.stop=stopc.id)
    JOIN stops stopd ON (d.stop=stopd.id)
  WHERE stopd.name='Sighthill'
  )

  SELECT f.num, f.company,f.inter_stop, t.num, t.company
  FROM from_stop f
  JOIN to_stop t ON f.inter_stop = t.inter_stop
  ORDER BY LENGTH(f.num),f.num, f.company,f.inter_stop,length(t.num),t.num,t.company
