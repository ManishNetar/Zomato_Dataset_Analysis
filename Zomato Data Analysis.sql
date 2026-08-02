-- ANALYSIS QUESTIONS

USE zomatos;

SELECT * FROM zomato_dataset;

-- CONVERT COLUMN NAME (Countrycode)IN LOWER CASE
ALTER TABLE zomato_dataset
RENAME COLUMN CountryCode TO country_code;


-- ROLLING COUNT OF RESTAURANTS IN INDIA (JOIN TABLE country_code and zomato_dataset)

SELECT country, City, Locality, COUNT(Locality), 
SUM(COUNT(Locality)) OVER(Partition BY City ORDER BY Locality DESC) AS "moving_count"
FROM country_code t1
INNER JOIN zomato_dataset t2
ON t1.country_code = t2.country_code
WHERE country = 'India'
GROUP BY country, City, Locality;


-- SEARCHING FOR PERCENTAGE OF RESTAURANTS IN ALL THE COUNTRIES

SELECT country, COUNT(RestaurantID) AS "restaurant_count", SUM(COUNT(RestaurantID)) OVER() AS "total_restaurant",
ROUND((COUNT(RestaurantID)/SUM(COUNT(RestaurantID)) OVER())*100 ,2) AS "percent_of_restaurant" 
FROM country_code t1
INNER JOIN zomato_dataset t2
ON t1.country_code = t2.country_code
GROUP BY country
ORDER BY restaurant_count DESC;


-- WHICH COUNTRIES AND HOW MANY RESTAURANTS WITH PERCENTAGE PROVIDES ONLINE DELIVERY OPTION
SELECT country, COUNT(RestaurantID) AS "count", SUM(COUNT(RestaurantID)) OVER() AS "total_restaurant_of_online_delivery",
ROUND((COUNT(RestaurantID))*100/SUM(COUNT(RestaurantID)) OVER(), 2) AS "share_of_online_delivery" 
FROM country_code t1
INNER JOIN zomato_dataset t2
ON t1.country_code = t2.country_code
WHERE Has_Online_delivery = 'Yes'
GROUP BY country;


-- FINDING FROM WHICH CITY AND LOCALITY IN INDIA WHERE THE MAX RESTAURANTS ARE LISTED IN ZOMATO
SELECT country, City, Locality, COUNT(RestaurantID) AS "count",
SUM(COUNT(RestaurantID)) OVER(PARTITION BY City) AS "restaurant_in_city" FROM country_code t1
INNER JOIN zomato_dataset t2
ON t1.country_code = t2.country_code
WHERE country = 'India'
GROUP BY City, Locality
ORDER BY restaurant_in_city DESC, count DESC
LIMIT 1;


-- TYPES OF FOODS ARE AVAILABLE IN INDIA WHERE THE MAX RESTAURANTS ARE LISTED IN ZOMATO     
       
SELECT COUNT(RestaurantID) AS "count", TRIM(cuisine_name) AS "cuisine_name" FROM zomato_dataset t1
JOIN JSON_TABLE
              (CONCAT('["', REPLACE(Cuisines, '|', '", "'), '"]'), 
			   '$[*]' COLUMNS (cuisine_name VARCHAR(255) PATH '$')) t
INNER JOIN country_code t2
ON t1.country_code = t2.country_code
WHERE country = 'India' AND t1.City = (SELECT City FROM country_code t3
                                    INNER JOIN zomato_dataset t4
                                    ON t3.country_code = t4.country_code
                                    WHERE country = 'India'
                                    GROUP BY City
									ORDER BY COUNT(RestaurantID) DESC LIMIT 1)
GROUP BY TRIM(cuisine_name)
ORDER BY count DESC LIMIT 1;



-- WHICH LOCALITIES IN INDIA HAS THE LOWEST RESTAURANTS LISTED IN ZOMATO

SELECT t.Locality, t.count FROM (SELECT Locality, COUNT(RestaurantID) AS "count", DENSE_RANK() OVER(ORDER BY COUNT(RestaurantID) ASC) AS "rank" FROM country_code t1
                                 INNER JOIN zomato_dataset t2
                                 ON t1.country_code = t2.country_code
                                 WHERE country = 'India'
                                 GROUP BY Locality
                                 ORDER BY count ASC) t
WHERE t.rank = 1;

-- or
WITH ct1 AS (SELECT City, Locality, COUNT(RestaurantID) AS "count" FROM country_code t1
INNER JOIN zomato_dataset t2
ON t1.country_code = t2.country_code
WHERE country = 'India'
GROUP BY Locality, City)
SELECT * FROM ct1
WHERE count = (SELECT MIN(count) FROM ct1)
ORDER BY City;


-- HOW MANY RESTAURANTS OFFER TABLE BOOKING OPTION IN INDIA WHERE THE MAX RESTAURANTS ARE LISTED IN ZOMATO

SELECT COUNT(*) AS "count" FROM  country_code t1
INNER JOIN zomato_dataset t2
ON t1.country_code = t2.country_code
WHERE country = 'India' AND Has_Online_delivery = 'Yes' AND City = (SELECT City FROM country_code t1
                                                                    INNER JOIN zomato_dataset t2
                                                                    ON t1.country_code = t2.country_code
                                                                    WHERE country = 'India'
																	GROUP BY City
                                                                    ORDER BY COUNT(RestaurantID) DESC LIMIT 1);
 

-- HOW RATING AFFECTS IN MAX LISTED RESTAURANTS WITH AND WITHOUT TABLE BOOKING OPTION (Connaught Place)
SELECT Has_Table_booking, COUNT(*) AS "count", ROUND(AVG(Rating), 2) AS "avg_rating", MIN(Rating) FROM zomato_dataset 
WHERE Locality = 'Connaught Place'
GROUP BY Has_Table_booking;


-- AVG RATING OF RESTAURANTS LOCATION WISE
SELECT country, City, Locality, COUNT(*) AS "total_restaurant", ROUND(AVG(Rating), 2) AS "avg_rating" FROM zomato_dataset t1
INNER JOIN country_code t2
ON t1.country_code = t2.country_code
GROUP BY Locality, country, City
ORDER BY avg_rating DESC;


-- FINDING THE BEST RESTAURANTS WITH MODRATE COST FOR TWO IN INDIA HAVING INDIAN CUISINES
SELECT RestaurantID, City, Price_range, Votes, Average_Cost_for_two, Rating FROM country_code t1
INNER JOIN zomato_dataset t2
ON t1.country_code = t2.country_code
WHERE country = 'India' 
AND Price_range <= 3 
AND Average_Cost_for_two < 1000
AND Rating >= 4 
AND Votes >= 1000
-- AND Has_Table_booking = 1
-- AND Has_Online_delivery = 1
AND (Cuisines LIKE '%Mughlai%' OR Cuisines LIKE '%India%' OR Cuisines LIKE '%North Indian%')
ORDER BY Rating DESC, Votes DESC, Average_Cost_for_two ASC;


-- FIND ALL THE RESTAURANTS THOSE WHO ARE OFFERING TABLE BOOKING OPTIONS WITH PRICE RANGE AND HAS HIGH RATING
SELECT RestaurantID, country, City, Price_range, Votes, Rating, Average_Cost_for_two  FROM country_code t1
INNER JOIN zomato_dataset t2
ON t1.country_code = t2.country_code
WHERE Has_Table_booking = 'Yes' AND Rating >= 4
ORDER BY Rating DESC, Votes DESC;
