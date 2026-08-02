
USE zomatos;

SELECT * FROM zomato_dataset;

-- CHECK DATATYPE OF COLUMN 
SELECT COLUMN_NAME, DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'zomato_dataset';

-- CHECK TABLES IN THE DATABSE
SELECT * FROM INFORMATION_SCHEMA.TABLES 
WHERE TABLE_SCHEMA = 'zomatos'              
AND TABLE_TYPE = 'BASE TABLE';
  
SELECT * FROM zomato_dataset;
-- CHECKING FOR DUPLICATE
SELECT RestaurantName, country_code, City, Address, Locality, LocalityVerbose, Cuisines, Currency, Has_Table_booking, 
       Has_Online_delivery, Is_delivering_now, Switch_to_order_menu, Price_range, Votes, Average_Cost_for_two, Rating, COUNT(*) 
FROM zomato_dataset
GROUP BY RestaurantName, country_code, City, Address, Locality, LocalityVerbose, Cuisines, Currency, Has_Table_booking, 
         Has_Online_delivery, Is_delivering_now, Switch_to_order_menu, Price_range, Votes, Average_Cost_for_two, Rating
HAVING COUNT(*) > 1;


-- COUNTRY CODE COLUMN
SELECT * FROM country_code t1
INNER JOIN zomato_dataset t2
ON t1.country_code = t2.country_code;

-- ADD A NEW COL (country_name)
ALTER TABLE zomato_dataset
ADD COLUMN country_name VARCHAR(255) AFTER country_code;


-- INSERT DATA FROM ONE TABLE TO ANOTHER
UPDATE zomato_dataset t1
INNER JOIN country_code t2
ON t1.country_code = t2.country_code
SET country_name = t2.country;


-- CITY COLUMN
select City FROM zomato_dataset                                                                         -- IDENTIFYING IF THERE ARE ANY MISS-SPELLED WORD  
WHERE City LIKE '%?%';

SELECT City, CASE                                                                                         -- REPLACING MISS-SPELLED WORD
                 WHEN City LIKE '%stanbul%' THEN REPLACE(City, '?', 'I')
                 WHEN City LIKE '%Bras%' THEN REPLACE(City, '?', 'i')
                 WHEN City LIKE '%Paulo%' THEN REPLACE(City, '?', 'a')
                 ELSE City END AS 'correctd_city'
FROM zomato_dataset;

UPDATE zomato_dataset                                                                                       -- UPDATE CITY COL
SET City = REPLACE(City, '?', 'i') 
WHERE City LIKE '%Bras%';

UPDATE zomato_dataset
SET City = REPLACE(City, '?', 'I')
WHERE City LIKE '%stanbul%';

UPDATE zomato_dataset
SET City = REPLACE(City, '?', 'a')
WHERE City LIKE '%Paulo%';

SELECT country_name, City, COUNT(*) AS "count"                                                  -- COUNTING TOTAL REST. IN EACH CITY OF PARTICULAR COUNTRY
FROM zomato_dataset                  
GROUP BY country_name, City
ORDER BY 1,2,3 DESC;

SELECT country_name, City, COUNT(*) AS "count"                                                  -- COUNTING TOTAL REST. IN EACH CITY OF PARTICULAR COUNTRY
FROM zomato_dataset                  
GROUP BY country_name, City
ORDER BY country_name ASC, City ASC, count DESC;


-- LOCALITY COLUMN
SELECT City, Locality, 
       COUNT(*) AS COUNT_LOCALITY,                                                                                     -- SUBTOTAL FOR EACH LOCALITY
       SUM(COUNT(*)) OVER(PARTITION BY City ORDER BY Locality) AS ROLL_COUNT                                           -- ROLLING TOTAL WITHIN EACH CITY
FROM zomato_dataset
WHERE COUNTRY_NAME = 'INDIA'
GROUP BY City, Locality
ORDER BY City ASC, Locality ASC;

-- Connaught Place in New Delhi has the most listed restaurants (122) follwed by Rajouri Garden (99) and Shahdara (87)

SELECT * FROM zomato_dataset;

-- DROP COLUMN [LocalityVerbose]
ALTER TABLE zomato_dataset
DROP COLUMN LocalityVerbose;



-- CUISINES COLUMN 
SELECT Cuisines, COUNT(Cuisines) FROM zomato_dataset
WHERE Cuisines IS NULL OR Cuisines = ''
GROUP BY Cuisines;

SELECT Cuisines, COUNT(Cuisines) AS "total_cuisines" 
FROM zomato_dataset
GROUP BY Cuisines
ORDER BY total_cuisines DESC;


-- CURRENCY COULMN
SELECT Currency, COUNT(*) AS "total_count" FROM zomato_dataset
GROUP BY Currency
ORDER BY total_count DESC;

SELECT Currency, COUNT(*) AS "total_count", REPEAT('*', COUNT(*)/20) AS 'histogram'                                       -- HISTOGRAM PLOT FOR CURRENCY
FROM zomato_dataset
GROUP BY Currency
ORDER BY total_count DESC;


-- YES/NO COLUMNS
-- Has_Table_booking COLUMN
SELECT Has_Table_booking, COUNT(*) AS "total_count", ROUND(COUNT(*)*100/SUM(COUNT(*)) OVER(), 2) AS "percentage_of_total" 
FROM zomato_dataset
GROUP BY Has_Table_booking;

-- Has_Online_delivery COLUMN
SELECT Has_Online_delivery, COUNT(*) AS "total_count", ROUND(COUNT(*)*100/SUM(COUNT(*)) OVER(), 2) AS "percentage_of_total"
FROM zomato_dataset
GROUP BY Has_Online_delivery;

SELECT country_name, 
	   SUM(CASE WHEN Has_Online_delivery = 1 THEN 1 ELSE 0 END) AS "count_of_has_online_delivery", 
       COUNT(*) AS "total_count", 
       ROUND((SUM(CASE WHEN Has_Online_delivery = 1 THEN 1 ELSE 0 END)*100)/COUNT(*), 2) AS "total_percent_of_respective_country"
FROM zomato_dataset
GROUP BY country_name;

-- Out of 15 Countries only 2 countries provides Online delivery options to their customers, to be precised only 28.01% of restaurants 
-- in India and 46.67% of restaurants in UAE provides online delivery options.


-- Is_delivering_now COLUMN
SELECT Is_delivering_now, COUNT(*) AS "total_count", ROUND(COUNT(*)*100/SUM(COUNT(*)) OVER(), 2) AS "percentage_of_total"
FROM zomato_dataset
GROUP BY Is_delivering_now;

-- Switch_to_order_menu COLUMN
SELECT Switch_to_order_menu, COUNT(*) AS "total_count", ROUND(COUNT(*)*100/SUM(COUNT(*)) OVER(), 2) AS "percentage_of_total"
FROM zomato_dataset
GROUP BY Switch_to_order_menu;


-- DROP COULLMN [Switch_to_order_menu]
-- ALTER TABLE zomato_dataset 
-- DROP COLUMN Switch_to_order_menu;


-- PRICE RANGE COLUMN
SELECT Price_range, COUNT(*) AS total_restaurants,
       ROUND(COUNT(*)*100.0 / SUM(COUNT(*)) OVER(), 2) AS percentage_share
FROM zomato_dataset
GROUP BY Price_range
ORDER BY Price_range ASC;


SELECT Price_range, COUNT(*) AS total_restaurants,                                                                     -- PRICE_RANGE VS RATING VS VOTES
    ROUND(AVG(Rating), 2) AS avg_rating,
    ROUND(AVG(Votes), 0) AS avg_votes
FROM zomato_dataset
GROUP BY Price_range
ORDER BY Price_range ASC;

SELECT Price_range, Rating FROM zomato_dataset;                                                                        -- SCATTER PLOT ON PRICE_RANGE VS RATING


-- VOTES COLUMN (CHECKING MIN,MAX,AVG OF VOTE COLUMN)
SELECT MIN(Votes), AVG(Votes), MAX(Votes ), STD(Votes)
FROM zomato_dataset;

SELECT
    RestaurantName, City, country_name, Votes, Rating, Price_range, Has_Online_delivery
FROM zomato_dataset
ORDER BY Votes DESC LIMIT 10;


SELECT Votes, Rating FROM zomato_dataset;                                                                              -- SCATTER PLOT ON Votes VS RATING



-- COST COLUMN
SELECT City, COUNT(*) AS "total_restaurant", Currency, ROUND(AVG(Average_Cost_for_two), 2) AS "avg_cost",
MIN(Average_Cost_for_two) AS "min_cost", MAX(Average_Cost_for_two) AS "max_cost" FROM zomato_dataset
GROUP BY City, Currency
ORDER BY Currency ASC, avg_cost DESC;



SELECT COUNT(*) AS "total_restaurant", 
	   CASE                                                                                     -- HISTOGRAM PLOT ON Average_Cost_for_two VS RESTAURANT COUNT
       WHEN Average_Cost_for_two <= 300 THEN '0-300'
       WHEN Average_Cost_for_two <= 900 THEN '301-900'
       WHEN Average_Cost_for_two <= 1500 THEN '901-1500'
       ELSE '>1500' END AS 'bucket', REPEAT('*', COUNT(*)/50) AS 'histogram'
FROM zomato_dataset
GROUP BY bucket
ORDER BY bucket;


-- RATING COLUMN
SELECT MIN(Rating) AS "Lowest_rating",
ROUND(AVG(Rating), 2) AS "avg_rating", 
MAX(Rating) AS "highest_rating"
FROM zomato_dataset;


SELECT COUNT(*),                                                                                             -- HISTOGRAM ON RATING VS RESTAURANT COUNT
       CASE
           WHEN Rating <= 1 THEN '0-1'
           WHEN Rating <= 2 THEN '1-2'
           WHEN Rating <= 3 THEN '2-3'
           WHEN Rating <= 4 THEN '3-4'
           ELSE '4-5' END AS 'bucket',
           REPEAT('*', COUNT(*)/45) AS 'histogram'
FROM zomato_dataset
GROUP BY bucket;


ALTER TABLE zomato_dataset                                                                           -- CHANGE DATA_TYPE OF RATING COL FROM DOUBLE TO DECIMAL
MODIFY COLUMN Rating DECIMAL(5, 2);

SELECT RestaurantID, RestaurantName, Rating                                                          -- RESTAURANT WITH RATING GREATER THAN EQUAL TO 4
FROM zomato_dataset WHERE Rating >= 4;       

SELECT RestaurantID, RestaurantName, Rating,
	   CASE
           WHEN Rating = 0 THEN 'not rated'
           WHEN Rating < 2.5 THEN 'poor'
           WHEN Rating < 3.5 THEN 'moderate'
           WHEN Rating < 4.5 THEN 'good'
           ELSE 'excellent' END AS "rating_category"
FROM zomato_dataset;
           
ALTER TABLE zomato_dataset                                                                                          -- ADD A NEW COL RATING_CATEGORY
ADD COLUMN rating_category VARCHAR(255) AFTER Rating;

UPDATE zomato_dataset                                                                                              -- INSERT DATA INTO RATING_CATEGORY
SET rating_category = CASE 
                          WHEN Rating = 0 THEN 'not rated'
                          WHEN Rating < 2.5 THEN 'poor'
                          WHEN Rating < 3.5 THEN 'moderate'
                          WHEN Rating < 4.5 THEN 'good'
                          ELSE 'excellent' END;
                          
SELECT * FROM zomato_dataset;

SELECT Company, CASE WHEN touch_screen LIKE '%1%' THEN COUNT(*) ELSE COUNT(*)*0 END AS "touch",
                CASE WHEN touch_screen LIKE '%0%' THEN COUNT(*) ELSE COUNT(*)*0 END AS "not_touch" 
FROM laptop_data
GROUP BY Company, touch_screen;


-- Price_range VS Has_Online_delivery                                                                                         -- CONTIGENCY TABLE
SELECT Price_range, 
	   SUM(CASE WHEN Has_Online_delivery = 'Yes' THEN 1 ELSE 0 END) AS "online_delivery_available",
	   SUM(CASE WHEN Has_Online_delivery = 'No' THEN 1 ELSE 0 END) AS "online_delivery_not_available"
FROM zomato_dataset
GROUP BY Price_range
ORDER BY Price_range ASC;

SELECT * FROM zomato_dataset;


-- ONE HOTENCODING ON Has_Table_booking COLUMN [Yes = 1, No = 0]
SELECT Has_Table_booking, CASE
                              WHEN Has_Table_booking = 'Yes' THEN 1 ELSE 0
                              END AS "encoded_Has_Table_booking"
FROM zomato_dataset;

UPDATE zomato_dataset
SET Has_Table_booking = CASE
                              WHEN Has_Table_booking = 'Yes' THEN 1 ELSE 0 END;


-- ONE HOTENCODING ON Has_Table_booking COLUMN [Yes = 1, No = 0]
SELECT Has_Online_delivery, CASE
                              WHEN Has_Online_delivery = 'Yes' THEN 1 ELSE 0 END AS "encoded_Has_Online_delivery"
FROM zomato_dataset;

UPDATE zomato_dataset
SET Has_Online_delivery = CASE
                              WHEN Has_Online_delivery = 'Yes' THEN 1 ELSE 0 END;



-- ONE HOTENCODING ON Has_Table_booking COLUMN [Yes = 1, No = 0]
SELECT Is_delivering_now, CASE
                              WHEN Is_delivering_now = 'Yes' THEN 1 ELSE 0 END AS "encoded_is_delivering_now"
FROM zomato_dataset;

UPDATE zomato_dataset
SET Is_delivering_now = CASE
                              WHEN Is_delivering_now = 'Yes' THEN 1 ELSE 0 END;


-- ONE HOTENCODING ON Has_Table_booking COLUMN [not rated = 0, poor = 1, moderate = 2, excellent = 3]
SELECT rating_category, CASE
                              WHEN rating_category = 'not rated' THEN 0
                              WHEN rating_category = 'poor' THEN 1
                              WHEN rating_category = 'moderate' THEN 2
                              ELSE 3 END AS 'encoded_rating'
FROM zomato_dataset;

UPDATE zomato_dataset
SET rating_category =  CASE
                              WHEN rating_category = 'not rated' THEN 0
                              WHEN rating_category = 'poor' THEN 1
                              WHEN rating_category = 'moderate' THEN 2
                              ELSE 3 END;

-- ONE HOTENCODING ON Switch_to_order_menu COLUMN [Yes = 1, No = 0]
SELECT Switch_to_order_menu, CASE
                              WHEN Switch_to_order_menu = 'Yes' THEN 1 ELSE 0 END AS "encoded_Switch_to_order_menu"
FROM zomato_dataset;

UPDATE zomato_dataset
SET Switch_to_order_menu = CASE
                              WHEN Switch_to_order_menu = 'Yes' THEN 1 ELSE 0 END;
                              
                              
SELECT * FROM zomato_dataset;
							
