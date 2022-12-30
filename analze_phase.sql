SELECT *
FROM cy_2019_q2

-- converting the dates into days, weeks, month  
UPDATE cyclistics
SET week = TO_CHAR(start_time, 'month')


-- frist create anew column for days, week,month
ALTER TABLE cyclistics
RENAME COLUMN week TO MONTH
-- creating a temp table for analysis
CREATE TEMPORARY TABLE all_cy (
ride_id CHAR (100) PRIMARY KEY,
start_time TIMESTAMP,
end_time TIMESTAMP,
start_station_name CHAR(100),
end_station_name CHAR(100),
user_type CHAR (15), 
day_of_week CHAR(15),
month CHAR (15)
)
-- uploading values from cy_2019_q1 into the temp table 
INSERT INTO all_cy (ride_id, 
start_time,
end_time,
start_station_name,
end_station_name,
user_type,
day_of_week,
month)
SELECT ride_id, 
start_time,
end_time,
start_station_name,
end_station_name,
user_type,
day_of_week,
month 
FROM 
cyclistics
-- cross check
SELECT *
FROM all_cy
 WHERE start_time  BETWEEN '2020-01-01' AND '2020-03-31'
 ORDER BY start_time
SELECT *
FROM cyclistics
ORDER BY start_time DESC 
-- removig duplicate from temp table 
SELECT *
FROM all_cy
-- this is used to cross check for ay duplicate ride_id its important to note 
-- that as when this query was run they was no duplicate at all. 
SELECT  
FROM all_cy 
GROUP BY ride_id 
HAVING COUNT(*) > 1
-- checking for null val
-- also no value at all is null 
SELECT *
FROM all_cy 
WHERE ride_id IS NULL
-- changing the casual to customer and subscriber into membebr 
SELECT CASE 
           WHEN user_type = 'Subscriber' THEN 'member'
		   ELSE null
		   END 
		   FROM all_cy
-- updating the table 
UPDATE all_cy 
SET user_type = (SELECT CASE 
           WHEN user_type = 'Subscriber' THEN 'member'
		   ELSE user_type
		   END 
		   FROM (SELECT user_type FROM all_cy)as updated_all_cy
		   LIMIT 1)/* making use of a sub query and a limit in other to
		   make sure the where function is working first and limit is to return only 
		   one value */
WHERE user_type = 'Subscriber'
-- changing and updating from casual to customer 
UPDATE all_cy
SET user_type = (
 SELECT CASE WHEN user_type = 'casual' THEN 'customer'
	ELSE user_type
END 
	FROM (SELECT user_type FROM all_cy)AS updated_all_cy
	LIMIT 1
)
WHERE user_type = 'casual'
-- for the descriptive Analysis part -- 
--  this is needed both for answering questions and having an understanding of 
-- the trends and pattern in the data 
-- the following questions are what we are going to ask the data 
/*•	Total number of users 
•	Total number of casual users 
•	Total number of subscribed user 
•	Top 5 station for each of the user types
•	Top 5 drop off station or end trip stations 
•	The busiest day of the week 
•	The busiest month of the year 
•	Busiest season of the year 
•	Maxium ride length 
•	Average ride length 
*/
-- Total number os users 
SELECT COUNT(*) -- 3,593,159
FROM all_cy
-- Total number of users with a descriptive break down between the two users 
SELECT user_type,
COUNT (user_type) as number
FROM  all_cy
GROUP BY 1
ORDER BY 2
-- top 10 popular destination for members 
WITH compare AS (
SELECT DISTINCT start_station_name,
end_station_name,
user_type,
COUNT(*) as num_ride
FROM all_cy 
GROUP BY 1,2,3
)
SELECT start_station_name,
end_station_name,
num_ride 
FROM compare
WHERE user_type = 'member' AND num_ride > 2000
LIMIT 20