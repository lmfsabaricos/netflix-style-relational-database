
-- Yo team, this is the full import script.
-- It loads users from the Data.csv file and adds fake records for all the tables
-- so we can test everything — triggers, procedures, functions, events. Let's go!

USE MultimediaContentDB;

-- Allow local file loading if it's not enabled yet
SET GLOBAL local_infile = 1;

-- Load users from prof's Data.csv
LOAD DATA LOCAL INFILE 'C:/Users/lmfsa/DataGripProjects/csc675-775-group-project-sp25-Heison0818/Project/Datasets/Data.csv'
INTO TABLE User
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(name, email, password, created_date);


-- Step 1: Insert 50 users (required first due to FK constraints)
INSERT INTO User (name, email, password, created_date)
VALUES
('User1', 'user1@example.com', 'pass1', '2025-05-10'),
('User2', 'user2@example.com', 'pass2', '2025-05-10'),
('User3', 'user3@example.com', 'pass3', '2025-05-10'),
('User4', 'user4@example.com', 'pass4', '2025-05-10'),
('User5', 'user5@example.com', 'pass5', '2025-05-10'),
('User6', 'user6@example.com', 'pass6', '2025-05-10'),
('User7', 'user7@example.com', 'pass7', '2025-05-10'),
('User8', 'user8@example.com', 'pass8', '2025-05-10'),
('User9', 'user9@example.com', 'pass9', '2025-05-10'),
('User10', 'user10@example.com', 'pass10', '2025-05-10'),
('User11', 'user11@example.com', 'pass11', '2025-05-10'),
('User12', 'user12@example.com', 'pass12', '2025-05-10'),
('User13', 'user13@example.com', 'pass13', '2025-05-10'),
('User14', 'user14@example.com', 'pass14', '2025-05-10'),
('User15', 'user15@example.com', 'pass15', '2025-05-10'),
('User16', 'user16@example.com', 'pass16', '2025-05-10'),
('User17', 'user17@example.com', 'pass17', '2025-05-10'),
('User18', 'user18@example.com', 'pass18', '2025-05-10'),
('User19', 'user19@example.com', 'pass19', '2025-05-10'),
('User20', 'user20@example.com', 'pass20', '2025-05-10'),
('User21', 'user21@example.com', 'pass21', '2025-05-10'),
('User22', 'user22@example.com', 'pass22', '2025-05-10'),
('User23', 'user23@example.com', 'pass23', '2025-05-10'),
('User24', 'user24@example.com', 'pass24', '2025-05-10'),
('User25', 'user25@example.com', 'pass25', '2025-05-10'),
('User26', 'user26@example.com', 'pass26', '2025-05-10'),
('User27', 'user27@example.com', 'pass27', '2025-05-10'),
('User28', 'user28@example.com', 'pass28', '2025-05-10'),
('User29', 'user29@example.com', 'pass29', '2025-05-10'),
('User30', 'user30@example.com', 'pass30', '2025-05-10'),
('User31', 'user31@example.com', 'pass31', '2025-05-10'),
('User32', 'user32@example.com', 'pass32', '2025-05-10'),
('User33', 'user33@example.com', 'pass33', '2025-05-10'),
('User34', 'user34@example.com', 'pass34', '2025-05-10'),
('User35', 'user35@example.com', 'pass35', '2025-05-10'),
('User36', 'user36@example.com', 'pass36', '2025-05-10'),
('User37', 'user37@example.com', 'pass37', '2025-05-10'),
('User38', 'user38@example.com', 'pass38', '2025-05-10'),
('User39', 'user39@example.com', 'pass39', '2025-05-10'),
('User40', 'user40@example.com', 'pass40', '2025-05-10'),
('User41', 'user41@example.com', 'pass41', '2025-05-10'),
('User42', 'user42@example.com', 'pass42', '2025-05-10'),
('User43', 'user43@example.com', 'pass43', '2025-05-10'),
('User44', 'user44@example.com', 'pass44', '2025-05-10'),
('User45', 'user45@example.com', 'pass45', '2025-05-10'),
('User46', 'user46@example.com', 'pass46', '2025-05-10'),
('User47', 'user47@example.com', 'pass47', '2025-05-10'),
('User48', 'user48@example.com', 'pass48', '2025-05-10'),
('User49', 'user49@example.com', 'pass49', '2025-05-10'),
('User50', 'user50@example.com', 'pass50', '2025-05-10');


INSERT INTO Watchlist (user_id, created_date)
SELECT user_id, '2025-05-10' FROM User;

-- Step 2: Insert sample subscription plans
INSERT INTO Subscription_Plan (price, duration, plan_name, description) VALUES
(9.99, 30, 'Basic', 'SD plan'),
(14.99, 30, 'Standard', 'HD plan'),
(19.99, 30, 'Premium', '4K + more devices');

-- Step 3: Add fake payment methods for users
INSERT INTO Payment_Method (method_type, provider_name, account_number, billing_address) VALUES
('Credit Card', 'Visa', '**** 1234', '123 Street, SF'),
('PayPal', 'PayPal Inc.', 'paypal@example.com', '456 Ave, LA');

-- Step 4: Some sample user subscriptions
INSERT INTO User_Subscription (user_id, plan_id, start_date, end_date, status) VALUES
(1, 1, '2024-04-01', '2024-05-01', 'expired'),
(2, 2, '2024-05-01', '2024-06-01', 'active');

-- Step 5: Add a couple transactions, one of them failed to test procedure
INSERT INTO Transaction (user_id, payment_method_id, plan_id, transaction_date, amount_paid, status) VALUES
(1, 1, 1, '2024-04-01', 9.99, 'completed'),
(2, 2, 2, '2024-05-01', 14.99, 'completed'),
(1, 1, 1, '2024-05-02', 9.99, 'failed');

-- Step 6: Content release platforms
INSERT INTO Content_Release (release_date, platform) VALUES
('2024-03-01', 'Netflix'),
('2023-12-15', 'Hulu');

-- Step 7: Availability info
INSERT INTO Content_Availability (region, status) VALUES
('US', 'available'),
('Europe', 'available');

-- Step 8: Accessibility options
INSERT INTO Content_Accessibility (type, language) VALUES
('Subtitles', 'English'),
('Audio Description', 'Spanish');

-- Step 9: Content format types
INSERT INTO Content_Format (format_type) VALUES
('HD'),
('4K');

-- Step 10: Countries
INSERT INTO Country (name) VALUES
('USA'),
('Canada');

-- Step 11: Ratings
INSERT INTO Rating (rating_label, description) VALUES
('PG-13', 'Parents strongly cautioned'),
('R', 'Restricted');

-- Step 12: Genres
INSERT INTO Genre (name, description) VALUES
('Action', 'High energy, explosions'),
('Drama', 'Emotional and narrative');

-- Step 13: Directors
INSERT INTO Director (name, bio) VALUES
('John Smith', 'Action film specialist'),
('Mary Lee', 'Known for emotional dramas');

-- Step 14: Adding some content
INSERT INTO Content (
    title, description, duration, genre_id, rating_id,
    release_id, country_id, accessibility_id, availability_id,
    format_id, director_id
) VALUES
('The Conjuring', 'Heart Pounding Horror Movie', 120, 1, 1, 1, 1, 1, 1, 1, 1),
('When We Meet Again', 'Romantic Drama', 90, 2, 2, 2, 2, 2, 2, 2, 2);

-- Step 15: Reviews (trigger test: one is actually very bad to test archiving).
INSERT INTO Review (user_id, content_id, rating, review_description, created_date) VALUES
(1, 1, 5, 'Loved it!', '2025-05-10'),
(2, 1, 1, 'Pretty boring', '2025-05-10'),
(1, 2, 3, 'It was okay.', '2025-05-10');

-- Step 16: Watchlists for user_id 1 to 50 (In test.sql)
INSERT INTO Watchlist (user_id, created_date)
VALUES
(8, '2025-05-10'),
(9, '2025-05-10'),
(10, '2025-05-10'),
(11, '2025-05-10'),
(12, '2025-05-10'),
(13, '2025-05-10'),
(14, '2025-05-10'),
(15, '2025-05-10'),
(16, '2025-05-10'),
(17, '2025-05-10'),
(18, '2025-05-10'),
(19, '2025-05-10'),
(20, '2025-05-10'),
(21, '2025-05-10'),
(22, '2025-05-10'),
(23, '2025-05-10'),
(24, '2025-05-10'),
(25, '2025-05-10'),
(26, '2025-05-10'),
(27, '2025-05-10'),
(28, '2025-05-10'),
(29, '2025-05-10'),
(30, '2025-05-10'),
(31, '2025-05-10'),
(32, '2025-05-10'),
(33, '2025-05-10'),
(34, '2025-05-10'),
(35, '2025-05-10'),
(36, '2025-05-10'),
(37, '2025-05-10'),
(38, '2025-05-10'),
(39, '2025-05-10'),
(40, '2025-05-10'),
(41, '2025-05-10'),
(42, '2025-05-10'),
(43, '2025-05-10'),
(44, '2025-05-10'),
(45, '2025-05-10'),
(46, '2025-05-10'),
(47, '2025-05-10'),
(48, '2025-05-10'),
(49, '2025-05-10'),
(50, '2025-05-10'),
(51, '2025-05-10'),
(52, '2025-05-10'),
(53, '2025-05-10'),
(54, '2025-05-10'),
(55, '2025-05-10'),
(56, '2025-05-10'),
(57, '2025-05-10');

-- Step 17: Insert test watchlist data for users 1 to 50 with mock created dates ((In test.sql)
INSERT INTO Watchlist_Content (watchlist_id, content_id, added_date, description)
VALUES
(1, 1, CURDATE(), 'Test 1'),
(2, 2, CURDATE(), 'Test 2'),
(3, 1, CURDATE(), 'Test 3'),
(4, 2, CURDATE(), 'Test 4'),
(5, 1, CURDATE(), 'Test 5'),
(6, 2, CURDATE(), 'Test 6'),
(7, 1, CURDATE(), 'Test 7'),
(8, 2, CURDATE(), 'Test 8'),
(9, 1, CURDATE(), 'Test 9'),
(10, 2, CURDATE(), 'Test 10'),
(11, 1, CURDATE(), 'Test 11'),
(12, 2, CURDATE(), 'Test 12'),
(13, 1, CURDATE(), 'Test 13'),
(14, 2, CURDATE(), 'Test 14'),
(15, 1, CURDATE(), 'Test 15'),
(16, 2, CURDATE(), 'Test 16'),
(17, 1, CURDATE(), 'Test 17'),
(18, 2, CURDATE(), 'Test 18'),
(19, 1, CURDATE(), 'Test 19'),
(20, 2, CURDATE(), 'Test 20'),
(21, 1, CURDATE(), 'Test 21'),
(22, 2, CURDATE(), 'Test 22'),
(23, 1, CURDATE(), 'Test 23'),
(24, 2, CURDATE(), 'Test 24'),
(25, 1, CURDATE(), 'Test 25'),
(26, 2, CURDATE(), 'Test 26'),
(27, 1, CURDATE(), 'Test 27'),
(28, 2, CURDATE(), 'Test 28'),
(29, 1, CURDATE(), 'Test 29'),
(30, 2, CURDATE(), 'Test 30'),
(31, 1, CURDATE(), 'Test 31'),
(32, 2, CURDATE(), 'Test 32'),
(33, 1, CURDATE(), 'Test 33'),
(34, 2, CURDATE(), 'Test 34'),
(35, 1, CURDATE(), 'Test 35'),
(36, 2, CURDATE(), 'Test 36'),
(37, 1, CURDATE(), 'Test 37'),
(38, 2, CURDATE(), 'Test 38'),
(39, 1, CURDATE(), 'Test 39'),
(40, 2, CURDATE(), 'Test 40'),
(41, 1, CURDATE(), 'Test 41'),
(42, 2, CURDATE(), 'Test 42'),
(43, 1, CURDATE(), 'Test 43'),
(44, 2, CURDATE(), 'Test 44'),
(45, 1, CURDATE(), 'Test 45'),
(46, 2, CURDATE(), 'Test 46'),
(47, 1, CURDATE(), 'Test 47'),
(48, 2, CURDATE(), 'Test 48'),
(49, 1, CURDATE(), 'Test 49'),
(50, 2, CURDATE(), 'Test 50');

SELECT content_id FROM Content;

-- Step 18: Playlists
INSERT INTO Playlist (user_id, title, created_date) VALUES
(1, 'Horror Night', '2025-05-10'),
(2, 'Chilling With Netflix', '2025-05-10');

-- Step 19: Playlist content
INSERT INTO Playlist_Content (playlist_id, content_id, added_date, description) VALUES
(1, 1, '2025-05-10', 'Start of the playlist'),
(2, 2, '2025-05-10', 'Favorite drama');

-- Step 20: Actors
INSERT INTO Actor (name, bio) VALUES
('Dwayne Johnson', 'Famous Wrestler'),
('Liza Soberano', 'Famous Philippine Actress');

-- Step 21: Link actors to content
INSERT INTO Actor_Content (content_id, actor_id, actor_role) VALUES
(1, 1, 'Lead Racer'),
(2, 2, 'Main Character');

-- Step 22: Tags
INSERT INTO Tag (tag_name) VALUES
('Very Fun'),
('Very Sad');

-- Step 23: Tag the content
INSERT INTO Tag_Content (content_id, tag_id) VALUES
(1, 1),
(2, 2);

-- Step 24: Watch history for testing ranking and stats
INSERT INTO Content_WatchHistory (user_id, content_id, date_watched, progress) VALUES
(1, 1, '2025-05-10', 100),
(2, 1, '2025-05-10', 80),
(1, 2, '2025-05-10', 90);

-- Step 25: Bonus — insert a notification to make sure the table's working
INSERT INTO User_Notification (user_id, notification_type, message) VALUES
(1, 'Common', 'Welcome to CSC 667 Database Class!');

