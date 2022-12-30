-- data cleaning phase
-- cleaninng and re-arranging all the tables to the same format as cyclistics table
-- viewing table to compare 
SELECT *
FROM cyclistics 
LIMIT 100
-- cy_2019_q1
SELECT *
FROM cy_2019_q1
LIMIT 100 
-- converting to the right datatype 
ALTER TABLE cy_2019_q1
ALTER COLUMN rideable_type TYPE TIMESTAMP USING (rideable_type::TIMESTAMP);
--note that this will only work one per each 
ALTER TABLE cy_2019_q1
ALTER COLUMN started_at TYPE TIMESTAMP USING(started_at::TIMESTAMP);
-- 
ALTER TABLE cy_2019_q1
ALTER COLUMN ended_at TYPE INT USING(ended_at ::INT);
-- 
ALTER TABLE cy_2019_q1
ALTER COLUMN start_station_name TYPE FLOAT USING (start_station_name::FLOAT);
--
ALTER TABLE cy_2019_q1
ALTER COLUMN start_station_id TYPE INT USING (start_station_id::INT)
-- 
ALTER TABLE cy_2019_q1
ALTER COLUMN end_station_id TYPE INT USING (end_station_id::INT)
-- 
ALTER TABLE cy_2019_q1
ALTER COLUMN end_long TYPE INT USING (end_long::INT)
-- data wrnagling on the character dataset 
SELECT *
FROM cy_2019_q1
--WHERE rideable_type = 'start_time'
LIMIT 100 


--needs to clear all the comma and full stop 
--making use of regexp to clean the data 
SELECT  RTRIM(REGEXP_REPLACE(start_station_name , ',','','g'), '.0')
FROM cy_2019_q1
LIMIT 100
-- REMOVING OR DELETING ROWS 
-- deleting the rows that has character across the table  
DELETE FROM cy_2019_q1 WHERE rideable_type = 'start_time';
--UPDATING SECTION 
UPDATE cy_2019_q1
SET start_station_name = RTRIM(REGEXP_REPLACE(start_station_name , ',','','g'), '.0')
-- correcting the column names into the approprate format
ALTER TABLE cy_2019_q1
RENAME COLUMN rideable_type TO start_time
ALTER TABLE cy_2019_q1
RENAME COLUMN start_station_name TO trip_duration
ALTER TABLE cy_2019_q1
RENAME COLUMN from_station_id TO start_station_id
ALTER TABLE cy_2019_q1
RENAME COLUMN from_station_name TO start_station_name
ALTER TABLE cy_2019_q1
RENAME COLUMN to_station_id TO end_station_id
ALTER TABLE cy_2019_q1
RENAME COLUMN to_station_name TO end_station_name
ALTER TABLE cy_2019_q1
RENAME COLUMN start_long TO usertype
ALTER TABLE cy_2019_q1
RENAME COLUMN end_lat TO gender
ALTER TABLE cy_2019_q1
RENAME COLUMN end_long TO birth_year
ALTER TABLE cy_2019_q1
DROP COLUMN member_casual 
-- adding lat and long to the tables 
--first craete a new columns for lat and long of each location  
ALTER TABLE cy_2019_q1
ADD COLUMN end_long FLOAT;
ALTER TABLE cy_2019_q1
ADD COLUMN end_lat FLOAT;
ALTER TABLE cy_2019_q1
ADD COLUMN start_long FLOAT;
ALTER TABLE cy_2019_q1
ADD COLUMN start_lat FLOAT;
-- try adding the data from the location table into the end_long column 
UPDATE cy_2019_q1 
SET end_long = location.end_long 
FROM location 
WHERE cy_2019_q1.to_station_id = location.end_station_id
-- updating end_lat from location 
UPDATE cy_2019_q1
SET end_lat = location.end_lat
FROM location 
WHERE cy_2019_q1.to_station_id = location.end_station_id
-- upading start_long and start_lat 
UPDATE cy_2019_q1
SET start_long = location.start_long
FROM location 
WHERE cy_2019_q1.from_station_id = location.start_station_id
-- start_lat 
UPDATE cy_2019_q1
SET start_lat = location.start_lat
FROM location 
WHERE cy_2019_q1.from_station_id = location.start_station_id
select *
FROM cy_2019_q1
-- removal of column that are not needed 
ALTER TABLE cy_2019_q1
DROP COLUMN bike_id
ALTER TABLE cy_2019_q1 
DROP COLUMN  trip_duration
ALTER TABLE cy_2019_q1
DROP COLUMN birth_year 
ALTER TABLE cy_2019_q1
DROP COLUMN gender 
--cyclistics table 
SELECT *
FROM cyclistics
LIMIT 10