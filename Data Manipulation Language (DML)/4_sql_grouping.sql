# Grouping 

# Count of phones of each brand
SELECT COUNT(*), AVG(price), MAX(rating), 
AVG(screen_size), AVG(battery_capacity) 
FROM smartphones.smartphones GROUP BY brand_name;

SELECT COUNT(*) FROM smartphones.smartphones
GROUP BY animation;

SELECT AVG(price), AVG(rating) 
FROM smartphones.smartphones
GROUP BY nfc;

SELECT AVG(price) FROM smartphones.smartphones
GROUP BY extended_memory_available;


# Count no. of phones without nfc and ir blaster
SELECT COUNT(*) FROM smartphones.smartphones
WHERE has_nfc = False AND has_ir_blaster = False;

# Find the brand which has maxm. no. of phones without nfc and ir blaster
SELECT brand_name, COUNT(*) AS 'count' 
FROM smartphones.smartphones
WHERE has_nfc = 'False' AND has_ir_blaster = 'False'
GROUP BY brand_name
ORDER BY 'count'
LIMIT 1;

# Avg price of samsung 5g phones with and without nfc
SELECT has_nfc, AVG(price) FROM smartphones.smartphones
WHERE brand_name = 'samsung' AND has_5g = 'True'
GROUP BY has_nfc;

# Find phone name, price of the costliest phone
SELECT price, MODEL FROM smartphones.smartphones
ORDER BY price DESC LIMIT 1;

# HAVING - filtering group by
# like WHERE clause for SELECT
# eg: display avg price of only those brands which have at least 20 phones
# It doesn't make sense to take avg. for a very small dataset
SELECT brand_name, COUNT(*) AS 'count', AVG(price)
FROM smartphones.smartphones
GROUP BY brand_name HAVING count >= 20;

# Avg. rating of smartphone brands having more than 40 phones
SELECT brand_name, COUNT(*) AS 'count', AVG(rating)
FROM smartphones.smartphones
GROUP BY brand_name HAVING count >= 20;

SELECT brand_name, AVG(ram_capacity) AS 'avg_ram'
FROM smartphones.smartphones
WHERE refresh_rate >= 90 AND fast_charging_available = 1
GROUP BY brand_name HAVING COUNT(*) >= 10
ORDER BY avg_ram DESC LIMIT 3;

SELECT brand_name, AVG(price) 
FROM smartphones.smartphones 
WHERE has_5g = 'True'
GROUP BY brand_name HAVING AVG(rating) > 70 AND COUNT(*) > 10;

SELECT * FROM smartphones.smartphones; 