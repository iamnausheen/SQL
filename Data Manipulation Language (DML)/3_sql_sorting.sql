# Sorting Data 

# Find top 5 samsung smartphones with the biggest screen 
SELECT model, screen_size FROM smartphones.smartphones 
	WHERE brand_name = 'samsung' 
    ORDER BY screen_size DESC LIMIT 5;
    
# Order by total number of cameras
SELECT model, num_front_cameras + num_rear_cameras AS 'total_cameras'  
    FROM smartphones.smarthones
	ORDER BY total_cameras DESC;

# Sort data on the basis of ppi 
SELECT model, ROUND(SQRT((resolution_width^2+resolution_height^2)/screen_size)) AS 'ppi'
	FROM smartphones.smartphones
    ORDER BY ppi;
    
# Find the phone with second largest battery
# LIMIT x, y -> Print y rows starting from x - x indexing from 0
SELECT * FROM smartphones.smartphones
	ORDER BY battery_capacity DESC LIMIT 1, 1;
# but what if more than 1 phone has the same battery

# Find the phone with second lowest battery
# LIMIT x, y -> Print y rows starting from x - x indexing from 0
SELECT * FROM smartphones.smartphones
	ORDER BY battery_capacity LIMIT 1, 1;
 
# Find the  name and rating of worst rated applephone
SELECT model, rating FROM smartphones.smartphones
	WHERE brand_name = 'apple' ORDER BY rating LIMIT 1;
	
# If we use min then 2 queries have to be written to extract info
SELECT MIN(rating) FROM smartphones.smartphones
	WHERE brand_name = 'apple';
SELECT * FROM smartphones.smartphones
	WHERE brand_name = 'apple' AND rating = 61;
    
# Sort phones alphabetically and then on the basis of rating in descending order
SELECT * FROM smartphones.smartphones
	ORDER BY model ASC, rating DESC;
    
# eg: during a test, students who have scored the same, their tie will be broken by time - highest scores and least time

# sort phones alphabetically and then on the basis of price in ascending order
SELECT * FROM smartphones.smartphones
	ORDER BY model, price;
    

