# Zomato_Dataset_Analysis

Zomato Data Exploration and Analysis with SQL (SQL SERVER)

Most of us know that Zomato is an Indian multinational restaurant aggregator and food delivery company. The idea of analysing the Zomato_dataset is to get the overview of what actutally is happening in their business. Zomato Dataset consist of more than 9000 rows with columns such as Restaurants_id, Restaurants_name, City, Location, Cuisines and many more...

While Exploring Data with SQL, I was working on the following things...
1. Checked all the details of table such column name, data types and constraints
2. Checked for duplicate values in [RestaurantId] column
3. Removed unwanted columns from table
4. Merged 2 differnt tables and added the new column of Country_Name with the help of primary key as [CountryCode] column
5. Identitfied and corrected the mis-spelled city names
6. Counted the no.of restaurants by rolling count/moving count using windows functions
7. Checked min,max,avg data for votes, rating & currency column.
8. Created new category column for rating

After Data Exploration with SQL, I started working on Analysing the Data with SQL where I found insights such as...
1. According to this Zomato Dataset, 90.57% of data is related to restaurants listed in India followed by USA(4.54%).
2. Out of 15 Countries only 2 countries provides Online delivery options to their customers, to be precised only 28.01% of restaurants in India and 46.67% of restaurants in UAE provides online delivery options.
3. As this dataset contains data most related to India so i worked on gaining insights on Indian Restaurants.
4. Connaught Place in New Delhi has the most listed restaurants (122) follwed by Rajouri Garden (99) and Shahdara (87)
5. Most popular cuisines in Connaught Place is North Indian Food.
6. Out of 122 restaurants in Connaught Place only 54 restaurants provide table booking facility to their customers.
7. Average Ratings for restaurants with table booking facility is 3.84/5 compared to  restaurants without table booking facility is 3.61/5 in Connaught Place,New Delhi.
8. Best modrately priced restaurants with average cost for two < 1000, rating > 4, votes > 1000 and provides both table booking and online delivery options to their customer with indian cuisines is located in Kolkata,India named as 'India Restaurant',(RestaurantID - 20747) and in New Delhi,India named as 'Indus Flavour',(RestaurantID - 6144).
9. Visual Analysis (Histogram & Scatter Plot):
Price Range vs. Rating Scatter: Demonstrates a positive relationship ($r = 0.46$), where higher price tiers (Price Range 3–4) consistently maintain higher average ratings ($\approx 3.7 - 3.8$) compared to budget restaurants ($\approx 2.4$).
Votes vs. Rating Scatter: Shows that review volume scales exponentially with customer satisfaction—top-rated restaurants ($4.5 - 5.0$) average ~914 votes, whereas low-rated ones ($\le 2.0$) average only ~1.5 votes.
Histogram on Rating VS Restaurant count and on Average_Cost_for_two VS Restaurant count
10.CONTIGENCY TABLE on Price_range and Has_Online_delivery   
