/** Name: Srinivas Dengle
  ** Assignment: 4
  ** Date: April 3, 2023
  ** Description: Creating a reciept
  **                         
**/



-- DROP/CREATE/verify boxstore DATABASE -----------------------------
DROP DATABASE IF EXISTS sd_0391390_boxstore;

CREATE DATABASE If Not Exists sd_0391390_boxstore
CHARSET='utf8mb4'
COLLATE='utf8mb4_unicode_ci';

USE sd_0391390_boxstore;

-- Drop constraints for people TABLE
-- ALTER TABLE IF EXISTS people DROP CONSTRAINT IF EXISTS people_gat_addr_type_id_Fk;
-- ALTER TABLE IF EXISTS people DROP CONSTRAINT IF EXISTS people_gtc_tc_id_Fk;
-- ALTER TABLE IF EXISTS people DROP CONSTRAINT IF EXISTS people_gat_addr_type_id_FK;


-- Checking if the table exists -------------------------------------


DROP TABLE IF EXISTS people;
CREATE TABLE IF NOT EXISTS people (
  p_id INT(11) AUTO_INCREMENT
  , pe_id INT
  , full_name VARCHAR(100) NULL
  , PRIMARY KEY(p_id)
  , UNIQUE KEY (pe_id)
);
DESCRIBE people;


-- section
TRUNCATE TABLE people;

INSERT INTO people(full_name) VALUES ('Brad Vincelette');
INSERT INTO people(full_name) VALUES ('Srinivas Dengle');

SELECT p_id, full_name 
FROM people;



-- loading the 10000 names from a csv file --------------------------
LOAD DATA INFILE "./sd_0391930_boxstore-10000.csv"
INTO TABLE people(full_name);

SELECT p_id, full_name 
FROM people;


-- adding columns ---------------------------------------------------
ALTER TABLE people
	ADD COLUMN first_name VARCHAR(40) NULL
  , ADD COLUMN last_name VARCHAR(60) NULL;
DESCRIBE people;
 
 

-- splitting full names to first and last names ---------------------
UPDATE people
SET first_name = MID(full_name,1,INSTR(full_name,' ')-1)
   , last_name = MID(full_name,INSTR(full_name,' ')+1
                       ,LENGTH(full_name)-INSTR(full_name,' ')
                 );
SELECT p_id, full_name, first_name, last_name
FROM people;


-- dropping full name column ----------------------------------------
ALTER TABLE people DROP COLUMN full_name;
DESCRIBE people;


-- SELECT first and last name ---------------------------------------
SELECT p_id, first_name, last_name
FROM people;

-- altering table and adding columns --------------------------------
ALTER TABLE people
	DROP COLUMN IF EXISTS full_name
	, MODIFY COLUMN first_name VARCHAR(30)
	, MODIFY COLUMN last_name VARCHAR(30)
	, ADD COLUMN email_addr VARCHAR(50)
	, ADD COLUMN password VARCHAR(32)
	, ADD COLUMN phone_pri VARCHAR(15)
	, ADD COLUMN phone_sec VARCHAR(15)
	, ADD COLUMN phone_wrk VARCHAR(15)
	, ADD COLUMN suite_no VARCHAR(10)
	, ADD COLUMN addr VARCHAR(60)
	, ADD COLUMN addr_code VARCHAR(7)
	, ADD COLUMN addr_info VARCHAR(191)
	, ADD COLUMN addr_type_id TINYINT               -- BUILDING TYPE
	, ADD COLUMN tc_id INT
	, ADD COLUMN delivery_info TEXT
	, ADD COLUMN employee BIT NOT NULL DEFAULT 0
	, ADD COLUMN user_id INT NOT NULL DEFAULT 2
	, ADD COLUMN date_mod DATETIME NOT NULL DEFAULT NOW()
	, ADD COLUMN date_act DATETIME NOT NULL DEFAULT NOW()
	, ADD COLUMN active BIT NOT NULL DEFAULT 1;

DESCRIBE people;

ALTER TABLE people MODIFY COLUMN addr_type_id TINYINT;

-- people TABLE -----------------------------------------------------

UPDATE people
SET 
	email_addr = 'brad.v@gmail.com'
	, password= MD5('sqlstuff')
	, phone_pri= '19043316717'
	, phone_sec= '19022342323'
	, phone_wrk= '12041233455'
	, suite_no= NULL
	, addr= '2300 Fake St.'
	, addr_code= 'R3C 2B8'
	, addr_info = 'PO BOX 123'
	, addr_type_id= 1
	, tc_id= 1
	, delivery_info= ''
	, employee= 1
	, user_id= 1
	, date_mod= NOW()
WHERE p_id = 1;


UPDATE people
SET 
	email_addr = 's.dengle@gmail.com'
	, password= MD5('python')
	, phone_pri= '19043316717'
	, phone_sec= '19023375343'
	, phone_wrk= '12041233455'
	, suite_no= '120A'
	, addr= '123 Notre Dame Ave'
	, addr_code= 'R3C 2B4'
	, addr_info = 'PO BOX 334'
	, addr_type_id= 2
	, tc_id= 1
	, delivery_info= 'Please knock on the door.'
	, employee= 1
	, user_id= 1
	, date_mod= NOW()
WHERE p_id = 2;

SELECT p.p_id, p.first_name, p.last_name
	 , p.email_addr, p.password
	 , p.phone_pri, p.phone_sec, p.phone_wrk
	 , p.suite_no, p.addr, p.addr_code, p.addr_info, p.delivery_info
	 , p.addr_type_id, p.tc_id
	 , p.employee, p.user_id, p.date_mod, p.date_act, p.active
FROM people p
WHERE 1=1
LIMIT 2;
	
-- address_type TABLE (gat) ------------------------------------------
-- ALTER TABLE IF EXISTS manufacturer DROP CONSTRAINT IF EXISTS manufacturer_addr_type_id_FK;

DROP TABLE IF EXISTS geo_address_type;
CREATE TABLE geo_address_type(
	addr_type_id TINYINT AUTO_INCREMENT
	, addr_type VARCHAR(15) UNIQUE
	, active BIT NOT NULL DEFAULT 1
	, PRIMARY KEY(addr_type_id)
	-- , UNIQUE KEY(addr_type)

);

TRUNCATE TABLE geo_address_type;
INSERT INTO geo_address_type (addr_type) 
VALUES ('House')
	, ('Apartment')
	, ('Building')
	, ('Warehouse');

SELECT addr_type_id, addr_type, active
FROM geo_address_type;

-- joins
SELECT p.p_id
	, p.first_name
	, p.last_name
	, p.addr_type_id
	, gat.addr_type_id
	, gat.addr_type
FROM people p
	LEFT JOIN geo_address_type gat ON p.addr_type_id=gat.addr_type_id
LIMIT 2;


-- country TABLE ----------------------------------------------------
DROP TABLE IF EXISTS geo_country;
CREATE TABLE IF NOT EXISTS geo_country (
    c_id     TINYINT     AUTO_INCREMENT
    , c_name VARCHAR(35)
    , c_code CHAR(2)     UNIQUE
    , active bit         NOT NULL DEFAULT 1
    , PRIMARY KEY(c_id)
    , UNIQUE KEY (c_name)
);

DESCRIBE geo_country;

TRUNCATE TABLE geo_country;
INSERT INTO geo_country(c_name,c_code) 
VALUES                      ('Canada','CA');

SELECT gc.c_id, gc.c_name, gc.c_code, gc.active
FROM geo_country gc;
              
-- region TABLE --------------------------------------------
DROP TABLE IF EXISTS geo_region;
CREATE TABLE IF NOT EXISTS geo_region (
    r_id     SMALLINT    AUTO_INCREMENT
    , r_name VARCHAR(35) UNIQUE
    , r_code char(2)     UNIQUE
    , c_id   TINYINT     NOT NULL DEFAULT 1
    , active bit         NOT NULL DEFAULT 1
    , PRIMARY KEY(r_id)
);

DESCRIBE geo_region;

TRUNCATE TABLE geo_region;
INSERT INTO geo_region(r_name, r_code, c_id) 
VALUES                ('Manitoba','MB', 1);

SELECT gr.r_id, gr.r_name, gr.r_code, gr.c_id, gr.active
FROM geo_region gr;

SELECT gr.r_id, gr.r_name, gr.r_code, gr.c_id
        , gc.c_id, gc.c_name, gc.c_code
FROM geo_region gr 
     JOIN geo_country gc ON gr.c_id=gc.c_id
LIMIT 2;

-- towncity TABLE ---------------------------------------------------
-- ALTER TABLE IF EXISTS manufacturer DROP CONSTRAINT IF EXISTS manufacturer_tc_id_FK;

DROP TABLE IF EXISTS geo_towncity;
CREATE TABLE IF NOT EXISTS geo_towncity (
    tc_id     INT         AUTO_INCREMENT
    , tc_name VARCHAR(35) UNIQUE
    , r_id    SMALLINT    NOT NULL
    , active  BIT         NOT NULL DEFAULT 1 
    , PRIMARY KEY(tc_id)
    , UNIQUE KEY (r_id)
);

 DESCRIBE geo_towncity;
 
 TRUNCATE TABLE geo_towncity;
INSERT INTO geo_towncity(tc_name, r_id) 
VALUES                  ('Winnipeg', 1);

SELECT gtc.tc_id, gtc.tc_name, gtc.r_id, gtc.active
FROM geo_towncity gtc;

SELECT gtc.tc_id, gtc.tc_name, gtc.r_id
     , gr.r_id, gr.r_name, gr.c_id
     , gc.c_id, gc.c_name, gc.c_code
FROM geo_towncity gtc
    JOIN geo_region gr ON gtc.r_id=gr.r_id
    JOIN geo_country gc ON gr.c_id=gc.c_id
LIMIT 2;

SELECT p.tc_id, gtc.tc_id
FROM people p
    LEFT JOIN geo_towncity gtc ON p.tc_id=gtc.tc_id
LIMIT 2;



SELECT p.p_id, p.first_name, p.last_name
     , p.suite_no, p.addr, p.addr_code, p.delivery_info
     , p.addr_type_id, p.tc_id
     , gat.addr_type_id, gat.addr_type
     , gtc.tc_id, gtc.tc_name, gtc.r_id
     , gr.r_id, gr.r_name, gr.c_id
     , gc.c_id, gc.c_name, gc.c_code
FROM people p
     JOIN geo_address_type gat ON p.addr_type_id=gat.addr_type_id
     JOIN geo_towncity gtc ON p.tc_id=gtc.tc_id
     JOIN geo_region gr ON gtc.r_id=gr.r_id
     JOIN geo_country gc ON gr.c_id=gc.c_id;

-- Part D Envelope --------------------------------------------------
-- ALTER TABLE IF EXISTS people DROP CONSTRAINT IF EXISTS people_gtc_tc_id_FK;
/*
ALTER TABLE IF EXISTS people
	ADD CONSTRAINT people_gat_addr_type_id_FK FOREIGN KEY (addr_type_id) REFERENCES geo_address_type(addr_type_id);
ALTER TABLE IF EXISTS people
	ADD CONSTRAINT people_gtc_tc_id_FK FOREIGN KEY (tc_id) REFERENCES geo_towncity(tc_id);
-- ALTER TABLE IF EXISTS people DROP CONSTRAINT IF EXISTS people_gtc_tc_id_FK;
*/

SELECT p.p_id, p.first_name, p.last_name
	, p.addr_type_id, gat.addr_type, p.suite_no, p.addr
	, p.addr_code, p.delivery_info
	, gt.tc_name, gr.r_name, gr.r_code, gc.c_name, gc.c_code
	
FROM people p
	INNER JOIN geo_address_type gat ON p.addr_type_id=gat.addr_type_id
	INNER JOIN geo_towncity gt ON p.tc_id=gt.tc_id
	INNER JOIN geo_region gr ON gt.r_id=gr.r_id
	INNER JOIN geo_country gc ON gr.c_id=gc.c_id
LIMIT 2;



-- people_employee TABLE --------------------------------------------
ALTER TABLE IF EXISTS category_people DROP CONSTRAINT IF EXISTS cp_pe_FK;

DROP TABLE IF EXISTS people_employee;
CREATE TABLE IF NOT EXISTS people_employee(
	pe_id INT AUTO_INCREMENT
	, p_id INT                -- FK
	, p_id_mgr INT            -- NULL FOR p_id = 1 AND 1 FOR p_id = 2
	, pe_uri VARCHAR(60)
	, pe_sin VARCHAR(30)
	, date_beg DATE
	, date_end DATE
	, pe_wage FLOAT
	, bank_info VARCHAR(30) 
	, user_id INT NOT NULL DEFAULT 1
	, date_mod DATETIME NOT NULL DEFAULT NOW()
	, active BIT NOT NULL DEFAULT 1
	, PRIMARY KEY(pe_id)
	, CONSTRAINT pe_people_p_id_FK FOREIGN KEY (p_id) REFERENCES people(p_id)
);

TRUNCATE TABLE people_employee;         
INSERT INTO people_employee(p_id, p_id_mgr, pe_uri, pe_sin
	, date_beg, date_end, pe_wage, bank_info
)
VALUES ( 1 , NULL, 'brad-vincelette', 823333345, 
		'1990-10-31',NULL, 8333.33, 1234567890);
-- my record
INSERT INTO people_employee(p_id, p_id_mgr, pe_uri, pe_sin
	, date_beg, date_end, pe_wage, bank_info
)
VALUES (2, 1, 'srinivas-dengle', 827733665, 
	'2016-10-31', NULL, 4166.67, 2345678901);

SELECT pe_id, p_id, p_id_mgr, pe_uri, pe_sin, date_beg, date_end
	, pe_wage, bank_info, user_id, date_mod, active
FROM people_employee;

SELECT pe.p_id, pe.p_id_mgr
	 , p.p_id, p.first_name, p.last_name
     , m.p_id, m.first_name, m.last_name
FROM people p
	RIGHT JOIN people_employee pe ON p.p_id=pe.p_id
	LEFT JOIN people m  ON m.p_id=pe.p_id_mgr
LIMIT 10;

-- Part F------------------------------------------------------------

SELECT p.p_id, p.first_name, p.last_name
	, pe.p_id_mgr, m.first_name AS first_name_mgr
	, m.last_name AS last_name_mgr 
FROM people_employee pe
	 JOIN people p ON pe.p_id=p.p_id
	 LEFT JOIN people m ON pe.p_id_mgr = m.p_id
LIMIT 2;

-- Part G------------------------------------------------------------

SELECT p.p_id, p.first_name, p.last_name
	, pe.p_id_mgr, m.first_name AS first_name_mgr
	, m.last_name AS last_name_mgr
	, gat.addr_type, gt.tc_name, gr.r_name, gr.r_code, gc.c_name
	, gc.c_code
	
FROM people_employee pe
	LEFT JOIN people m ON m.p_id = pe.p_id_mgr
	JOIN people p ON pe.p_id = p.p_id
	INNER jOIN geo_address_type gat ON p.addr_type_id = gat.addr_type_id
	INNER JOIN geo_towncity gt ON p.tc_id = gt.tc_id
	INNER JOIN geo_region gr ON gt.r_id = gr.r_id
	INNER JOIN geo_country gc ON gr.c_id = gc.c_id
LIMIT 2;

-- people's metadata TABLE BULK UPDATE -------------------------------------------

-- streets
DROP TABLE IF EXISTS z__street;
CREATE TABLE IF NOT EXISTS z__street (
	street_name VARCHAR(25) NOT NULL
);
INSERT INTO z__street VALUES('First Ave');
INSERT INTO z__street VALUES('Second Ave');
INSERT INTO z__street VALUES('Third Ave');
INSERT INTO z__street VALUES('Fourth Ave');
INSERT INTO z__street VALUES('Fifth Ave');
INSERT INTO z__street VALUES('Sixth Ave');
INSERT INTO z__street VALUES('Seventh Ave');
INSERT INTO z__street VALUES('Eighth Ave');
INSERT INTO z__street VALUES('Ninth Ave');
INSERT INTO z__street VALUES('Cedar Blvd');
INSERT INTO z__street VALUES('Elk Blvd');
INSERT INTO z__street VALUES('Hill Blvd');
INSERT INTO z__street VALUES('Lake St');
INSERT INTO z__street VALUES('Main Blvd');
INSERT INTO z__street VALUES('Maple St');
INSERT INTO z__street VALUES('Park Blvd');
INSERT INTO z__street VALUES('Pine St');
INSERT INTO z__street VALUES('Oak Blvd');
INSERT INTO z__street VALUES('View Blvd');
INSERT INTO z__street VALUES('Washington Blvd');

-- people meta load VIEW -----
DROP VIEW IF EXISTS __people__meta_load;

CREATE VIEW IF NOT EXISTS __people__meta_load AS (

	SELECT p.p_id
	    -- , p.first_name, p.last_name
		, CONCAT(LOWER(LEFT(p.first_name,1)),LOWER(p.last_name),'@'
		, CASE WHEN RAND() < 0.25 THEN 'google.com'
	  		   WHEN RAND() < 0.50 THEN 'outlook.com'
	  		   WHEN RAND() < 0.75 THEN 'live.com'
	 		   ELSE 'rocketmail.com' END) AS email_addr
	 	, MD5(RAND()) AS password
	 	, CONCAT('204-', LEFT(CONVERT(RAND()*10000000,INT),3),'-', LEFT(CONVERT(RAND()*10000000,INT),4)) AS phone_pri
	 	, CONCAT('204-', LEFT(CONVERT(RAND()*10000000,INT),3),'-', LEFT(CONVERT(RAND()*10000000,INT),4)) AS phone_sec
	 	, CONCAT('204-', LEFT(CONVERT(RAND()*10000000,INT),3),'-', LEFT(CONVERT(RAND()*10000000,INT),4)) AS phone_wrk
	 	, NULL AS suite_no
	 	, MIN(
	 		CONCAT(
	             CASE WHEN RAND() < 0.25 THEN CONVERT(RAND()*100,INT)
	                  WHEN RAND() < 0.50 THEN CONVERT(RAND()*1000,INT)
	                  WHEN RAND() < 0.75 THEN CONVERT(RAND()*10000,INT)
	                                     ELSE CONVERT(RAND()*10,INT) END+10
	             ,' ',zs.street_name)
	 	  ) AS addr
	 	, CONCAT(
		  	SUBSTRING('ABCDEFGHIJKLMNOPQRSTUVWXYZ', rand()*26+1, 1)
				, SUBSTRING('0123456789', rand()*10+1, 1)
				, SUBSTRING('ABCDEFGHIJKLMNOPQRSTUVWXYZ', rand()*26+1, 1)
				, ' '
				, SUBSTRING('0123456789', rand()*10+1, 1)
				, SUBSTRING('ABCDEFGHIJKLMNOPQRSTUVWXYZ', rand()*26+1, 1)
				, SUBSTRING('0123456789', rand()*10+1, 1) 
		  ) AS addr_code
		, NULL AS addr_info
		, CASE WHEN RAND() < 0.50 THEN 1 ELSE 2 END AS addr_type_id
		, 1 AS tc_id
		, 0 AS employee
		, 2 AS user_id
		, NOW() AS date_mod
	FROM people p, z__street zs
	GROUP BY p.p_id
);
SELECT * FROM __people__meta_load;

-- people TABLE UPDATE 10000 people records  ------------------------
UPDATE people p 
       JOIN __people__meta_load dt ON p.p_id = dt.p_id
SET p.email_addr = dt.email_addr
  , p.password = dt.password
  , p.phone_pri = dt.phone_pri
  , p.phone_sec = dt.phone_sec
  , p.phone_wrk = dt.phone_wrk
  , p.suite_no = dt.suite_no
  , p.addr = dt.addr
  , p.addr_code = dt.addr_code
  , p.addr_info = dt.addr_info
  , p.addr_type_id = dt.addr_type_id
  , p.tc_id = dt.tc_id
  , p.employee = dt.employee
  , p.user_id = dt.user_id  
  , p.date_mod = dt.date_mod
WHERE p.p_id>2;

-- ------------------------------------------------------------------

SELECT p.p_id, p.first_name, p.last_name
     , p.email_addr, p.password
	 , p.phone_pri, p.phone_sec, p.phone_wrk 
	 , p.suite_no, p.addr, p.addr_code, p.addr_info, p.delivery_info
	 , p.addr_type_id, p.tc_id
	 , p.employee, p.user_id, p.date_mod, p.date_act, p.active
FROM people p
LIMIT 0,10;

-- DROP VIEW IF EXISTS __people__meta_load;
-- DROP TABLE IF EXISTS z__street;


-- Table: category --------------------------------------------------
ALTER TABLE IF EXISTS category_people DROP CONSTRAINT IF EXISTS cp_category_FK;

DROP TABLE IF EXISTS category;
CREATE TABLE IF NOT EXISTS category (
	  cat_id 		MEDIUMINT AUTO_INCREMENT
	, cat_id_parent MEDIUMINT -- FK
	, cat_name 		VARCHAR(60)
	, cat_abbr 		VARCHAR(10)
	, cat_uri 		VARCHAR(60)
	, hashtag 		VARCHAR(50)
	, taxonomy 		VARCHAR(15)
	, user_id 		INT NOT NULL DEFAULT 2 -- FK
	, date_mod 		DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
	, active 		BIT NOT NULL DEFAULT 1
	, CONSTRAINT category_PK PRIMARY KEY(cat_id)
	, CONSTRAINT category_UK UNIQUE (taxonomy ASC, cat_name ASC)
);


TRUNCATE TABLE category;
-- item
INSERT INTO category (cat_id_parent, cat_name, cat_abbr, cat_uri, hashtag, taxonomy)
VALUES               (NULL, 'Electronics', NULL, 'electronics', '#electronics', 'departments');
-- people
INSERT INTO category (cat_id_parent, cat_name, cat_abbr, cat_uri, hashtag, taxonomy)
VALUES               (NULL, 'Sales', NULL, 'sales', '#sales', 'departments');

SELECT cat.cat_id, cat.cat_id_parent, cat.cat_name, cat.cat_abbr
	 , cat.cat_uri, cat.hashtag, cat.taxonomy
     , cat.user_id, cat.date_mod, cat.active
FROM category cat
WHERE taxonomy='departments';

-- Table: category__people ------------------------------------------

DROP TABLE IF EXISTS category__people;
CREATE TABLE IF NOT EXISTS category__people (
	 cp_id INT AUTO_INCREMENT
	, cat_id MEDIUMINT -- FK
	, pe_id INT -- FK
	, user_id INT NOT NULL DEFAULT 2
	, date_mod DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
	, active BIT NOT NULL DEFAULT 1
	, PRIMARY KEY(cp_id)
	, UNIQUE (cat_id, pe_id)
);

TRUNCATE TABLE category__people;
INSERT INTO category__people (cat_id, pe_id)
VALUES                       (1, 2),(2, 1);

SELECT cp.cp_id, cp.cat_id, cp.pe_id
	 , cp.user_id, cp.date_mod, cp.active
FROM category__people cp;

-- Table: JOIN category to people -----------------------------------

SELECT cat.cat_id, cat.cat_name, cat.taxonomy, cat.cat_uri
	 , cp.cat_id, cp.pe_id             -- , cp.cp_id
	 , pe.pe_id, pe.pe_uri, pe.p_id    -- , pe.p_id_mgr
	 , p.p_id, p.first_name, p.last_name
FROM category cat
	 JOIN category__people cp ON cat.cat_id=cp.cat_id
	 JOIN people_employee pe ON cp.pe_id=pe.pe_id
	 JOIN people p  ON pe.p_id=p.p_id
WHERE cat.taxonomy='departments';

-- ------------------------------------------------------------------
-- uri queries

SELECT cat.cat_id, cp.cat_id, cp.pe_id, p.p_id
	 , CONCAT('https://boxstore.com/',cat.taxonomy,'/',cat.cat_uri,'/',pe.pe_uri,'/') AS site_dept_area_permalink
	 , CONCAT('https://boxstore.com/staff/',pe.pe_uri,'/') AS site_staff_emp_permalink
FROM category cat
	 JOIN category__people cp ON cat.cat_id=cp.cat_id
	 JOIN people_employee pe ON cp.pe_id=pe.pe_id
	 JOIN people p  ON pe.p_id=p.p_id
WHERE cat.taxonomy='departments';

-- https://boxstore.com/departments/sales/brad-vincelette/
-- https://boxstore.com/departments/sales/srinivas-dengle
-- https://boxstore.com/staff/brad-vincelette/
-- https://boxstore.com/staff/srinivas-dengle/
-- taxonomy departmenrs is for employees
-- 			electronics is for items 


-- manufacturer (man) TABLE -----------------------------------------
 ALTER TABLE IF EXISTS item DROP CONSTRAINT IF EXISTS item_manufacturer_FK;

DROP TABLE IF EXISTS manufacturer;
CREATE TABLE IF NOT EXISTS manufacturer(
	man_id 			INT AUTO_INCREMENT		-- PK > FK (itemman_id) 
	, man_name		VARCHAR(35)
	, p_id_man		INT
	, phone_pri		VARCHAR(15)
	, phone_sales	VARCHAR(15)
	, phone_sup		VARCHAR(15)
	, phone_fax		VARCHAR(15)
	, suite_no		VARCHAR(10)		-- DIFFERENT NUMBER OT LETTERS FOR HOUSE, BUILDING, APARTMENTS
	, addr			VARCHAR(60)		-- address 123 fake st
	, addr_code		VARCHAR(7)		-- postal code OR zip code
	, addr_info		VARCHAR(191)	-- FOR po box info
	, delivery_info	VARCHAR(191)	-- FOR additional info
	, addr_type_id	TINYINT			-- the id FOR the address building type
	, tc_id			INT				-- FK TO town_city TABLE
	, user_id		INT NOT NULL DEFAULT 2 -- FK
	, date_mod		DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
	, active		BIT NOT NULL DEFAULT 1
	, CONSTRAINT man_PK PRIMARY KEY (man_id)
	, CONSTRAINT man_UK UNIQUE (man_name)
	-- , CONSTRAINT man_people_FK			FOREIGN KEY (p_id_man) REFERENCES people(p_id)
-- 	, CONSTRAINT manufacturer_addr_type_id_FK FOREIGN KEY (addr_type_id) REFERENCES geo_address_type(addr_type_id)
-- 	, CONSTRAINT manufacturer_tc_id_FK 		FOREIGN KEY (tc_id) REFERENCES geo_towncity(tc_id)
);
/*
TRUNCATE TABLE manufacturer;
INSERT INTO manufacturer(man_name, p_id_man
						, phone_pri, phone_sales, phone_sup, phone_fax
						, addr, addr_code, addr_info, addr_type_id, tc_id)
VALUES					('Acme Co.', 3
						, '222-222-2222', '333-333-3333', '444-444-444', '555-555-5555'
						, '3 Road Runner way', 'R1X 2B2', NULL, 3, 1);
				
SELECT man.man_id, man.man_name, man.p_id_man
	, man.phone_pri, man.phone_sales, man.phone_sup, man.phone_fax
	, man.suite_no, man.addr, man.addr_code, man.addr_info
	, man.addr_type_id, man.tc_id
	, man.user_id, man.date_mod, man.active
FROM manufacturer man;
*/

-- manufacturer INSERTS ---------------------------------------------
 TRUNCATE TABLE manufacturer;
 INSERT INTO manufacturer (man_name, p_id_man
            , phone_pri, phone_sales, phone_sup, phone_fax
            , addr, addr_code, addr_info, addr_type_id, tc_id)
VALUES                   ('Acme Co.', 3
            , '222-222-2222', '333-333-3333', '444-444-4444', '555-555-5555'
           , '3 Road Runner Way', 'R1R 2W3', NULL, 3, 1);


-- JOIN
SELECT man.man_id, man.man_name
	, man.p_id_man
	, man.addr_type_id
	, man.tc_id
	, p.p_id, p.first_name, p.last_name
	, gat.addr_type_id, gat.addr_type
	, gtc.tc_id, gtc.tc_name
	, gr.r_id, gr.r_name
	, gc.c_id, gc.c_name
FROM manufacturer man
	JOIN people p ON man.p_id_man=p.p_id
	JOIN geo_address_type gat ON man.addr_type_id=gat.addr_type_id
	JOIN geo_towncity gtc ON man.tc_id=gtc.tc_id
	JOIN geo_region gr ON gtc.r_id= gr.r_id
	JOIN geo_country gc ON gr.c_id=gc.c_id;

-- TABLE: item ------------------------------------------------------
-- Drop constraint for table "category"
-- ALTER TABLE category_item DROP CONSTRAINT IF EXISTS ci_item_id_FK;

-- Drop constraint for table "orders"
ALTER TABLE IF EXISTS orders__item DROP CONSTRAINT IF EXISTS orders_item_fk;

-- Drop constraints for table "item"
ALTER TABLE IF EXISTS item_detail DROP CONSTRAINT IF EXISTS id_item_fk;
ALTER TABLE IF EXISTS item_metadesc DROP CONSTRAINT IF EXISTS im_item_fk;
ALTER TABLE IF EXISTS item_price DROP CONSTRAINT IF EXISTS ip_item_fk;

DROP TABLE IF EXISTS item;
CREATE TABLE IF NOT EXISTS item(
    item_id INT AUTO_INCREMENT
    , item_name VARCHAR(50) NOT NULL
    , item_uri  VARCHAR(50) UNIQUE
    , item_type VARCHAR(25)
    , item_modelno VARCHAR(30)
    , item_barcode VARCHAR(18)
    , item_uom VARCHAR(20)
    , item_size VARCHAR(20)
    , item_price DECIMAL(7,2)
    , man_id INT NOT NULL
    , user_id INT NOT NULL DEFAULT 2
    , date_mod DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
    , active BIT NOT NULL DEFAULT 1
    , CONSTRAINT item_PK PRIMARY KEY (item_id)
    , CONSTRAINT item_UK UNIQUE (item_name)
    , CONSTRAINT item_manufacturer_FK FOREIGN KEY (man_id) REFERENCES manufacturer(man_id)
    );
TRUNCATE TABLE item;
INSERT INTO item (item_name, item_uri, item_type, item_modelno
            ,item_barcode, item_uom, item_size, item_price
            ,man_id)
VALUES      ('Black Hole Mat', REPLACE(LOWER('Black Hole Mat'),' ','-'), 'street', 'BWM90210'
            ,'12457893759830', 'm<sup>2</sup>', '1', 999.99, 1);


SELECT i.item_id, i.item_name, i.item_uri, i.item_type, i. item_modelno
       , i.item_barcode, i.item_uom, i.item_size, i.man_id, i.user_id
       , i.date_mod,i.active
FROM item i;

SELECT man.man_id, man.man_name
       ,i.item_id, i.item_name, i.item_uri
FROM manufacturer man
    JOIN item i ON man.man_id=i.man_id;
    
-- TABLE: item_detail (id) ------------------------------------------
    
DROP TABLE IF EXISTS item_detail;
CREATE TABLE IF NOT EXISTS item_detail(
    id_id BIGINT AUTO_INCREMENT
    , item_id INT NOT NULL
    , id_label VARCHAR(50) NOT NULL
    , id_value VARCHAR(50) NOT NULL
    , user_id INT NOT NULL DEFAULT 2 -- FK
    , date_mod DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
    , active BIT NOT NULL DEFAULT 1
    , CONSTRAINT id_PK PRIMARY KEY (id_id)
    , CONSTRAINT id_UK UNIQUE (item_id, id_label)
    , CONSTRAINT id_item_FK FOREIGN KEY (item_id) REFERENCES item(item_id)
    );
    
TRUNCATE TABLE item_detail;
INSERT INTO item_detail (item_id, id_label, id_value)
VALUES      (1, 'Width x Depth', '1m x 1m')
            ,(1, 'Color and Shape', 'Black and Circle');
        
SELECT id.id_id, id.item_id, id.id_label, id.id_value, 
       id.user_id, id.date_mod, id.active
FROM manufacturer man
    JOIN item i ON man.man_id=i.man_id
    JOIN item_detail id ON i.item_id=id.item_id;

-- TABLE: item_metadesc (im) ----------------------------------------
    
DROP TABLE IF EXISTS item_metadesc;
CREATE TABLE IF NOT EXISTS item_metadesc (
    im_id BIGINT AUTO_INCREMENT
    , item_id INT
    , im_description TEXT
    , user_id INT NOT NULL DEFAULT 2 
    , date_mod DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
    , active BIT NOT NULL DEFAULT 1
    , PRIMARY KEY (im_id)
    , CONSTRAINT im_item_FK FOREIGN KEY (item_id) REFERENCES item(item_id)
);
TRUNCATE TABLE item_metadesc;
INSERT INTO item_metadesc (item_id, im_description)
VALUES                    (1, 'A black dot, used like a mat, to send someone into the abyss.');

SELECT im.im_id, im.item_id, im.im_description
       ,im.user_id, im.date_mod, im.active
FROM item_metadesc im;

-- joins
SELECT man.man_name, id.id_label, id.id_value 
       , id.user_id, id.date_mod
       , im.im_description, im.active
FROM manufacturer man
    JOIN item i ON man.man_id=i.man_id
    JOIN item_detail id ON i.item_id=id.item_id
    JOIN item_metadesc im ON i.item_id = im.item_id;

-- TABLE: item_price (ip) -------------------------------------------

DROP TABLE IF EXISTS item_price;
CREATE TABLE IF NOT EXISTS item_price(
    ip_id BIGINT AUTO_INCREMENT
    , item_id INT
    , ip_beg DATETIME NULL
    , ip_end DATETIME NULL
    , ip_price DECIMAL (7,2)
    , user_id INT NOT NULL DEFAULT 2 
    , date_mod DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
    , active BIT NOT NULL DEFAULT 1
    , PRIMARY KEY(ip_id)
    , CONSTRAINT ip_item_FK FOREIGN KEY (item_id) REFERENCES item(item_id)
    );

TRUNCATE TABLE item_price;
INSERT INTO item_price (item_id, ip_price, ip_beg, ip_end)
VALUES                (1, 999.99, '2023-03-01 04:00:32', NULL)							-- regular
                      , (1, 899.99, '2023-03-24 04:00:32', '2023-03-30 04:00:32');		-- Sale

SELECT ip.ip_id, ip.item_id, ip.ip_beg, ip.ip_end, ip.ip_price
       ,ip.user_id, ip.date_mod, ip.active
FROM item_price ip;

-- joins
SELECT man.man_name, id.id_label, id.id_value 
	, ip.ip_beg, ip.ip_end, ip.ip_price
    , im.im_description, im.active
FROM manufacturer man
    JOIN item i ON man.man_id=i.man_id
    JOIN item_detail id ON i.item_id=id.item_id
    JOIN item_metadesc im ON i.item_id = im.item_id
	JOIN item_price ip ON ip.item_id = i.item_id;

-- building the receipt query ------------
SELECT i.item_id, i.item_name, i.item_uri, i.item_type, i.item_modelno
	 , i.item_barcode, i.item_uom, i.item_size, i.man_id
	 , i.user_id, i.date_mod, i.active
FROM item i;

-- all of the rows -----
SELECT fake.order_date, i.item_id, i.item_name, i.item_price
	 , ip.ip_price
FROM item i
	JOIN item_price ip ON i.item_id = ip.item_id
	, (SELECT '2023-03-25 11:00:00.000' AS order_date) fake
WHERE fake.order_date BETWEEN ip.ip_beg AND IFNULL(ip.ip_end, fake.order_date);

-- attaching receipt to orders and orders_item table -------
SELECT fake.order_date, i.item_id, i.item_name, i.item_price
   	 , MAX(ip.ip_price) AS ip_price_reg
   	 , CASE WHEN MIN(ip.ip_price)=MAX(ip.ip_price) THEN NULL ELSE MIN(ip.ip_price) END AS ip_price_sal
FROM item i
	JOIN item_price ip ON i.item_id = ip.item_id
	, (SELECT '2023-03-25 11:00:00.000' AS order_date) fake
WHERE fake.order_date BETWEEN ip.ip_beg AND IFNULL(ip.ip_end, fake.order_date)
GROUP BY fake.order_date, i.item_id, i.item_name, i.item_price;


-- TABLE: tax -------------------------------------------------------
DROP TABLE IF EXISTS tax;
CREATE TABLE IF NOT EXISTS tax(
    tax_id SMALLINT AUTO_INCREMENT
    , tax_type CHAR(3)
    , tax_beg DATE
    , tax_end DATE
    , tax_perc DECIMAL(4,2)
    , user_id INT NOT NULL DEFAULT 2
    , date_mod DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
    , active BIT NOT NULL DEFAULT 1
    , PRIMARY KEY (tax_id)
    );

TRUNCATE TABLE tax;
INSERT INTO tax (tax_type, tax_beg, tax_end, tax_perc)
VALUES          ('GST', '2017-02-12', NULL, 5.00)
                , ('PST', '2016-02-16', NULL, 7.00);
SELECT t.tax_id, t.tax_type, t.tax_beg, t.tax_end, t.tax_perc
        , t.user_id, t.date_mod, t.active
FROM tax t;

-- gst and pst part
DROP VIEW IF EXISTS gst;
CREATE VIEW gst AS (
	SELECT ROUND(tax_perc/100,2) AS tax_rate
		, CONCAT(tax_type, ' (',TRUNCATE(tax_perc,0),'%)') AS label
	FROM tax WHERE tax_type='GST'
);

DROP VIEW IF EXISTS pst;
CREATE VIEW pst AS (
	SELECT ROUND(tax_perc/100,2) AS tax_rate
		, CONCAT(tax_type, ' (',TRUNCATE(tax_perc,0),'%)') AS label
	FROM tax WHERE tax_type='pST'
);

SELECT * FROM gst,pst;

DROP VIEW IF EXISTS taxes;
CREATE VIEW taxes AS(
	SELECT gst.tax_rate AS gst_tax_rate, gst.label AS gst_label
		 , pst.tax_rate AS pst_tax_rate, pst.label AS pst_label
	FROM gst,pst
);
-- ---------------



-- TABLE: orders(o) --------------------------------------------------
-- Drop constraint for table "orders__item"
-- ALTER TABLE IF EXISTS orders__item DROP CONSTRAINT IF EXISTS orders_order_FK;

-- Drop constraint for table "orders_transactions"
-- ALTER TABLE IF EXISTS orders_transactions DROP CONSTRAINT IF EXISTS ot_order_FK;

DROP TABLE IF EXISTS orders;
CREATE TABLE IF NOT EXISTS orders(
    order_id INT AUTO_INCREMENT
    , order_num VARCHAR(15) NOT NULL UNIQUE 
    , order_date DATETIME
    , order_credit DECIMAL(7,2)
    , order_cr_uom CHAR(1)
    , order_override DECIMAL(7,2)
    , order_amt_tnd DECIMAL(7,2)
    , order_type VARCHAR (10)
    , order_notes VARCHAR (191)
    , p_id_cust INT
    , p_id_emp INT NOT NULL
    , user_id INT NOT NULL DEFAULT 2
    , date_mod DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
    , active BIT NOT NULL DEFAULT 1
    , CONSTRAINT orders_PK PRIMARY KEY (order_id)
    , CONSTRAINT orders_UK UNIQUE (order_date, p_id_cust)
    , CONSTRAINT orders_P_cust_FK FOREIGN KEY (p_id_cust) REFERENCES people(p_id)
    , CONSTRAINT orders_p_emp_FK FOREIGN KEY (p_id_emp) REFERENCES people(p_id)
);

TRUNCATE TABLE orders;
INSERT INTO orders(order_num, order_date, order_credit, order_cr_uom
                    , order_override, order_type, p_id_cust, p_id_emp
                    , order_notes)
VALUES             ('000000000000001','2023-03-12 11:00:32', 10, '%'
                    , 0.00, 'online', 3, 2
                    , 'Final Sale');
SELECT o.order_id, o.order_num, o.order_date, o.order_credit, o.order_cr_uom
        , o.order_override, o.order_type, o.p_id_cust, o.p_id_emp, o.order_notes
        , o.user_id, o.date_mod, o.active
FROM orders o;

-- taxes includes pst and gst
SELECT * FROM taxes;

SELECT  o.order_id, o.order_date, o.order_num, o.order_type, o.p_id_cust, o.p_id_emp
      , o.order_credit, o.order_cr_uom, o.order_override, o.order_notes
FROM orders o;


    
-- TABLE: orders__item (oi) ------------------------------------------

DROP TABLE IF EXISTS orders__item;
CREATE TABLE IF NOT EXISTS orders__item (
    oi_id BIGINT AUTO_INCREMENT
    , order_id INT
    , item_id INT
    , oi_qty SMALLINT
    , oi_status VARCHAR(25)
    , oi_override DECIMAL(9,2)
    , user_id INT NOT NULL DEFAULT 2
    , date_mod DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
    , active BIT NOT NULL DEFAULT 1
    , PRIMARY KEY (oi_id)
    , CONSTRAINT oi_UK UNIQUE (order_id, item_id)
    , CONSTRAINT orders_order_FK FOREIGN KEY (order_id) REFERENCES orders(order_id)
    , CONSTRAINT orders_item_FK FOREIGN KEY (item_id) REFERENCES item(item_id)
    );

TRUNCATE TABLE orders__item;
INSERT INTO orders__item (order_id, item_id, oi_qty, oi_status, oi_override)
VALUES                   (1, 1, 1, 'Available', NULL);

SELECT oi.oi_id, oi.order_id, oi.item_id
       , oi.oi_status, oi.oi_qty, oi.oi_override
       , oi.user_id, oi.date_mod, oi.active
FROM orders__item oi;


-- REBUILD into using orders.order_date
-- ready to be attached to the orders and orders_item
SELECT fake.order_date, i.item_id, i.item_name, i.item_price
   	 , MAX(ip.ip_price) AS ip_price_reg
   	 , CASE WHEN MIN(ip.ip_price)=MAX(ip.ip_price) THEN NULL ELSE MIN(ip.ip_price) END AS ip_price_sal
FROM item i
	JOIN item_price ip ON i.item_id = ip.item_id
	, (SELECT '2023-03-25 11:00:00.000' AS order_date) fake
WHERE fake.order_date BETWEEN ip.ip_beg AND IFNULL(ip.ip_end, fake.order_date)
GROUP BY fake.order_date, i.item_id, i.item_name, i.item_price;

SELECT oi.order_id, oi.item_id, oi.oi_qty, oi.oi_override, oi.oi_status
	 , o.order_id, o.order_date 
     , o.order_credit, o.order_cr_uom, o.order_override
FROM orders__item oi
	JOIN orders o ON oi.order_id = o.order_id;

SELECT  o.order_id, o.order_date -- , o.order_num, o.order_type, o.p_id_cust, o.p_id_emp, o.order_notes
      , o.order_credit, o.order_cr_uom, o.order_override
FROM orders o;

UPDATE orders SET order_date='2023-03-28 11:00:32' WHERE order_id=1;
SELECT * FROM orders;

DROP VIEW IF EXISTS orders__items__receipt_items;
CREATE VIEW orders__items__receipt_items AS (
	SELECT order_id, order_date, item_id, item_name,item_price, oi_override
	   	 , IFNULL(order_override,IFNULL(ip_price_sal,ip_price_reg)) AS ip_price
	   	 , oi_qty
	   	 , IFNULL(order_override,IFNULL(ip_price_sal,ip_price_reg)) * oi_qty AS ip_price_tot
	   	 , oi_status
	   	 -- , SUM(IFNULL(order_override,IFNULL(ip_price_sal,ip_price_reg)) * oi_qty) AS subtotal
		 , order_credit, order_cr_uom, order_override
		 , order_num, order_type, p_id_cust, p_id_emp, order_notes
	-- REBUILD into using orders.order_date
	-- attaching to  orders and orders_item tables
	FROM(
		SELECT o.order_date, i.item_id, i.item_name, i.item_price
		   	 , MAX(ip.ip_price) AS ip_price_reg
		   	 , CASE WHEN MIN(ip.ip_price)=MAX(ip.ip_price) THEN NULL ELSE MIN(ip.ip_price) END AS ip_price_sal
		   	 , oi.oi_qty, oi.oi_override, oi.oi_status
			 , o.order_id, o.order_credit, o.order_cr_uom, o.order_override
			 , o.order_num, o.order_type, o.p_id_cust, o.P_id_emp, o.order_notes
		FROM item i
			JOIN item_price ip ON i.item_id = ip.item_id
			JOIN orders__item oi ON i.item_id = oi.item_id
			JOIN orders o ON oi.order_id = o.order_id
		WHERE o.order_date BETWEEN ip.ip_beg AND IFNULL(ip.ip_end, o.order_date)
		GROUP BY o.order_id, o.order_date, i.item_id, i.item_name, i.item_price
			   , oi.oi_qty, oi.oi_override, oi.oi_status, oi.order_id, oi.item_id
			   , o.order_credit, o.order_cr_uom, o.order_override
			   , o.order_num, o.order_type, o.p_id_cust, o.p_id_emp, o.order_notes
	) x
);

SELECT * 
FROM orders__items__receipt_items;

SELECT SUM(ip_price_tot) AS subtotal
FROM orders__items__receipt_items;

SELECT order_id, order_date
	 , SUM(ip_price_tot) AS subtotal
	 , order_credit, order_cr_uom, order_override
	 , order_num, order_type, p_id_cust, p_id_emp, order_notes
FROM orders__items__receipt_items
GROUP BY order_id, order_date;
 

DROP VIEW IF EXISTS orders__items__receipt_items_FINAL;
CREATE VIEW orders__items__receipt_items_FINAL AS (
SELECT order_id, order_date, order_credit, order_cr_uom, order_override
	 , order_num, order_type, p_id_cust, p_id_emp, order_notes
	 , CONCAT(p_c.first_name,' ', p_c.last_name) as customer
	 , CONCAT(p_c.first_name,' ', p_c.last_name) as employee
	 , subtotal
	 , gst_label, ROUND(subtotal*gst_tax_rate,2) AS gst_subtotal
	 , pst_label, ROUND(subtotal*pst_tax_rate,2) AS pst_subtotal
	 , ROUND(subtotal*(1+gst_tax_rate+pst_tax_rate),2) AS grandtotal
FROM (
	SELECT order_id, order_date
	 	 , SUM(ip_price_tot) AS subtotal
		 , order_credit, order_cr_uom, order_override
		 , order_num, order_type, p_id_cust, p_id_emp, order_notes
	FROM orders__items__receipt_items
	)ois
	JOIN people p_c ON ois.p_id_cust = p_c.p_id
	JOIN people p_e ON ois.p_id_cust = p_e.p_id
    ,taxes
    
 );

SELECT *
FROM orders__items__receipt_items_FINAL
GROUP BY order_id, order_date;
   

-- TABLE: transaction (t) -------------------------------------------
ALTER TABLE IF EXISTS orders_transactions DROP CONSTRAINT IF EXISTS ot_transactions_FK;

DROP TABLE IF EXISTS transactions;
CREATE TABLE IF NOT EXISTS transactions(
    t_id BIGINT AUTO_INCREMENT
    , t_num CHAR(15)
    , t_mid CHAR(3)
    , t_acct BIGINT
    , t_date DATETIME DEFAULT CURRENT_TIMESTAMP
    , t_type VARCHAR(15)
    , t_amount decimal(8,2)
    , t_cr_dr CHAR(2)
    , t_status VARCHAR(10)
    , user_id INT NOT NULL DEFAULT 2
    , date_mod DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
    , active BIT NOT NULL DEFAULT 1
    , PRIMARY KEY (t_id)
    , CONSTRAINT transactions_UK UNIQUE (t_num)
    );
    
TRUNCATE TABLE transactions;
INSERT INTO transactions (t_num, t_mid, t_acct, t_type
                         , t_date, t_amount, t_cr_dr)
VALUES                  ('123456789012345', 001, 1234432112344321, 'Mastercard'
                        ,'2022-02-12', 999.99, 'CR');
        
SELECT t.t_id, t.t_num, t.t_mid , t.t_mid, t.t_acct, t.t_type
       , t.t_date, t.t_amount, t.t_cr_dr
       , t.user_id, t.date_mod, t.active
FROM transactions t;

-- TABLE: order_transactions (ot) -----------------------------------

DROP TABLE IF EXISTS orders_transactions;
CREATE TABLE IF NOT EXISTS orders_transactions (
    ot_id BIGINT auto_increment
    , order_id INT -- FK
    , t_id BIGINT NOT NULL -- FK
    , p_id_cust INT NOT NULL -- FK
    , user_id INT NOT NULL DEFAULT 2 -- FK
    , date_mod DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
    , active BIT NOT NULL DEFAULT 1
    , PRIMARY KEY (ot_id)
    , CONSTRAINT ot_UK UNIQUE (order_id, t_id, p_id_cust)
    , CONSTRAINT ot_order_FK FOREIGN KEY (order_id) REFERENCES orders(order_id)
    , CONSTRAINT ot_transactions_FK FOREIGN KEY (t_id) REFERENCES transactions(t_id)
    , CONSTRAINT ot_p_cust_FK FOREIGN KEY (p_id_cust) REFERENCES people(p_id)
    );

TRUNCATE TABLE orders_transactions;
INSERT INTO orders_transactions (order_id, t_id, p_id_cust)
VALUES                          (1,1,3);

SELECT ot_id, order_id, t_id, p_id_cust, user_id, date_mod
FROM orders_transactions ot;









   
-- geo_country INSERTS ----------------------------------------------
-- TRUNCATE TABLE geo_country;
-- INSERT INTO geo_country (c_name, c_code) VALUES ('Canada', 'CA');                           -- 1
INSERT INTO geo_country (c_id, c_name, c_code) VALUES (10,'Japan', 'JP');                      -- 10
INSERT INTO geo_country (c_id, c_name, c_code) VALUES (11,'South Korea', 'KR');                -- 11
INSERT INTO geo_country (c_id, c_name, c_code) VALUES (12,'United States of America', 'US');   -- 12

-- geo_region INSERTS -----------------------------------------------
-- TRUNCATE TABLE geo_region;
-- INSERT INTO geo_region (r_name, r_code, c_id) VALUES ('Manitoba', 'MB', 1);            -- 1,1
INSERT INTO geo_region (r_id, r_name, r_code, c_id) VALUES (10, 'Tokyo', NULL, 10);           -- 10,10
INSERT INTO geo_region (r_id, r_name, r_code, c_id) VALUES (11, 'Osaka', NULL, 10);           -- 11,10
INSERT INTO geo_region (r_id, r_name, r_code, c_id) VALUES (12, 'Gyeonggi', NULL, 11);        -- 12,11
INSERT INTO geo_region (r_id, r_name, r_code, c_id) VALUES (13, 'California', 'CA', 12);      -- 13,12
INSERT INTO geo_region (r_id, r_name, r_code, c_id) VALUES (14, 'Texas', 'TX', 12);           -- 14,12
INSERT INTO geo_region (r_id, r_name, r_code, c_id) VALUES (15, 'Washington', 'WA', 12);      -- 15,12


-- geo_towncity INSERTS ---------------------------------------------
-- TRUNCATE TABLE geo_towncity;
-- INSERT INTO geo_towncity (tc_name, r_id) VALUES ('Winnipeg', 1);               -- 1,1,1
INSERT INTO geo_towncity (tc_id, tc_name, r_id) VALUES (10, 'Chiyoda', 10);              -- 10,10,10
INSERT INTO geo_towncity (tc_id, tc_name, r_id) VALUES (11, 'Minato', 10);               -- 11,10,10
INSERT INTO geo_towncity (tc_id, tc_name, r_id) VALUES (12, 'Kadoma', 11);               -- 12,11,10
INSERT INTO geo_towncity (tc_id, tc_name, r_id) VALUES (13, 'Suwon', 12);                -- 13,12,11
INSERT INTO geo_towncity (tc_id, tc_name, r_id) VALUES (14, 'Seoul', 12);                -- 14,12,11
INSERT INTO geo_towncity (tc_id, tc_name, r_id) VALUES (15, 'Lost Altos', 13);           -- 15,13,12
INSERT INTO geo_towncity (tc_id, tc_name, r_id) VALUES (16, 'Santa Clara', 13);          -- 16,13,12
INSERT INTO geo_towncity (tc_id, tc_name, r_id) VALUES (17, 'Round Rock', 14);           -- 17,14,12
INSERT INTO geo_towncity (tc_id, tc_name, r_id) VALUES (18, 'Redmond', 15);              -- 18,15,12   
   
SELECT gtc.tc_id, gtc.tc_name, gtc.r_id
     , gr.r_id, gr.r_name, gr.r_code, gr.c_id
   , gc.c_id, gc.c_name, gc.c_code
FROM geo_towncity gtc
   JOIN geo_region gr ON gtc.r_id=gr.r_id
   JOIN geo_country gc ON gr.c_id=gc.c_id;
  
  
  
  
-- manufacturer INSERTS ---------------------------------------------
-- TRUNCATE TABLE manufacturer;
-- INSERT INTO manufacturer (man_name, p_id_man
--            , phone_pri, phone_sales, phone_sup, phone_fax
--            , addr, addr_code, addr_info, addr_type_id, tc_id)
-- VALUES                   ('Acme Co.', 3
--            , '222-222-2222', '333-333-3333', '444-444-4444', '555-555-5555'
--            , '3 Road Runner Way', 'R1R 2W3', NULL, 3, 1);
INSERT INTO manufacturer (man_id, man_name, addr, addr_info, addr_type_id, tc_id)
VALUES (10 ,'Apple Inc.'         ,'260-17 First St','PO Box: 26017',3,15)
      ,(11 ,'Samsung Electronics','221-6 Second St','PO Box: 24355',3,13)
      ,(12 ,'Dell Technologies'  ,'90-62 Third St' ,'PO Box: 26517',3,17)
      ,(13 ,'Hitachi'            ,'88-42 Fourth St','PO Box: 26054',3,10)
      ,(14 ,'Sony'               ,'80-92 Fifth St' ,'PO Box: 46017',3,11)
      ,(15 ,'Panasonic'          ,'74-73 Sixth St' ,'PO Box: 49587',3,12)
      ,(16 ,'Intel'              ,'71-9 Seventh St','PO Box: 29234',3,16)
      ,(17 ,'LG Electronics'     ,'54-39 Eighth St','PO Box: 98234',3,14)
      ,(18 ,'Microsoft'          ,'100-10 Ninth St','PO Box: 98245',3,18)
;


SELECT man.man_id, man.man_name
   , man.p_id_man
   , man.addr_type_id
   , man.tc_id
   , gat.addr_type_id, gat.addr_type
   , gtc.tc_id, gtc.tc_name
   , gr.r_id, gr.r_name
   , gc.c_id, gc.c_name
FROM manufacturer man
     JOIN geo_address_type gat  ON man.addr_type_id=gat.addr_type_id
     JOIN geo_towncity gtc ON man.tc_id=gtc.tc_id
     JOIN geo_region gr     ON gtc.r_id=gr.r_id
     JOIN geo_country gc    ON gr.c_id=gc.c_id
;
   

  
-- category INSERTS -------------------------------------------------
ALTER TABLE IF EXISTS category__people DROP CONSTRAINT IF EXISTS cp_category_FK ;
ALTER TABLE IF EXISTS category__people DROP CONSTRAINT IF EXISTS cp_pe_FK;
TRUNCATE TABLE category;

-- people INSERTS --
INSERT INTO category (cat_name, cat_id_parent, cat_uri, cat_abbr, taxonomy)
VALUES               ('Staff', NULL, 'staff', NULL, 'departments');         -- 1

INSERT INTO category (cat_name, cat_id_parent, cat_uri, cat_abbr, taxonomy)
VALUES               ('Sales', 1, 'sales', NULL, 'departments');            -- 2

INSERT INTO category (cat_name, cat_id_parent, cat_uri, cat_abbr, taxonomy)
VALUES               ('Warehouse', 1, 'warehouse', NULL, 'departments');    -- 3


TRUNCATE TABLE category__people;
INSERT INTO category__people (cat_id, pe_id)
VALUES                       (2, 2),(3, 1);

SELECT cp.cp_id, cp.cat_id, cp.pe_id
   , cp.user_id, cp.date_mod, cp.active
FROM category__people cp;

-- join verify
SELECT cat.cat_id, cat.cat_name, cat.taxonomy, cat.cat_uri
   , cp.cat_id, cp.pe_id             -- , cp.cp_id
   , pe.pe_id, pe.pe_uri, pe.p_id    -- , pe.p_id_mgr
   , p.p_id, p.first_name, p.last_name
FROM category cat
   JOIN category__people cp ON cat.cat_id=cp.cat_id
   JOIN people_employee pe ON cp.pe_id=pe.pe_id
   JOIN people p  ON pe.p_id=p.p_id
WHERE cat.taxonomy='departments';

-- site urls
SELECT cat.cat_id, cp.cat_id, cp.pe_id, p.p_id
   , CONCAT('https://boxstore.com/',cat.taxonomy,'/',cat.cat_uri,'/',pe.pe_uri,'/') AS dept_permalink
   , CONCAT('https://boxstore.com/staff/',pe.pe_uri,'/') AS emp_permalink
FROM category cat
   JOIN category__people cp ON cat.cat_id=cp.cat_id
   JOIN people_employee pe ON cp.pe_id=pe.pe_id
   JOIN people p  ON pe.p_id=p.p_id
WHERE cat.taxonomy='departments';


-- item INSERTS --
INSERT INTO category (cat_name, cat_id_parent, cat_uri, cat_abbr, taxonomy)
VALUES  ('Televisions', NULL,'televisions', 'TV', 'general')          -- 4
      , ('Portable Electronics', NULL,'portable-electronics', 'PE', 'general')  -- 5
      , ('Kitchen Appliances', NULL,'kitchen-appliances', 'KA', 'general')    -- 6
      , ('Large Appliances', NULL,'large-appliances', 'LA', 'general');     -- 7

    
INSERT INTO category (cat_name, cat_id_parent, cat_uri, cat_abbr, taxonomy)
VALUES   ('70" & Up',4,'70-up',NULL,'general')                  -- 8
       , ('60" - 69"',4,'60-69',NULL,'general')                 -- 9
       , ('55" & Down',4,'55-down',NULL,'general')                -- 10
       , ('Smartphones',5,'smartphones',NULL,'general')             -- 11
       , ('Tablets',5,'tablets',NULL,'general')                 -- 12
       , ('Blender',6,'blender',NULL,'general')                 -- 13
       , ('Coffee & Tea',6,'coffee-tea',NULL,'general')             -- 14
       , ('Washer',7,'washer',NULL,'general')                 -- 15
       , ('Dryer',7,'dryer',NULL,'general');                  -- 16   

-- not working 
-- ------------------------------------------------------------------
SELECT cat.cat_id, cp.cat_id, cp.pe_id, p.p_id
   , CONCAT('https://boxstore.com/',cat.taxonomy,'/',cat.cat_uri,'/',pe.pe_uri,'/') AS dept_permalink
   , CONCAT('https://boxstore.com/staff/',pe.pe_uri,'/') AS emp_permalink
FROM category cat
   JOIN category__people cp ON cat.cat_id=cp.cat_id
   JOIN people_employee pe ON cp.pe_id=pe.pe_id
   JOIN people p  ON pe.p_id=p.p_id
WHERE cat.taxonomy='general';
-- 


DROP TABLE IF EXISTS `z__orders_items_csv`;

CREATE TABLE `z__orders_items_csv` (
  `man_id` INT(11) DEFAULT NULL,
  `order_num` INT(11) DEFAULT NULL,
  `order_date` DATE DEFAULT NULL,
  `item_type` VARCHAR(8) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `item_modelno` VARCHAR(16) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `item_barcode` INT(11) DEFAULT NULL,
  `cat_name` VARCHAR(16) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `cat_id` INT(11) DEFAULT NULL,
  `item_name_new` VARCHAR(32) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `order_qty` INT(11) DEFAULT NULL,
  `item_price` DECIMAL(7,2) DEFAULT NULL,
  `extra` VARCHAR(8) COLLATE utf8mb4_unicode_ci DEFAULT NULL
) ENGINE=INNODB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT  INTO `z__orders_items_csv`(`man_id`,`order_num`,`order_date`,`item_type`,`item_modelno`,`item_barcode`,`cat_name`,`cat_id`,`item_name_new`,`order_qty`,`item_price`,`extra`) VALUES 
(6,1160,'2021-05-18','product','6PRI0299999203',99999203,'55\" & Down',10,'50\" HDTV',3,2100.00,'6PRI02'),
(10,1026,'2021-01-13','product','2BRE1100066001',66001,'55\" & Down',10,'50\" HDTV',2,2100.00,'2BRE11'),
(10,1057,'2021-01-18','product','2BRE1000056014',56014,'55\" & Down',10,'50\" HDTV',2,2605.00,'2BRE10'),
(4,1091,'2021-02-17','product','3FPT0100051287',51287,'60\" - 69\"',9,'65\" HDTV',4,6065.33,'3FPT01'),
(4,1091,'2021-02-17','product','3FPT0100051281',51281,'60\" - 69\"',9,'65\" HDTV',1,6665.33,'3FPT01'),
(4,1091,'2021-02-17','product','3FPT0100051286',51286,'60\" - 69\"',9,'65\" HDTV',1,6665.33,'3FPT01'),
(5,1060,'2021-01-18','product','6LID0100051166',51166,'60\" - 69\"',9,'65\" HDTV',2,5502.67,'6LID01'),
(9,1174,'2021-05-19','product','2SUR1100056001',56001,'60\" - 69\"',9,'65\" HDTV',3,5000.00,'2SUR11'),
(6,1160,'2021-05-18','product','6PRI0299999197',99999197,'70\" & Up',8,'75\" HDTV',2,20013.33,'6PRI02'),
(6,1160,'2021-05-18','product','6PRI0299999198',99999198,'70\" & Up',8,'75\" HDTV',2,20013.33,'6PRI02'),
(4,1044,'2021-01-18','product','3SKY0111164009',11164009,'Blender',13,'20 ounce Blender',3,69.53,'3SKY01'),
(4,1044,'2021-01-18','product','3SKY0142542001',42542001,'Blender',13,'20 ounce Blender',3,89.41,'3SKY01'),
(5,1021,'2021-01-13','product','4MAR0120815001',20815001,'Blender',13,'20 ounce Blender',3,54.35,'4MAR01'),
(6,1254,'2022-01-28','product','4SOD0100001009',1009,'Blender',13,'20 ounce Blender',5,89.00,'4SOD01'),
(8,1040,'2021-01-18','product','2SUR1108413009',8413009,'Blender',13,'20 ounce Blender',3,50.75,'2SUR11'),
(1,1003,'2021-01-13','product','1GQD0200001006',1006,'Coffee & Tea',14,'Barista Express',2,100.00,'1GQD02'),
(1,1180,'2021-05-20','product','1GQD0200001006',1006,'Coffee & Tea',14,'Barista Express',1,100.00,'1GQD02'),
(1,1239,'2021-01-13','product','1GQD0200001006',1006,'Coffee & Tea',14,'Barista Express',1,100.00,'1GQD02'),
(1,1030,'2021-01-13','product','1GQD0200001012',1012,'Coffee & Tea',14,'Barista Express',1,133.17,'1GQD02'),
(2,1173,'2021-05-18','product','7BOC0244563001',44563001,'Coffee & Tea',14,'Barista Express',4,199.80,'7BOC02'),
(3,1151,'2021-04-28','product','3BRI0300001012',1012,'Coffee & Tea',14,'Barista Express',3,133.17,'3BRI03'),
(5,1195,'2021-05-24','product','4HEL0141994001',41994001,'Coffee & Tea',14,'Barista Express',3,124.38,'4HEL01'),
(5,1054,'2021-01-18','product','4HEL0140182001',40182001,'Coffee & Tea',14,'Barista Express',3,172.63,'4HEL01'),
(7,1031,'2021-01-14','product','7SPP0105618009',5618009,'Coffee & Tea',14,'Barista Express',4,199.80,'7SPP01'),
(8,1040,'2021-01-18','product','2SUR1103820009',3820009,'Coffee & Tea',14,'Barista Express',1,104.50,'2SUR11'),
(8,1040,'2021-01-18','product','2SUR1115323121',15323121,'Coffee & Tea',14,'Barista Express',1,144.18,'2SUR11'),
(8,1040,'2021-01-18','product','2SUR1115384001',15384001,'Coffee & Tea',14,'Barista Express',3,152.74,'2SUR11'),
(8,1040,'2021-01-18','product','2SUR1115199001',15199001,'Coffee & Tea',14,'Barista Express',3,174.05,'2SUR11'),
(8,1040,'2021-01-18','product','2SUR1104929009',4929009,'Coffee & Tea',14,'Barista Express',2,184.80,'2SUR11'),
(8,1040,'2021-01-18','product','2SUR1108718009',8718009,'Coffee & Tea',14,'Barista Express',3,189.61,'2SUR11'),
(8,1040,'2021-01-18','product','2SUR1108255009',8255009,'Coffee & Tea',14,'Barista Express',3,196.60,'2SUR11'),
(5,1049,'2021-01-18','product','7HAN0200008359',8359,'Dryer',16,'Dryer',1,710.00,'7HAN02'),
(5,1117,'2021-03-04','product','7HYU0200008359',8359,'Dryer',16,'Dryer',1,710.00,'7HYU02'),
(5,1119,'2021-03-04','product','7SMS0100008359',8359,'Dryer',16,'Dryer',1,710.00,'7SMS01'),
(5,1228,'2021-01-15','product','7SPP0100008359',8359,'Dryer',16,'Dryer',1,710.00,'7SPP01'),
(7,1229,'2021-02-23','product','7SPP0100041409',41409,'Dryer',16,'Dryer',4,716.67,'7SPP01'),
(10,1225,'2020-01-28','product','2BRE1500012590',12590,'Dryer',16,'Dryer',2,666.67,'2BRE15'),
(10,1225,'2020-01-28','product','2BRE1400012576',12576,'Dryer',16,'Dryer',2,783.33,'2BRE14'),
(1,1120,'2021-03-04','product','1GQD0240880001',40880001,'Smartphones',11,'Actually a Flipper',5,238.06,'1GQD02'),
(2,1173,'2021-05-18','product','7BOC0200002293',2293,'Smartphones',11,'Actually a Flipper',3,207.79,'7BOC02'),
(2,1168,'2021-05-18','product','4DAI0200002260',2260,'Smartphones',11,'Actually a Flipper',3,264.74,'4DAI02'),
(3,1137,'2021-04-06','product','3BRI0400002124',2124,'Smartphones',11,'Not-as Smartphone',3,358.74,'3BRI04'),
(3,1046,'2021-01-18','product','7DAE0400012490',12490,'Smartphones',11,'Really Smartphone',4,1250.00,'7DAE04'),
(4,1048,'2021-01-18','product','3TEC0350864001',50864001,'Smartphones',11,'Really Smartphone',1,1090.91,'3TEC03'),
(5,1054,'2021-01-18','product','4HEL0140184001',40184001,'Smartphones',11,'Actually a Flipper',5,226.07,'4HEL01'),
(5,1049,'2021-01-18','product','7HAN0200013563',13563,'Smartphones',11,'Really Smartphone',2,1170.00,'7HAN02'),
(6,1254,'2022-01-28','product','4SOD0100001011',1011,'Smartphones',11,'Actually a Flipper',2,299.70,'4SOD01'),
(6,1160,'2021-05-18','product','6PRI0299999177',99999177,'Smartphones',11,'Not-as Smartphone',3,332.97,'6PRI02'),
(6,1160,'2021-05-18','product','6PRI0299999178',99999178,'Smartphones',11,'Really Smartphone',2,1333.33,'6PRI02'),
(7,1031,'2021-01-14','product','7SPP0120983041',20983041,'Smartphones',11,'Not-as Smartphone',4,332.97,'7SPP01'),
(7,1031,'2021-01-14','product','7SPP0120983081',20983081,'Smartphones',11,'Not-as Smartphone',1,332.97,'7SPP01'),
(8,1040,'2021-01-18','product','2SUR1106484009',6484009,'Smartphones',11,'Not-as Smartphone',3,321.23,'2SUR11'),
(8,1201,'2021-05-24','product','2SUR1199999114',99999114,'Smartphones',11,'Not-as Smartphone',1,363.64,'2SUR11'),
(8,1043,'2021-01-18','product','2SUR1101100321',1100321,'Smartphones',11,'Really Smartphone',3,1272.00,'2SUR11'),
(8,1178,'2021-05-20','product','2SUR1101100321',1100321,'Smartphones',11,'Really Smartphone',4,1272.00,'2SUR11'),
(9,1114,'2021-03-08','product','2SUR1100002124',2124,'Smartphones',11,'Not-as Smartphone',3,358.74,'2SUR11'),
(9,1042,'2021-01-18','product','2SUR1151463001',51463001,'Smartphones',11,'Really Smartphone',1,1040.00,'2SUR11'),
(9,1111,'2021-02-26','product','2SUR1100041398',41398,'Smartphones',11,'Really Smartphone',5,1200.00,'2SUR11'),
(10,1089,'2021-02-24','product','2BRE1200002124',2124,'Smartphones',11,'Not-as Smartphone',3,358.74,'2BRE12'),
(10,1242,'2021-06-09','product','2BRE1600013212',13212,'Smartphones',11,'Really Smartphone',3,1000.00,'2BRE16'),
(10,1033,'2021-01-14','product','2BRE0100008427',8427,'Smartphones',11,'Really Smartphone',1,1010.00,'2BRE01'),
(10,1036,'2021-01-18','product','2BRE0200008427',8427,'Smartphones',11,'Really Smartphone',1,1010.00,'2BRE02'),
(10,1225,'2020-01-28','product','2BRE1300008427',8427,'Smartphones',11,'Really Smartphone',1,1010.00,'2BRE13'),
(10,1058,'2021-01-18','product','2BRE0600013628',13628,'Smartphones',11,'Really Smartphone',3,1350.00,'2BRE06'),
(10,1157,'2021-05-17','product','2BRE0700013628',13628,'Smartphones',11,'Really Smartphone',5,1350.00,'2BRE07'),
(10,1177,'2021-05-20','product','2BRE0900013628',13628,'Smartphones',11,'Really Smartphone',3,1350.00,'2BRE09'),
(1,1046,'2021-01-18','product','1GQD0200008335',8335,'Tablets',12,'Super Tablet',4,1435.00,'1GQD02'),
(1,1090,'2021-02-24','product','3ADA0100008360',8360,'Tablets',12,'Super Tablet',4,2000.00,'3ADA01'),
(2,1170,'2021-05-18','product','4DAI0200002136',2136,'Tablets',12,'Mini Tablet',3,374.63,'4DAI02'),
(2,1211,'2021-05-26','product','4DAI0200002136',2136,'Tablets',12,'Mini Tablet',3,374.63,'4DAI02'),
(2,1171,'2021-05-18','product','4DAI0200002123',2123,'Tablets',12,'Mini Tablet',3,424.58,'4DAI02'),
(3,1169,'2021-05-18','product','3BRI0400002136',2136,'Tablets',12,'Mini Tablet',3,374.63,'3BRI04'),
(3,1111,'2021-02-26','product','7DAE0400008335',8335,'Tablets',12,'Super Tablet',1,1435.00,'7DAE04'),
(4,1105,'2021-02-26','product','3OCE0108211010',8211010,'Tablets',12,'Mini Tablet',3,499.50,'3OCE01'),
(4,1182,'2021-05-20','product','7UNI0400008355',8355,'Tablets',12,'Super Tablet',5,1435.00,'7UNI04'),
(5,1054,'2021-01-18','product','4HEL0105850009',5850009,'Tablets',12,'Mini Tablet',2,448.25,'4HEL01'),
(5,1031,'2021-01-14','product','7HYU0200041406',41406,'Tablets',12,'Super Tablet',4,1500.00,'7HYU02'),
(6,1052,'2021-01-18','product','7SAK0100008355',8355,'Tablets',12,'Super Tablet',3,1435.00,'7SAK01'),
(6,1117,'2021-03-04','product','7SMS0100041406',41406,'Tablets',12,'Super Tablet',4,1500.00,'7SMS01'),
(7,1119,'2021-03-04','product','7SPP0100041406',41406,'Tablets',12,'Super Tablet',4,1500.00,'7SPP01'),
(7,1228,'2021-01-15','product','7SPP0100041406',41406,'Tablets',12,'Super Tablet',4,1500.00,'7SPP01'),
(8,1150,'2021-04-27','product','2SUR1100008294',8294,'Tablets',12,'Super Tablet',3,1414.11,'2SUR11'),
(9,1102,'2021-02-26','product','2SUR1100002136',2136,'Tablets',12,'Mini Tablet',3,374.63,'2SUR11'),
(9,1107,'2021-03-05','product','2SUR1100002136',2136,'Tablets',12,'Mini Tablet',3,374.63,'2SUR11'),
(9,1102,'2021-02-26','product','2SUR1100002137',2137,'Tablets',12,'Mini Tablet',3,394.61,'2SUR11'),
(9,1107,'2021-03-05','product','2SUR1100002137',2137,'Tablets',12,'Mini Tablet',3,394.61,'2SUR11'),
(9,1102,'2021-02-26','product','2SUR1100002143',2143,'Tablets',12,'Mini Tablet',3,419.58,'2SUR11'),
(9,1107,'2021-03-05','product','2SUR1100002143',2143,'Tablets',12,'Mini Tablet',3,419.58,'2SUR11'),
(9,1064,'2021-01-19','product','2SUR1100008335',8335,'Tablets',12,'Super Tablet',5,1435.00,'2SUR11'),
(9,1056,'2021-01-18','product','2SUR1100011577',11577,'Tablets',12,'Super Tablet',1,1842.00,'2SUR11'),
(10,1056,'2021-01-18','product','2SUR1100041491',41491,'Tablets',12,'Super Tablet',1,1991.00,'2SUR11'),
(1,1090,'2021-02-24','product','3ADA0100004335',4335,'Washer',15,'Washer',5,500.00,'3ADA01'),
(3,1034,'2021-01-14','product','3BRI3505804084',5804084,'Washer',15,'Washer',3,504.69,'3BRI35'),
(3,1051,'2021-01-18','product','3DAE0106096009',6096009,'Washer',15,'Washer',3,553.95,'3DAE01');

UPDATE z__orders_items_csv
SET man_id=man_id+8
WHERE man_id<>1;




-- item ----------------------------------
ALTER TABLE item DROP CONSTRAINT item_UK;


INSERT INTO item  (item_type, item_name, item_modelno, item_barcode
                  , item_uri, item_size, item_uom, item_price
                  , man_id)
SELECT 'Available', CONCAT(man.man_name,' - ',item_name_new), item_modelno, item_barcode
       , NULL, 1, 'Unit', MAX(item_price)
       , z.man_id
FROM z__orders_items_csv z 
     JOIN manufacturer man ON z.man_id=man.man_id
GROUP BY CONCAT(man.man_name,' - ',item_name_new), item_modelno, item_barcode, z.man_id;



INSERT INTO item_price (ip_beg, ip_end, item_id, ip_price)
SELECT                  '2022-01-05 00:00:00', NULL, i.item_id, i.item_price
FROM item i
     LEFT JOIN item_price ip    ON i.item_id = ip.item_id
WHERE ip.ip_id IS NULL;



-- item__category ----------------------------------

DROP TABLE IF EXISTS item__category;
CREATE TABLE IF NOT EXISTS item__category (
    ic_id BIGINT AUTO_INCREMENT
  , item_id BIGINT -- FK
  , cat_id MEDIUMINT -- FK
  , user_id INT NOT NULL DEFAULT 2 -- FK
  , date_mod DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
  , active BIT NOT NULL DEFAULT 1
  , PRIMARY KEY(ic_id)
);

TRUNCATE TABLE item__category;
INSERT INTO item__category (item_id, cat_id)
VALUES                    (1, 14);

INSERT INTO item__category (item_id, cat_id)
SELECT i.item_id, z.cat_id
FROM z__orders_items_csv z 
    JOIN manufacturer m ON z.man_id=m.man_id
  JOIN item i ON i.item_modelno=z.item_modelno
GROUP BY i.item_id, z.cat_id;

SELECT ic.ic_id, ic.item_id, ic.cat_id, ic.user_id, ic.date_mod, ic.active
FROM item__category ic;



-- orders ----------------------------------


ALTER TABLE orders DROP CONSTRAINT orders_UK;

INSERT INTO orders  (order_id, order_num, order_date, order_notes
                    , order_credit, order_cr_uom, p_id_cust, p_id_emp)
SELECT (l.order_num_interv*numlist.p_id)+z.order_num AS order_id
     , (l.order_num_interv*numlist.p_id)+z.order_num AS order_num
     , DATE_ADD(z.order_date, INTERVAL ((-numlist.p_id)/2)+1 DAY) AS order_date_new
     , NULL
     , 0, '$'
     , CONVERT(FLOOR(1 + RAND() * (l.p_id_lmt - 1 + 1)),DECIMAL(10,0)) AS p_id_rnd
     , 2 AS p_id_emp
FROM z__orders_items_csv z
  JOIN manufacturer man ON z.man_id=man.man_id
  JOIN item i ON i.item_modelno=z.item_modelno
  JOIN (
    SELECT 10002 AS p_id_lmt
       , 10000 AS order_num_interv
       , -100 AS od_val 
  ) l
  , (SELECT p_id-1 AS p_id FROM people ORDER BY p_id) numlist
GROUP BY (l.order_num_interv*numlist.p_id)+z.order_num
  , DATE_ADD(z.order_date, INTERVAL ((-numlist.p_id)/2)+1 DAY), l.p_id_lmt, l.order_num_interv, l.od_val;


-- orders__item ----------------------------------

INSERT INTO orders__item  (order_id, item_id, oi_status
                         , oi_qty, oi_override)
SELECT o.order_id, i.item_id, 'Sold', z.order_qty, NULL
FROM z__orders_items_csv z 
    JOIN manufacturer man ON z.man_id=man.man_id
  JOIN item i ON i.item_modelno=z.item_modelno
  JOIN orders o ON RIGHT(o.order_id,4)=z.order_num
GROUP BY o.order_id, i.item_id, z.order_qty;
                     
SELECT oi.oi_id, oi.order_id, oi.item_id, oi.oi_status, oi.oi_qty, oi.oi_override
     , oi.user_id, oi.date_mod, oi.active
FROM orders__item oi;

DROP TABLE z__orders_items_csv;
   
