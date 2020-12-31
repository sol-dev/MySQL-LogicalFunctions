/*Write a query that will output distinct user_guids and their associated country 
of residence from the users table, excluding any user_guids or countries that have 
NULL values. */
SELECT DISTINCT c_users.user_guid, c_users.country
FROM(SELECT user_guid, country
    FROM users 
    WHERE user_guid IS NOT NULL AND country IS NOT NULL) as c_users
LIMIT 100;

/*
Use an IF expression and the query you wrote in Question 1 as a subquery to determine
 the number of unique user_guids who reside in the United States (abbreviated "US") and
 outside of the US.
*/
SELECT IF(c_users.country='US', 'US', 'other') as ctry, COUNT(c_users.user_guid) as num_users
FROM(SELECT DISTINCT user_guid, country
    FROM users 
    WHERE user_guid IS NOT NULL AND country IS NOT NULL) as c_users
GROUP BY ctry;
/*
if you examine the entries contained in the non-US countries category, you will 
see that many users are associated with a country called "N/A." "N/A" is an abbreviation 
for "Not Applicable"; it is not a real country name. We should separate these entries 
from the "Outside of the US" category we made earlier. We could use a nested query to 
say whenever "country" does not equal "US", use the results of a second IF expression
 to determine whether the outputed value should be "Not Applicable" or "Outside US." */
SELECT IF(c_users.country='US','In US',IF(c_users.country='N/A','Not Applicable', 'other')) as ctry, COUNT(c_users.user_guid) as num_users
FROM(SELECT DISTINCT user_guid, country
    FROM users 
    WHERE user_guid IS NOT NULL AND country IS NOT NULL) as c_users
GROUP BY ctry;

/*The main purpose of CASE expressions is to return a singular value based on one or 
more conditional tests. You can think of CASE expressions as an efficient way to write
a set of IF and ELSEIF statements.*/
SELECT CASE c_users.country
            WHEN "US" THEN 'In US'
            WHEN "N/A" THEN "Not Applicable"
            ELSE "Other"
        END
        AS location, 
        COUNT(c_users.user_guid)
FROM (SELECT DISTINCT user_guid, country
     FROM users
     WHERE country IS NOT NULL) AS c_users
GROUP BY location;

/*Write a query using a CASE statement that outputs 3 columns: dog_guid, dog_fixed,
 and a third column that reads "neutered" every time there is a 1 in the "dog_fixed"
 column of dogs, "not neutered" every time there is a value of 0 in the "dog_fixed" 
 column of dogs, and "NULL" every time there is a value of anything else in the
 "dog_fixed" column. Limit your results for troubleshooting purposes. */
 SELECT DISTINCT dog_guid, dog_fixed, 
    CASE dog_fixed
    WHEN 1 THEN 'Neutered'
    WHEN 0 THEN 'Not neutered'
    ELSE 'NULL'
    END AS neutered
FROM dogs
LIMIT 50;

/*Write a query using a CASE statement that outputs 3 columns: dog_guid, exclude, 
and a third column that reads "exclude" every time there is a 1 in the "exclude"
 column of dogs and "keep" every time there is any other value in the exclude column.*/
SELECT dog_guid, exclude, 
    CASE exclude
        WHEN 1 THEN "exclude"
        ELSE "keep"
    END AS exclude_cleaned
FROM dogs
LIMIT 100;
 
 /*Write a query that uses a CASE expression to output 3 columns: dog_guid, weight, 
 and a third column that reads...
"very small" when a dog's weight is 1-10 pounds
"small" when a dog's weight is greater than 10 pounds to 30 pounds
"medium" when a dog's weight is greater than 30 pounds to 50 pounds
"large" when a dog's weight is greater than 50 pounds to 85 pounds
"very large" when a dog's weight is greater than 85 pounds */
SELECT dog_guid, weight, 
    CASE 
    WHEN weight>0 AND weight<=10 THEN "Very small"
    WHEN weight>10 AND weight<=30 THEN "Small"
    WHEN weight>30 AND weight<=50 THEN "Medium"
    WHEN weight>50 AND weight<=85 THEN "Large"
    WHEN weight>85 THEN "Very large"
    ELSE "N/A"
    END AS weight_grouped
FROM dogs
LIMIT 100;

/* For each dog_guid, output its dog_guid, breed_type, 
number of completed tests, and use an IF statement to include 
an extra column that reads "Pure_Breed" whenever breed_type equals 
'Pure Breed" and "Not_Pure_Breed" whenever breed_type equals anything else.  */
SELECT d.dog_guid, d.breed_type, COUNT(c.dog_guid) as num_tests,
IF(d.breed_type = "Pure Breed","Pure_Breed","Not_Pure_Breed" ) AS pure_breed
FROM dogs d 
INNER JOIN complete_tests c ON d.dog_guid=c.dog_guid
GROUP BY d.dog_guid, d.breed_type, pure_breed
LIMIT 10;

/*Write a query that uses a CASE statement to report the number of unique user_guids 
associated with customers who live in the United States and who are in the 
following groups of states:

Group 1: New York (abbreviated "NY") or New Jersey (abbreviated "NJ")
Group 2: North Carolina (abbreviated "NC") or South Carolina (abbreviated "SC")
Group 3: California (abbreviated "CA")
Group 4: All other states with non-null values */
SELECT COUNT(DISTINCT user_guid) as number_users, 
CASE 
    WHEN (state="NY" OR state="NJ") THEN "Group 1 NY/NJ"
    WHEN (state="NC" OR state="SC") THEN "Group 2 NC/SC"
    WHEN state="CA" THEN "Group 3 CA"
    ELSE "Group 4 Other"
    END AS state_group
FROM users 
WHERE state IS NOT NULL AND country="US"
GROUP BY state_group;



