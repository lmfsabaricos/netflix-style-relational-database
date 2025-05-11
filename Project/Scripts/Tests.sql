-- Test 1: Trigger – make watchlist remove the oldest item after 50 items.
DELETE FROM Watchlist_Content WHERE watchlist_id = 1;

-- Insert 51 items to watchlist
INSERT INTO Watchlist_Content (watchlist_id, content_id, added_date, description)
SELECT 1, IF(ROW_NUMBER() OVER () % 2 = 0, 1, 2), CURDATE(), CONCAT('Test item ', seq)
FROM (
  SELECT 1 AS seq UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5 UNION
  SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9 UNION SELECT 10 UNION
  SELECT 11 UNION SELECT 12 UNION SELECT 13 UNION SELECT 14 UNION SELECT 15 UNION
  SELECT 16 UNION SELECT 17 UNION SELECT 18 UNION SELECT 19 UNION SELECT 20 UNION
  SELECT 21 UNION SELECT 22 UNION SELECT 23 UNION SELECT 24 UNION SELECT 25 UNION
  SELECT 26 UNION SELECT 27 UNION SELECT 28 UNION SELECT 29 UNION SELECT 30 UNION
  SELECT 31 UNION SELECT 32 UNION SELECT 33 UNION SELECT 34 UNION SELECT 35 UNION
  SELECT 36 UNION SELECT 37 UNION SELECT 38 UNION SELECT 39 UNION SELECT 40 UNION
  SELECT 41 UNION SELECT 42 UNION SELECT 43 UNION SELECT 44 UNION SELECT 45 UNION
  SELECT 46 UNION SELECT 47 UNION SELECT 48 UNION SELECT 49 UNION SELECT 50 UNION
  SELECT 51
) AS numbered

LIMIT 2;
-- Check count (should be capped at 50 due to trigger)
SELECT COUNT(*) AS watchlist_item_count FROM Watchlist_Content WHERE watchlist_id = 1;


-- Test 2: Trigger - Review lowers average rating below 2
INSERT INTO Review (user_id, content_id, rating, review_description, created_date)
VALUES (2, 1, 1, 'Terrible movie. Testing low rating trigger.', CURDATE());

-- Check if availability status changed to 'Archived'
SELECT c.content_id, ca.status
FROM Content c
JOIN Content_Availability ca ON c.availability_id = ca.availability_id
WHERE c.content_id = 1;


-- Test 3: Function - Get top genres by watch hours
 CALL get_top_genres_by_watch_hours();



-- Test 4: Function - Most frequent actor-director pairs
CALL get_top_actor_director_pairs();


-- Test 5: Function - Check if a user subscription is still active
SELECT check_subscription_status(1) AS subscription_status;


-- Test 6: Procedure - Generate monthly user activity report
CALL generate_monthly_user_activity();


-- Test 7: Procedure - Batch update availability
CALL batch_update_content_availability ('2024-01-01', 1, 'unavailable');


-- Test 8: Procedure - Handle failed payment
CALL handle_failed_payment(1, 1, 1, 15.99);


-- Confirm failed payment got logged
SELECT * FROM Transaction WHERE user_id = 1 AND status = 'failed';
SELECT * FROM User_Notification WHERE user_id = 1 AND notification_type = 'payment_failed';


-- Test 9: Event - Remove expired subscriptions (if manual test desired)
-- CALL remove_expired_subscriptions();


-- Test 10: Extra confirmation queries
SELECT content_id, title FROM Content;
SELECT watchlist_id, content_id FROM Watchlist_Content;
SELECT COUNT(*) AS total_users FROM User;
SELECT user_id, name FROM User ORDER BY user_id;

-- Test 11: Testing director twice
INSERT INTO Director (director_id, name) VALUES (5, 'Test Director');
UPDATE Content SET director_id = 5 WHERE content_id = 1;
UPDATE Content SET director_id = 5 WHERE content_id = 1;
SELECT * FROM Director_Assignment_Errors WHERE content_id = 1 AND director_id = 5;
