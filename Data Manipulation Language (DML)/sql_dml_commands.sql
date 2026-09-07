# Rarely is data created, data is integrated and processing is done on that data - Read and Write - SLECT and UPPDATE
CREATE DATABASE IF NOT EXISTS smartphones;
USE smartphones; 

# IMPORT DATA - right click on Tables under smartphones db - table data import wizard - csv files can be imported

# SELECT all rows 
SELECT * FROM smartphones.smartphones;
SELECT * FROM smartphones.smartphones WHERE 1; # No conditions applied - all rows fetched

# Select only few columns - Filtering columns
SELECT model, price, rating FROM smartphones.smartphones;
SELECT model, battery_capacity, os FROM smartphones.smartphones;
SELECT os, battery_capacity, model FROM smartphones.smartphones;

# alias
SELECT os AS 'Operating System', model, battery_capacity AS 'mAH' FROM smartphones.smartphones;

# calculate ppi(pixel per inches) = sqrt((no. of pixels along horizontal line)^2 + (no. of pixels along vertical line)^2)/screen_size metric
SELECT model, 
	SQRT(resolution_width*resolution_width + resolution_height*resolution_height)/screen_size AS 'PPI' from smartphones.smartphones;

# Gives column names as 'rating/10' without aliasing    
SELECT model, rating/10 FROM smartphones.smartphones;

# Creating a new constant column
SELECT model, 'smartphones' AS 'smartphones' FROM smartphones.smartphones;

# DISTINCT - fetch unique values
SELECT DISTINCT(brand_name) AS 'all_brands' FROM smartphones.smartphones;
SELECT DISTINCT(os) AS 'all_os' FROM smartphones.smartphones;
SELECT DISTINCT(processor_brand) AS 'all_processors' FROM smartphones.smartphones;

# unique combinations
SELECT DISTINCT brand_name, processor_brand FROM smartphones.smartphones;

# Filtering rows 

# Select all samsung phones

SELECT * FROM smartphones.smartphones
	 WHERE brand_name = 'samsung';
     
# price > 50000
SELECT * FROM smartphones.smartphones WHERE  price > 50000;

# Find all phones in the price range of 10k to 20k
SELECT * FROM smartphones.smartphones 
	WHERE price >= 10000 AND price <= 20000;
    
SELECT * FROM smartphones.smartphones 
	WHERE price BETWEEN 10000 AND 20000;
    
# Find phones with rating > 80 and price < 25000
SELECT * FROM smartphones.smartphones 
	WHERE rating > 80 AND price < 25000;
    
SELECT * FROM smartphones.smartphones 
	WHERE rating > 80 AND price < 25000 AND processor_brand = 'snapdragon';

# Samsung phones with RAM > 8 GB 
SELECT * FROM smartphones.smartphones
	WHERE brand_name = 'samsung' AND 'ram_capacity' > 8;

# samsung with snapdragon
SELECT * FROM smartphones.smartphones
	WHERE brand_name = 'samsung' AND processor_brand = 'snapdragon';

# Query Execution Order - infytq - infosys courses
# Frank John's Wicked Grave Haunts Several Dull Owls
# 1 From 
# 2 Join 
# 3 Where 
# 4 Group by 
# 5 Having 
# 6 Select 
# 7 Distinct 
# 8 Order by

# Find brands who sell phones > 50k
SELECT DISTINCT brand_name FROM smartphones.smartphones 
	WHERE price > 50000;

# In and Not in 

# Find phones where processor is not snapdragon, exinos, bionic

SELECT * FROM smartphones.smartphones
	WHERE processor_brand = 'snapdragon' OR processor_brand = 'exynos' OR processor_brand = 'bionic';

SELECT * FROM smartphones.smartphones 
	WHERE processor_brand IN ('snapdragon', 'exynos', 'bionic');

SELECT * FROM smartphones.smartphones 
	WHERE processor_brand NOT IN ('snapdragon', 'exynos', 'bionic');

# UPDATE and DELETE are risky commands - permanent operations
# especially in OLTP - Online Transaction Processing - Transactions are occuring on the DB  

# UPDATE 

SELECT * FROM smartphones.smartphones
	WHERE processor_brand = 'mediatek';
    
# let's say mediatek renames itself to dimensity

# safe mode - tables without a primary key won't get updated or deleted 
# Edit tab -> preferences -> SQL Editor -_ uncheck Safe Updates
UPDATE smartphones.smartphones 
	SET processor_brand = 'dimensity', rating = 80
    WHERE processor_brand = 'mediatek';

# Delete - Deletes rows selectively

# Delete all phones whose price > 200000, (outliers removed during EDA)

DELETE FROM smartphones.smartphones
	WHERE price > 200000;
    
DELETE FROM smartphones.smartphones
	WHERE primary_camera_rare > 150 AND brand_name = 'samsung';
    
# Functions - piece of code performing specific tasks
# SQL functions - can be built_in or user_defined
# built_in - scalar functions or aggregate functions
# scalar eg: round(), sqrt(), absolute(), lower(), upper()
# aggregate functions eg: avg(), sum(), min(), max()

# MAX(), MIN()

SELECT 
	MAX(price) AS 'maximum_price', 
    MIN(price) AS 'minimum_price'
FROM smartphones.smartphones;

# Find costliest samsung phone
SELECT MAX(price) FROM smartphones.smartphones 
	WHERE brand_name = 'samsung';

# AVG()
# Find avg. rating of apple phones
SELECT AVG(rating) FROM smartphones.smartphones
	WHERE brand_name = 'apple';
  
# COUNT()
# Find the number of oneplus phones
SELECT COUNT(*) FROM smartphones.smartphones
	WHERE brand_name = 'oneplus';
    
SELECT sum(price) FROM smartphones.smartphones;
    
# COUNT DISTINCT
# Find the number of brands available

SELECT COUNT(DISTINCT brand_name) FROM smartphones.smartphones;

# Find standard deviation of screen sizes
SELECT STD(screen_size) FROM smartphones.smartphones;

# Find variance of xiomi phone prices
SELECT VARIANCE(price) FROM smartphones.smartphones
	WHERE brand_name = 'xiaomi';

# Scalar functions

# ABS 
SELECT ABS(100000-price) AS 'temp' FROM smartphones.smartphones;

# round the ppi to 2 decimal place , by default rounds to whole number
SELECT model, 
	ROUND(SQRT(resolution_width*resolution_width + resolution_height*resolution_height)/screen_size, 2) AS 'PPI' from smartphones.smartphones;

# Ceil/floor 
# Ceil - 4.1 = 4
# Floor - 4.1 = 5

SELECT CEIL(screen_size) FROM smartphones.smartphones;
SELECT FLOOR(screen_size) FROM smartphones.smartphones;


    


    

	