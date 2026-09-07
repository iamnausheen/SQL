# Data Definition Language

/*
# DDL Commands for DB
# Creating a Databse
CREATE DATABASE aliens;

# Deleting a db
DROP DATABASE aliens;

CREATE DATABASE IF NOT EXISTS aliens;
DROP DATABASE IF EXISTS aliens;
*/

# DDL Commands for tables
CREATE DATABASE IF NOT EXISTS aliens;
USE aliens;

# Creating Table - Schema should be prepared
CREATE TABLE planets(
	planet_id INTEGER PRIMARY KEY,
    
    # Max VARCHAR size = 255
    name VARCHAR(255),
    galaxy VARCHAR(100),
    environment_type VARCHAR(50),
    star_system VARCHAR(100)
);

# Add data via GUI - grid icon on right side of planets table in schemas

# Truncate a table - remove data from table - very risky command
TRUNCATE TABLE planets;

SELECT * FROM planets; # 0 rows will be returned

# DROP - Delete Table
DROP TABLE IF EXISTS planets;

# Data Integrity = accuracy + consistency + completeness
# Implemented via - Constraints and Transactions and Normalization
# Updation, Deletion, Insertion Anomalies
# Constarints implemented via DDL
# NOT NULL
# UNIQUE
# PRIMARY KEY - One primary key per table - NOT NULL and UNIQUE
# AUTO INCREMENT 
# CHECK - eg: age > 18
# DEFAULT
# FOREIGN KEY

CREATE TABLE planets(
	planet_id INTEGER PRIMARY KEY,
    
    # Max VARCHAR size = 255
    name VARCHAR(255) NOT NULL UNIQUE,
    galaxy VARCHAR(100) DEFAULT "Milky Way",
    environment_type VARCHAR(50),
    star_system VARCHAR(100)
);

# Referential Actions - On deleting entries from parent table how will child table behave
# RESTRICT mode - won't let you delete or update an entry from parent table for which child records exist
# CASCADE - updates values in child table when fk in parent table changes
# SET NULL 
# SET DEFAULT 

CREATE TABLE aliens(
	alien_id INTEGER,
	codename VARCHAR(255) NOT NULL UNIQUE,
    species VARCHAR(255) NOT NULL,
    first_appearance_episode INTEGER CHECK (first_appearance_episode >= 1 AND first_appearance_episode <= 100),
    #episode_air_date DATE DEFAULT (CURRENT_DATE),
    home_planet VARCHAR(255),
    
    FOREIGN KEY(home_planet) REFERENCES planets(name) ON UPDATE CASCADE ON DELETE SET NULL,
    
    # Another way for making constraints - CHECK, FOREIGN KEY, PRIMARY KEY, UNIQUE can be made this way
    CONSTRAINT aliens_aliens_alien_id UNIQUE (codename), 
    CONSTRAINT valid_episode_check CHECK (first_appearance_episode <= 1 AND first_appearance_episode >= 100),
    CONSTRAINT aliens_fk FOREIGN KEY (home_planet) REFERENCES planets(name) ON UPDATE CASCADE ON DELETE SET NULL,
    
    # This way is helful when fields have to be clubbed for making constraints
    CONSTRAINT aliens_pk PRIMARY KEY(alien_id, codename)
);

# ALTER TABLE - modify table schema - add or delete columns or constraints

ALTER TABLE aliens
	ADD COLUMN individual_name VARCHAR(100) DEFAULT 'Ben Tennyson' AFTER species,
	ADD CONSTRAINT aliens_aliens_name_individual UNIQUE(codename, individual_name);
  
# Auto Increment - don't need to provide value separately, automatically generates one value greater than previous one
# Else we would have to fetch last created row, increment by one and then add that value manually 
CREATE TABLE abilities(
	ability_id INTEGER AUTO_INCREMENT,
    alien_codename VARCHAR(255),
    ability_name VARCHAR(255),
    
    CONSTRAINT abilities_pk PRIMARY KEY(ability_id),
    FOREIGN KEY (alien_codename) REFERENCES aliens(codename) ON UPDATE CASCADE ON DELETE CASCADE
);

# Alter Table - Add, Delete, Modify Columns or Constraints

ALTER TABLE abilities
	ADD COLUMN ability_type VARCHAR(255),
    ADD COLUMN intensity VARCHAR(255);
    
ALTER TABLE abilities
	MODIFY COLUMN intensity INTEGER DEFAULT 10;
    
ALTER TABLE abilities
	ADD CONSTRAINT abilities_name_exists UNIQUE(ability_name);
    
# To delete column or constraint use keyword DROP
# In order to modify constraints delete it and then add again
ALTER TABLE aliens
	DROP valid_episode_check,
    ADD CONSTRAINT valid_episode_check CHECK(first_appearance_episode >=1 AND first_appearance_episode <= 200);






 

