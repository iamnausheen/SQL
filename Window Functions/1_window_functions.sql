# RANKING 
# Top 5 customers in a state
# Top 5 batsman in an IPL team 
# Top 3 students in a branch

# Find top 5 batsman from every team

# Find runs scored by each batsman in each of his teams
SELECT batting_team, batter, SUM(batsman_run)
FROM ipl
GROUP BY batting_team, batter;

# Rank batsman within teams based on runs
SELECT batting_team, batter, 
SUM(batsman_run),
DENSE_RANK() OVER(PARTITION BY batting_team ORDER BY SUM(batsman_run) DESC)
FROM ipl
GROUP BY batting_team, batter;

# Find only top 5 
SELECT * FROM (SELECT batting_team, batter, 
SUM(batsman_run),
DENSE_RANK() OVER(PARTITION BY batting_team ORDER BY SUM(batsman_run) DESC) AS 'batsman_rank_in_team'
FROM ipl
GROUP BY batting_team, batter) t
WHERE t.batsman_rank_in_team < 6
ORDER BY batting_team, batsman_rank_in_team;




SELECT * FROM (SELECT batting_team, batter, SUM(batsman_run) AS 'total_runs',
DENSE_RANK() OVER(PARTITION BY batting_team ORDER BY SUM(batsman_run) DESC) AS 'batsman_team_rank'
FROM ipl
GROUP BY batting_team, batter) t
WHERE t.batsman_team_rank < 6
ORDER BY t.batting_team, team_rank;

# CUMULATIVE SUM 
# Calculate sum of a set of values upto a given point in time 
# and includes all previous values in the calculation

# Find runs scored by Virat Kohli in his 50th match, 100th match, 200th match

# Find kohli's matches
SELECT * 
FROM ipl
WHERE batter = 'Virat Kohli';

# Find runs made by Virat Kohli in each of his matches
SELECT match_id, SUM(batsman_run) 
FROM ipl
WHERE batter = 'Virat Kohli'
GROUP BY match_id
ORDER BY match_id;

# Find cumulative sum
SELECT match_id, 
SUM(batsman_run) AS 'runs',
SUM(SUM(batsman_run)) OVER(ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS 'career_runs',
CONCAT('Match-', ROW_NUMBER() OVER())
FROM ipl
WHERE batter = 'Virat Kohli'
GROUP BY match_id
ORDER BY match_id;

# Display 50th, 100th and 200th
SELECT * FROM (SELECT match_id, 
CONCAT('Match-', CAST(ROW_NUMBER() OVER(ORDER BY match_id) AS char)) AS 'match',
SUM(batsman_run) AS 'runs',
SUM(SUM(batsman_run)) OVER(ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS 'career_runs'
FROM ipl
WHERE batter = 'Virat Kohli'
GROUP BY match_id
ORDER BY match_id
) t 
WHERE t.match = 'Match-50' OR t.match = 'Match-100' OR t.match = 'Match-200';


# Find cumulative avg. runs scored by Virat Kohli in all his matches

# Find total runs scored by virat kohli in each of his matches
SELECT match_id, SUM(batsman_run)
FROM ipl
WHERE batter = 'Virat Kohli'
GROUP BY match_id;

# Find cumulative average
SELECT match_id, SUM(batsman_score),
AVG(SUM(batsman_score)) OVER(ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS 'career_avg_runs'
FROM ipl
WHERE batter = 'Virat Kohli'
GROUP BY match_id, 
ORDER BY match_id;

# another way to write window functions
SELECT match_id, SUM(batsman_score),
AVG(SUM(batsman_score)) OVER w AS 'career_avg_runs',
SUM(SUM(batsman_run)) OVER w AS 'career_runs'
FROM ipl
WHERE batter = 'Virat Kohli'
GROUP BY match_id
WINDOW w AS (ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW);

# RUNNING AVERAGE
# ALso known as moving avg - calculates avg. over a window
# updates as new data points added older points dropped
# reflects current trends in data

# Find running average of 10 matches of Virat Kohli
SELECT match_id, SUM(batsman_score),
AVG(SUM(batsman_score)) OVER w AS 'career_avg_runs',
AVG(SUM(batsman_score) OVER(ROWS BETWEEN 9 PRECEDING AND CURRENT ROW)) AS 'running_avg',
SUM(SUM(batsman_run)) OVER w AS 'career_runs'
FROM ipl
WHERE batter = 'Virat Kohli'
GROUP BY match_id
WINDOW w AS (ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW);

# Percent of Total
# Refers to percentage or proportion of a specific value in relation to the total values
# Can also be calulated without window functions

# Find most important item for restraunt 1

# WHich item made most money from restaurant 1
USE zomato;

SELECT * FROM orders;

SELECT * FROM orders WHERE r_id = 1;

SELECT * FROM order_details;

SELECT * FROM food;

SELECT * FROM order_details t1 
JOIN orders t2 ON
t1.order_id = t2.order_id
WHERE t2.r_id = 1;

# without window function
SELECT f_id, SUM(amount) FROM order_details t1 
JOIN orders t2 ON
t1.order_id = t2.order_id
WHERE t2.r_id = 1
GROUP BY f_id
ORDER BY SUM(amount) DESC;

# using window function

# FInd percentage of money made from each item
 
SELECT f_id, 
(total/SUM(total) OVER())*100
FROM (SELECT f_id, SUM(amount) AS 'total'
FROM orders t1 JOIN
order_details t2 ON
t1.order_id = t2.order_id
WHERE r_id = 1
GROUP BY f_id) t;

# Also print name of each food item

SELECT * FROM food;

SELECT t1.f_id, f_name, sales_percentage FROM (SELECT f_id, 
(total/SUM(total) OVER())*100 AS 'sales_percentage'
FROM (SELECT f_id, SUM(amount) AS 'total'
FROM orders t1 JOIN
order_details t2 ON
t1.order_id = t2.order_id
WHERE r_id = 1
GROUP BY f_id) t) t1 JOIN food t2 ON
t1.f_id = t2.f_id;  
