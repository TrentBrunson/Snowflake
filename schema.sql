create database reviews;

show databases;

create or replace TABLE REVIEWS (
	REVIEW_ID VARCHAR(100),
	BUSINESS_ID VARCHAR(100),
	USER_ID VARCHAR(100),
	STARS NUMBER(38,4),
	USEFUL NUMBER(38,4),
	REVIEW_DATE DATE
);

USE Reviews;
SELECT * FROM Businesses where City='Cleveland';

use database Reviews;

create or replace TABLE BUSINESSES (
	BUSINESS_ID VARCHAR(100),
	NAME VARCHAR(100),
	CITY VARCHAR(50),
	STATE VARCHAR(2),
	REVIEW_COUNT NUMBER(38,4),
	STARS NUMBER(38,4)
);

create or replace TABLE USERS (
	USER_ID VARCHAR(100),
	NAME VARCHAR(100),
	REVIEW_COUNT NUMBER(38,4),
	USEFUL NUMBER(38,4),
	FANS NUMBER(38,4),
	AVERAGE_STARS NUMBER(38,4),
	JOINED_DATE DATE
);

INSERT INTO BUSINESSES VALUES
('QNcv3mwnHJ5w4YB4giqkWw','Preferred Veterinary Care','Pittsburgh','PA',4,3.5),
('oZG8sxDL54ki9pmDfyL7rA','Not My Dog','Toronto','ON',9,3.5),
('S06JfRM3ICESOHc1pr3LOA','Chase Bank','Las Vegas','NV',3,5.0),
('NL_BfZ4BkQXJSYAFouJqsQ','24 hr lockouts','Las Vegas','NV',3,1.0),
('AnUyv2zHq_35gCeHr8555w','Soma Restaurant','Las Vegas','NV',12,3.0),
('jjBTBObnHrY87qQIMybjzQ','Blue Jade','Cleveland','OH',24,3.5),
('PhL85G9Y6OstQzThDIllMQ','Animalerie Little Bear','Westmount','QC',9,4.0),
('SkRqx-hxVPLgV4K5hxNa9g','Parkview Dental Associates','Sun Prairie','WI',4,3.0),
('tWX7j4Qg4cXofQqmoNKH3A','Sir Hobbs','Sun Prairie','WI',35,3.0),
('4a9Rypytzdz9NZuGMS2ZYw','Rogue Bar','Scottsdale','AZ',80,3.5),
('oYWy-hOTCOF7h8DCAZ_Mxw','Cool Girl','Toronto','ON',48,3.5),
('AMxxi7jyxhcdNF7FIRbUVA','Remington''s Restaurant','Scottsdale','AZ',103,3.0),
('d01d-w7pxHrMCX5mDwaaHQ','D Liche','Montréal','QC',89,4.5),
('66DKb6APF96InEKrUVIbZw','Allo Inde','Montréal','QC',3,3.5);


-- time travel
ALTER SESSION  SET TIMEZONE = 'UTC';
select getdate();

DELETE FROM BUSINESSES
WHERE City='Las Vegas';

SELECT * from BUSINESSES
WHERE City='Las Vegas';

SELECT * from BUSINESSES at(timestamp => '*************'::timestamp)
WHERE City='Las Vegas';

INSERT INTO BUSINESSES
SELECT * from BUSINESSES at(timestamp => '*************'::timestamp)
WHERE City='Las Vegas';


-- views 
CREATE OR REPLACE VIEW top_businesses
AS
SELECT * FROM
Businesses 
WHERE stars>=4;

CREATE OR REPLACE SECURE VIEW top_businesses_secure
AS
SELECT * FROM
Businesses 
WHERE stars>=4;

SELECT * FROM top_businesses
WHERE 1/iff(city='Cleveland', 0, 1) = 1;

SELECT * FROM top_businesses_secure
WHERE 1/iff(city='Cleveland', 0, 1) = 1;

-- UDF
CREATE OR REPLACE FUNCTION cityAverageStars(city varchar)
RETURNS number
AS
$$
SELECT AVG(b.STARS)
FROM BUSINESSES b
WHERE b.CITY = city
GROUP BY b.CITY
$$;

SELECT cityAverageStars('Las Vegas');


CREATE OR REPLACE FUNCTION cityReputation(city varchar)
RETURNS TABLE(City varchar,ReviewCount number, AverageStars number)
AS
$$
SELECT b.CITY, SUM(b.REVIEW_COUNT), AVG(b.STARS)
FROM BUSINESSES b
WHERE b.CITY = city
GROUP BY b.CITY
$$;


SELECT * FROM TABLE(cityReputation('Las Vegas'));

-- GET DDL
SELECT get_ddl('view', 'top_businesses');
SELECT get_ddl('table', 'users');