# Percent Change
# Difference between 2 values as a percentage of the original value
# Represents how much a value has increased or decreased over a given period of time to commpare 2 different values

SELECT * FROM youtube_views; # Schema - index, date views

# Calculate percent change per month
# Views each day are given 

SELECT YEAR(date) AS 'year', MONTH(date) AS 'month', SUM(views) 
FROM youtube_views
GROUP BY month, year
ORDER BY year, month;

# Using lag
SELECT YEAR(date) AS 'year', QUARTER(date) AS 'quarter', 
SUM(views) AS 'monthly_views',
LAG(SUM(views) OVER(ORDER BY YEAR(date), QUARTER(date)))  
FROM youtube_views
GROUP BY year, quarter
ORDER BY year, quarter;

# Last 1 week percent_change
SELECT *,
(Views-(LAG(Views, 7) OVER(ORDER BY date)))
/((LAG(Views, 7) OVER(ORDER BY date)))*100 AS 'weekly_percent_change'
FROM youtube_views;

# Percentiles And Quantiles 
# Measure of the distribution of a dataset that divides the data
# into any number of equally sized intervals.
# eg: Dataset can be divided into deciles(10 equal parts)
# quartiles(4), percentiles(100)

# Each quantile repesents a value below which certain percentage of data
# falls. For eg: 25th percentile also known as the first quartile or Q1
# represents the value below which 25% of the data falls
# 50th percentile (also known as the median) represents the value
# below which 50% of the data falls and so on.

# Find the median marks of all the students

SELECT * FROM marks;

# This function is not available in MySQL, available in SQL server, Oracle, PostgreSQL
SELECT *, 
PERCENTILE_DISC(0.5) WITHIN GROUP(ORDER BY marks) 
OVER() AS 'median_marks'
FROM marks;

# Find branch-wise median of student marks
SELECT *, 
PERCENTILE_DISC(0.5) WITHIN GROUP(PARTITION BY branch ORDER BY marks) 
OVER() AS 'median_marks'
FROM marks;

# Percentile Cont - Calculates continuous percentile value
# Calculates the continuous percentile value which returns the interpolated value
# between adjacent data points. In other words, it estimates the percentile 
# value by assuming that the values between data points are distributed uniformly
# This function returns a value that may not be present in the original dtaset

# PERCENTILE_DISC - Calculates discrete percentile values which returns the value 
# of the nearest data point. Returns a value that is present in the original dataset

SELECT *, 
PERCENTILE_DISC(0.5) WITHIN GROUP(PARTITION BY branch ORDER BY marks) 
PERCENTILE_CONT(0.5) WITHIN GROUP(PARTITION BY branch ORDER BY marks) 
OVER() AS 'median_marks'
FROM marks;

# Removing Outliers 
# Outliers - data points that lieas an abnormal distance or significantly differs from other values in a randome dataset
# IQR = Q3(75th percentile) - Q1(25th percentile)
# Minm = Q1 - 1.5*IQR
# Maxm = Q3 + 1.5*IQR
# Values lying outside this range of [minm, maxm] are considered outliers

# Viewing outliers
SELECT * FROM (SELECT *,
PERCENTILE_CONT(0.25) WITHIN GROUP(ORDER BY MARKS) OVER() AS 'Q1',
PERCENTILE_CONT(0.75) WITHIN GROUP(ORDER BY MARKS) OVER() AS 'Q3'
FROM marks) t
WHERE t.marks <= t.Q1 - (1.5*(t.Q3 - t.Q1)) AND 
t.marks >= t.Q3 + (1.5*(t.Q3 - t.Q1))  


# Removing outliers
DELETE FROM (SELECT *,
PERCENTILE_CONT(0.25) WITHIN GROUP(ORDER BY MARKS) OVER() AS 'Q1',
PERCENTILE_CONT(0.75) WITHIN GROUP(ORDER BY MARKS) OVER() AS 'Q3'
FROM marks) t
WHERE t.marks > t.Q1 - (1.5*(t.Q3 - t.Q1)) AND 
t.marks < t.Q3 + (1.5*(t.Q3 - t.Q1));

# Segmentation

# Segmentation using NTILE is a technique in SQL for dividing a dataset into equla
# sized groups based on some criteria or conditions and then performing 
# calculations or analysis on each group separatly using window functions 

# eg: top, mid students in a class
# top, mid, low customers

# NTILE divides data into buckets
# Aims for equal sized 
# eg: DIviding 11 data points to 3 buckets -> 4, 4, 3

# Divide students into 3 buckets
SELECT *,
NTILE(3) OVER(ORDER BY marks DESC) AS 'buckets'
FROM marks
ORDER BY student_id;

# Divide students into 3 buckets in each branch
SELECT *,
NTILE(3) OVER(PARTITION BY branch ORDER BY marks DESC) AS 'buckets'
FROM marks
ORDER BY student_id;


# Divide phones as premium, mid_range and budget phones 

SELECT brand_name, model, price FROM smartphones;

 SELECT *,
 CASE
	WHEN bucket = 1 THEN 'premium'
    WHEN bucket = 2 THEN 'mid_range'
    WHEN bucket = 3 THEN 'budget'
END AS phone_type 
 FROM (SELECT *,
 NTILE(3) OVER(ORDER BY price DESC) AS 'bucket'
 FROM smartphones) t;
 
 # Within each brand
 
 SELECT *,
 CASE
	WHEN bucket = 1 THEN 'premium'
    WHEN bucket = 2 THEN 'mid_range'
    WHEN bucket = 3 THEN 'budget'
 (SELECT *,
 NTILE(3) OVER(PARTITION BY brand_name ORDER BY price DESC) AS 'bucket'
 FROM smartphones);
 
 # CUMULATIVE DISTRIBUTION
 # The cumulative distribution function is used to 
 # describe the probability distribution for a discrete,
 # continuous or mixed variable 
 # Obtained by summing up the probability density function
 # and getting the cumulative probability for a random variable
 
 # Answers the question "What percentage of rows in the
 # dataset have a value less than or equal to the current row 
 
 SELECT * FROM (SELECT *,
 CUME_DIST() OVER(ORDER BY marks) AS 'percentile_score'
 FROM marks) t
 WHERE t.percentile_score >= 0.99;
 
# Partition by multiple columns

# Find cheapest flight between two cities

SELECT * FROM (SELECT source, destination, airline, AVG(price),
DENSE_RANK() OVER(PARTITION BY source, destination ORDER BY AVG(price))
FROM flights 
GROUP BY source, destination, airline) t
WHERE t.rank < 2;




