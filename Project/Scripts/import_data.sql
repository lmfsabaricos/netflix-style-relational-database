-- Enable local infile
SET GLOBAL local_infile = 1;

-- Use the database
USE MultimediaContentDB;

-- Import data into tables
-- Note: The actual import commands will depend on the structure of your CSV file
-- This is a template that you'll need to modify based on your data

-- Import into User table
LOAD DATA LOCAL INFILE '../Datasets/Data.csv'
INTO TABLE User
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(name, email, password, created_date);

-- Import into Subscription_Plan table
LOAD DATA LOCAL INFILE '../Datasets/subscription_plans.csv'
INTO TABLE Subscription_Plan
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(price, duration, plan_name, description);

-- Import into User_Subscription table
LOAD DATA LOCAL INFILE '../Datasets/user_subscriptions.csv'
INTO TABLE User_Subscription
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(user_id, plan_id, start_date, end_date, status);

-- Import into Payment_Method table
LOAD DATA LOCAL INFILE '../Datasets/payment_methods.csv'
INTO TABLE Payment_Method
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(method_type, provider_name, account_number, billing_address);

-- Import into Content table
LOAD DATA LOCAL INFILE '../Datasets/content.csv'
INTO TABLE Content
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(title, description, duration, genre_id, rating_id, release_id, country_id, accessibility_id, availability_id, format_id, director_id);

-- Verify data import
SELECT 'User' AS Table_Name, COUNT(*) AS Record_Count FROM User
UNION ALL
SELECT 'Subscription_Plan', COUNT(*) FROM Subscription_Plan
UNION ALL
SELECT 'User_Subscription', COUNT(*) FROM User_Subscription
UNION ALL
SELECT 'Payment_Method', COUNT(*) FROM Payment_Method
UNION ALL
SELECT 'Content', COUNT(*) FROM Content; 