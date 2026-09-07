# DML - Data Manipulation Language - CRUD Operations

# INSERT - Create
# SELECT - Read
# UPDATE
# DELETE

# Ctrl+Enter to run queries

CREATE DATABASE IF NOT EXISTS marvel;
USE marvel;

DROP TABLE IF EXISTS heroes;

CREATE TABLE heroes(
	hero_id INTEGER PRIMARY KEY AUTO_INCREMENT,
    alias VARCHAR(255) UNIQUE NOT NULL,
    name VARCHAR(255) UNIQUE NOT NULL,
    primary_power VARCHAR(255),
    status ENUM('Active', 'Retired', 'Deceased', 'Snapped') DEFAULT 'Active',
    power_score INTEGER CHECK(power_score >= 1 AND power_score <= 100)
);

SELECT * FROM heroes;

# INSERT 
# hero_id is auto increment

INSERT INTO marvel.heroes (alias, name, primary_power, status, power_score) VALUES 
	('Iron Man', 'Tony Stark', 'Powered Aromor Suit', 'Active', 85),
    ('Captain America', 'Steve Rogers', 'Super Soldier Serum', 'Active', 80), 
    ('Thor', 'Thor Odinson', 'God of Thunder', 'Active', 95),
    ('Black Widow', 'Natasha Romanoff', 'Master Spy / Martial Artist', 'Active', 65),
    ('Spider Man', 'Peter Parker', 'Spider Physiology', 'Active', 80);
    
SELECT * FROM marvel.heroes;    

# When column names are not mentioned all values should be provided and in order
# First column will auto increment automatically unless value given
INSERT INTO marvel.heroes VALUES (NULL, 'Hulk', 'Bruce Banner', 'Gamma Radiation Mutation', 'Active', 98);
INSERT INTO marvel.heroes VALUES(10, 'Doctor Strange', 'Stephen Strange', 'Mystic Arts', 'Active', 92);

UPDATE marvel.heroes SET hero_id = 7 WHERE hero_id = 10;




