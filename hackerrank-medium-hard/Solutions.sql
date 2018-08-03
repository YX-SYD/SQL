/*
The PADs: https://www.hackerrank.com/challenges/the-pads/problem
Generate the following two result sets:

Query an alphabetically ordered list of all names in OCCUPATIONS, 
immediately followed by the first letter of each profession as a parenthetical (i.e.: enclosed in parentheses). 
For example: AnActorName(A), ADoctorName(D), AProfessorName(P), and ASingerName(S).
Query the number of ocurrences of each occupation in OCCUPATIONS. 
Sort the occurrences in ascending order, and output them in the following format: 

There are a total of [occupation_count] [occupation]s.
where [occupation_count] is the number of occurrences of an occupation in OCCUPATIONS and [occupation] is the lowercase occupation name. 
If more than one Occupation has the same [occupation_count], they should be ordered alphabetically.

*/

SELECT CONCAT(name,'(', SUBSTRING(Occupation,1,1),')')
FROM OCCUPATIONS
ORDER BY name;
SELECT CONCAT('There are a total of ', COUNT(name), ' ', LOWER(Occupation),'s.')
FROM OCCUPATIONS
GROUP BY Occupation
ORDER BY  COUNT(name), Occupation


/*
Occupations: https://www.hackerrank.com/challenges/occupations/problem
Pivot the Occupation column in OCCUPATIONS so that each Name is sorted alphabetically and displayed underneath its corresponding Occupation. 
The output column headers should be Doctor, Professor, Singer, and Actor, respectively.
Note: Print NULL when there are no more names corresponding to an occupation.
*/

SET @r1=0,@r2=0,@r3=0,@r4=0;
SELECT min(Doctor),min(Professor),min(Singer),min(Actor)
FROM (
    SELECT
       CASE 
           WHEN Occupation='Doctor' THEN (@r1:=@r1+1)
           WHEN Occupation='Professor' THEN (@r2:=@r2+1)
           WHEN Occupation='Singer' THEN (@r3:=@r3+1)
           WHEN Occupation='Actor' THEN (@r4:=@r4+1)
       END AS rownumber,
       if(Occupation='Doctor', Name, NULL) AS Doctor,
       if(Occupation='Professor', Name, NULL) AS Professor,
       if(Occupation='Singer', Name, NULL) AS Singer,
       if(Occupation='Actor', Name, NULL) AS Actor
    FROM OCCUPATIONS
    ORDER BY Name
) AS temp
GROUP BY rownumber

/*
Binary Tree Nodes: https://www.hackerrank.com/challenges/binary-search-tree-1/problem
You are given a table, BST, containing two columns: N and P, where N represents the value of a node in Binary Tree, 
and P is the parent of N.
Write a query to find the node type of Binary Tree ordered by the value of the node. Output one of the following for each node:

Root: If node is root node.
Leaf: If node is leaf node.
Inner: If node is neither root nor leaf node.
*/

SELECT 
     n,
     CASE
         WHEN p IS NOT NULL THEN
            CASE
                WHEN n IN (SELECT p FROM BST ) THEN 'Inner'
                ELSE 'Leaf'
            END
         ELSE 'Root'
     END
FROM BST
ORDER BY n

/*
New Companies: https://www.hackerrank.com/challenges/the-company/problem
Given the table schemas, write a query to print the company_code, founder name, total number of lead managers, 
total number of senior managers, total number of managers, and total number of employees. 
Order your output by ascending company_code.
*/
SELECT 
    c.company_code, 
    c.founder,
    COUNT(DISTINCT l.lead_manager_code),
    COUNT(DISTINCT s.senior_manager_code),
    COUNT(DISTINCT m.manager_code),
    COUNT(DISTINCT e.employee_code)
FROM Company c
LEFT JOIN Lead_Manager l ON c.company_code = l.company_code
LEFT JOIN Senior_Manager s on l.lead_manager_code = s.lead_manager_code
LEFT JOIN Manager m on s.senior_manager_code = m.senior_manager_code
LEFT JOIN employee e on m.manager_code = e.manager_code
GROUP BY c.company_code, c.founder

/*
Weather Observation Station 20:
A median is defined as a number separating the higher half of a data set from the lower half. 
Query the median of the Northern Latitudes (LAT_N) from STATION and round your answer to  decimal places.
*/
SET @rowindex:=-1;
SELECT ROUND(AVG(LAT_N),4)
FROM
    (SELECT 
        @rowindex:=@rowindex+1 AS rowindex,
        LAT_N
     FROM STATION
     ORDER BY LAT_N
    ) as sta
WHERE sta.rowindex IN (FLOOR(@rowindex/2),CEIL(@rowindex/2))

/*
Students table: ID, Name, Marks
Grades: Grade, Min_Mark, Max_Mark

Ketty gives Eve a task to generate a report containing three columns: Name, Grade and Mark. 
Ketty doesn't want the NAMES of those students who received a grade lower than 8. 
The report must be in descending order by grade -- i.e. higher grades are entered first. 
If there is more than one student with the same grade (8-10) assigned to them, order those particular students by their name alphabetically. 
Finally, if the grade is lower than 8, use "NULL" as their name and list them by their grades in descending order. 
If there is more than one student with the same grade (1-7) assigned to them, order those particular students by their marks in ascending order.
*/
SELECT 
    CASE
        WHEN Grade>=8 THEN Name
        ELSE Null
    END,
    Grade,
    Marks
FROM
(
    SELECT
        s.Name,
        s.Marks,
        g.Grade
    FROM Students s
    LEFT JOIN Grades g ON s.Marks>= g.Min_Mark and s.Marks<=g.Max_Mark
) AS sg
ORDER BY Grade DESC, Name,Marks DESCSELECT 




