-- Function-based Requirements Implementation

-- 4. Rank Top Genres by Watch Hours
-- Return the top 3 genres based on total watch hours in the last month

DELIMITER //

CREATE FUNCTION get_top_genres_by_watch_hours()
RETURNS VARCHAR(1000)
DETERMINISTIC
BEGIN
    DECLARE result VARCHAR(1000);
    
    SELECT GROUP_CONCAT(
        CONCAT(genre_name, ' (', total_hours, ' hours)')
        ORDER BY total_hours DESC
        SEPARATOR ', '
    ) INTO result
    FROM (
        SELECT 
            g.name AS genre_name,
            SUM(c.duration * (ch.progress / 100.0)) / 60 AS total_hours
        FROM Genre g
        JOIN Content c ON c.genre_id = g.genre_id
        JOIN Content_WatchHistory ch ON ch.content_id = c.content_id
        WHERE ch.date_watched >= DATE_SUB(CURRENT_DATE, INTERVAL 1 MONTH)
        GROUP BY g.genre_id, g.name
        ORDER BY total_hours DESC
        LIMIT 3
    ) AS top_genres;
    
    RETURN result;
END //

DELIMITER ;

-- 5. Find Most Frequent Collaborators
-- Identify the most frequent actor-director pairs who have worked together

DELIMITER //

CREATE FUNCTION get_top_actor_director_pairs()
RETURNS VARCHAR(1000)
DETERMINISTIC
BEGIN
    DECLARE result VARCHAR(1000);
    
    SELECT GROUP_CONCAT(
        CONCAT(actor_name, ' & ', director_name, ' (', collaboration_count, ' projects)')
        ORDER BY collaboration_count DESC
        SEPARATOR ', '
    ) INTO result
    FROM (
        SELECT 
            a.name AS actor_name,
            d.name AS director_name,
            COUNT(DISTINCT c.content_id) AS collaboration_count
        FROM Actor a
        JOIN Actor_Content ac ON ac.actor_id = a.actor_id
        JOIN Content c ON c.content_id = ac.content_id
        JOIN Director d ON d.director_id = c.director_id
        GROUP BY a.actor_id, d.director_id
        ORDER BY collaboration_count DESC
        LIMIT 5
    ) AS top_pairs;
    
    RETURN result;
END //

DELIMITER ;

-- 6. Validate Subscription Status
-- Return whether a user's subscription is active or expired based on their subscription and transaction history

DELIMITER //

CREATE FUNCTION check_subscription_status(user_id_param INT)
RETURNS VARCHAR(20)
DETERMINISTIC
BEGIN
    DECLARE subscription_status VARCHAR(20);
    DECLARE latest_subscription_date DATE;
    DECLARE subscription_duration INT;
    
    -- Get the latest subscription and its duration
    SELECT 
        us.start_date,
        sp.duration
    INTO 
        latest_subscription_date,
        subscription_duration
    FROM User_Subscription us
    JOIN Subscription_Plan sp ON sp.plan_id = us.plan_id
    WHERE us.user_id = user_id_param
    ORDER BY us.start_date DESC
    LIMIT 1;
    
    -- Check if subscription exists and is still valid
    IF latest_subscription_date IS NULL THEN
        SET subscription_status = 'No Subscription';
    ELSEIF DATE_ADD(latest_subscription_date, INTERVAL subscription_duration DAY) < CURRENT_DATE THEN
        SET subscription_status = 'Expired';
    ELSE
        SET subscription_status = 'Active';
    END IF;
    
    RETURN subscription_status;
END //

DELIMITER ; 