# Type of analytical functions

CREATE DATABASE IF NOT EXISTS students;
USE students;

CREATE TABLE marks(
	student_id INTEGER PRIMARY KEY AUTO_INCREMENT,
	name VARCHAR(255),
    branch VARCHAR(255),
    marks INTEGER
);

INSERT INTO marks(name, branch, marks)
VALUES 
('Nitish','EEE',82),
('Rishabh','EEE',91),
('Anukant','EEE',69),
('Rupesh','EEE',55),
('Shubham','CSE',78),
('Ved','CSE',43),
('Deepak','CSE',98),
('Arpan','CSE',95),
('Vinay','ECE',95),
('Ankit','ECE',88),
('Anand','ECE',81),
('Rohit','ECE',95),
('Prashant','MECH',75),
('Amit','MECH',69),
('Sunny','MECH',39),
('Gautam','MECH',51);

SELECT * FROM marks;

# Avg of entire data
# One data point printed
SELECT AVG(marks) FROM marks;

# Avg of entire data printed alongside each row
SELECT *, AVG(marks) OVER() FROM marks;

# Group By Branch - find avg. marks of each branch
# Displays data of each group
SELECT branch, AVG(marks) FROM marks
GROUP BY branch;

# Window over branch 
# All rows printed with avg of it's particular branch
SELECT *, AVG(marks) OVER(PARTITION BY branch) FROM marks;

SELECT *, MIN(marks) OVER(), 
MAX(marks) OVER() FROM marks;

SELECT *, 
AVG(marks) OVER(),
MIN(marks) OVER(),
MAX(marks) OVER(),
MIN(marks) OVER(PARTITION BY branch), 
MAX(marks) OVER(PARTITION BY branch) 
FROM marks;

# Aggregate Function with OVER()
# Find all students who have marks higher than the avg marks 
# of their branch

SELECT * FROM (SELECT *, 
AVG(marks) OVER(PARTITION BY branch) AS 'branch_avg'
FROM marks) t
WHERE t.marks > t.branch_avg;

# Can't apply where directly as branch_avg was treated as unrecongnized column
# SELECT * FROM (SELECT *, 
# AVG(marks) OVER(PARTITION BY branch) AS 'branch_avg'
# FROM marks
# WHERE marks > branch_avg;


# RANK/DENSE_RANK/ROW_NUMBER
# Assigns rank in partition eg: rank students in each branch according to marks

SELECT *, 
RANK() OVER(ORDER BY marks DESC)
FROM marks;

SELECT *, 
RANK() OVER(PARTITION BY branch ORDER BY marks DESC)
FROM marks;
# If same marks obtained then both get same rank and middle ranks are skipped
# eg: 95, 95, 90 get ranked as 1, 1, 3

# DENSE RANK
# 95, 95, 90 -> 1, 1, 2

SELECT *, 
RANK() OVER(PARTITION BY branch ORDER BY marks DESC),
DENSE_RANK() OVER(PARTITION BY branch ORDER BY marks DESC)
FROM marks;

# ROW NUMBER
# Assign row number, custom or default 
# Helps in deleting duplicate data

SELECT *, ROW_NUMBER() OVER()
FROM marks;

SELECT *, ROW_NUMBER() OVER(PARTITION BY branch)
FROM marks;

SELECT *,
CONCAT(branch, '-', ROW_NUMBER() OVER(PARTITION BY branch))
FROM marks;

# eg: generate work email - first_name.last_name@gmail.com
# If 2 monica geller's then monica.geller1@gmail.com
# monica.geller2@gmail.com
# partition by name

# Zomato DATASET
CREATE DATABASE zomato;
USE zomato;

# Find top 2 most paying customers of each month
SELECT *, MONTH(date), MONTHNAME(date) FROM orders;

# How much money is spent by each customer in each month
SELECT user_id, MONTH(date) AS 'month', SUM(amount) AS 'monthly_spends'
FROM orders
GROUP BY user_id, month;

# Top customers of each month - Can fetch only top customer with max, not top 2 for each month
WITH monthly_spends AS (
SELECT user_id, MONTH(date) AS 'month', SUM(amount) AS 'monthly_spends'
FROM orders
GROUP BY user_id, month
)
SELECT MAX(monthly_spends) FROM monthly_spends
GROUP BY month;

# Using window function

# Find how much each customer spent in each month
# Rank customers according to that expenditure

WITH monthly_spends AS (
SELECT user_id, MONTH(date) AS 'month', SUM(amount) AS 'monthly_spends'
FROM orders
GROUP BY user_id, month
)
SELECT * FROM (SELECT *,
RANK() OVER(PARTITION BY month ORDER BY monthly_spends DESC) AS 'month_rank'
FROM monthly_spends
ORDER BY month) t
WHERE t.month_rank < 3
ORDER BY month;

# FIRST_VALUE

USE students;
SELECT * FROM marks;

# Highest scorer
SELECT *,
FIRST_VALUE(marks) OVER(ORDER BY marks DESC),
FIRST_VALUE(name) OVER(ORDER BY marks DESC)
FROM marks;

# LAST_VALUE

SELECT *,
LAST_VALUE(marks) OVER(ORDER BY marks DESC)
FROM marks;
# lowest value not printed -> same marks printed

# FRAMES
# Frame in a window function is a subgroup within the groups formed
# Determines the scope of window function calculation - which row values will be picked up for calculation
# Defined using clauses ROWS and BETWEEN 

# From first row to current row - ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW - Default Frame
#  ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING
# ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING - Use for first value and last value type functions
# ROWS BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING
# ROWS BETWEEN 3 PRECEDING AND 2 FOLLOWING

# WHy incorrect results - Data sorted in descending order
# From first row to current low smallest value is current row
# Rows ahead not considered 

SELECT *,
LAST_VALUE(marks) OVER(ORDER BY marks DESC
				  ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING)
FROM marks;
                  
# NTH_VALUE
SELECT *,
NTH_VALUE(name, 2) OVER(PARTITION BY branch
						ORDER BY marks DESC
                        ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING)
FROM marks;

SELECT *,
NTH_VALUE(name, 5) OVER(PARTITION BY branch
						ORDER BY marks DESC
                        ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING)
FROM marks;
# less than 5 students exist in each branch

# 2nd last student
SELECT *,
NTH_VALUE(name, 5) OVER(PARTITION BY branch
						ORDER BY marks 
                        ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING)
FROM marks;

# Find the branch toppers - display topper name against each branch

# Group By marks -> table subquery to display name
SELECT branch, MAX(marks)
FROM marks
GROUP BY branch;

SELECT *
FROM marks WHERE (branch, marks) IN (SELECT branch, MAX(marks)
FROM marks
GROUP BY branch);

# Rank each student according to marks in respective branches and display first rank records
SELECT * FROM (SELECT name, branch, 
RANK() OVER(PARTITION BY branch ORDER BY marks DESC ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS 'branch_rank'
FROM marks) t
WHERE t.branch_rank = 1;

# Using first_value
SELECT branch, name FROM (SELECT *, 
FIRST_VALUE(name) OVER(PARTITION BY branch ORDER BY marks DESC ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS 'branch_topper',
FIRST_VALUE(marks) OVER(PARTITION BY branch ORDER BY marks DESC ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS 'toppper_marks'
FROM marks) t
WHERE t.name = branch_topper;

# Calling window more than once
# Another way of writing window functions

SELECT branch, name FROM (SELECT *, 
FIRST_VALUE(name) OVER w AS 'branch_topper',
FIRST_VALUE(marks) OVER w AS 'toppper_marks'
FROM marks) t
WHERE t.name = branch_topper
WINDOW w AS (PARTITION BY branch ORDER BY marks DESC ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING);

# Find the last guy of each branch - same as above - order in ascending order
# or last_value with descending order

# Find the second last guy of each branch, 5th topper of each branch

SELECT DISTINCT branch, 
NTH_VALUE(name, 2) OVER(PARTITION BY branch ORDER BY marks ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS 'second_last',
NTH_VALUE(name, 5) OVER(PARTITION BY branch ORDER BY marks DESC ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS 'fifth_topper'
FROM marks;

# LEAD and LAG

SELECT *,
LAG(marks) OVER(ORDER BY student_id)
FROM marks;
# Each value shifted down one row from original columnn

SELECT *,
LEAD(marks) OVER(ORDER BY student_id)
FROM marks;
# Each value shifted above one row from original column

SELECT *,
LAG(marks) OVER(PARTITION BY branch ORDER BY student_id)
FROM marks;
# Each value shifted down one row from original columnn in each branch

SELECT *,
LEAD(marks) OVER(PARTITION BY branch ORDER BY student_id)
FROM marks;
# Each value shifted above one row from original column in each branch

# Calculate Month on Month (MoM) revenue growth from zomato
USE zomato;
SELECT * FROM orders;

# revenue in each month

SELECT MONTH(date) AS 'month', MONTHNAME(date) AS 'month_name',
SUM(amount) AS 'monthly_revenue'
FROM orders
GROUP BY month, month_name;

SELECT *, (((monthly_revenue - LAG(monthly_revenue) OVER(ORDER BY month))/LAG(monthly_revenue) OVER(ORDER BY month))*100) AS 'monthly_growth'
FROM (SELECT MONTH(date) AS 'month', MONTHNAME(date) AS 'month_name',
SUM(amount) AS 'monthly_revenue'
FROM orders
GROUP BY month, month_name) t;
