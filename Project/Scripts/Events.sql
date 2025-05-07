-- Scheduled Event Requirements Implementation

-- 10. Remove Expired Subscriptions
-- Automatically remove expired subscriptions and notify users

DELIMITER //

CREATE EVENT remove_expired_subscriptions
ON SCHEDULE EVERY 1 DAY
DO
BEGIN
    -- Create temporary table for expired subscriptions
    DROP TEMPORARY TABLE IF EXISTS expired_subs;
    CREATE TEMPORARY TABLE expired_subs AS
    SELECT 
        us.user_id,
        us.subscription_id,
        u.email,
        sp.plan_name
    FROM User_Subscription us
    JOIN User u ON u.user_id = us.user_id
    JOIN Subscription_Plan sp ON sp.plan_id = us.plan_id
    WHERE us.status = 'active'
    AND DATE_ADD(us.start_date, INTERVAL sp.duration DAY) < CURRENT_DATE;
    
    -- Update subscription status
    UPDATE User_Subscription us
    JOIN expired_subs es ON es.subscription_id = us.subscription_id
    SET us.status = 'expired';
    
    -- Create notifications for affected users
    INSERT INTO User_Notification (
        user_id,
        notification_type,
        message,
        created_date
    )
    SELECT 
        user_id,
        'subscription_expired',
        CONCAT('Your ', plan_name, ' subscription has expired.'),
        CURRENT_DATE
    FROM expired_subs;
    
    -- Clean up
    DROP TEMPORARY TABLE IF EXISTS expired_subs;
END //

DELIMITER ;

-- 11. Refresh Popular Content Rankings
-- Update top 10 most popular Content for each Genre daily

DELIMITER //

CREATE EVENT refresh_popular_content_rankings
ON SCHEDULE EVERY 1 DAY
DO
BEGIN
    -- Create or replace the rankings table
    DROP TABLE IF EXISTS Popular_Content_Rankings;
    CREATE TABLE Popular_Content_Rankings (
        ranking_id INT PRIMARY KEY AUTO_INCREMENT,
        genre_id INT NOT NULL,
        content_id INT NOT NULL,
        view_count INT NOT NULL,
        ranking INT NOT NULL,
        last_updated TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        FOREIGN KEY (genre_id) REFERENCES Genre(genre_id),
        FOREIGN KEY (content_id) REFERENCES Content(content_id)
    );
    
    -- Insert rankings for each genre
    INSERT INTO Popular_Content_Rankings (genre_id, content_id, view_count, ranking)
    SELECT 
        g.genre_id,
        c.content_id,
        COUNT(ch.watch_id) AS view_count,
        RANK() OVER (PARTITION BY g.genre_id ORDER BY COUNT(ch.watch_id) DESC) AS ranking
    FROM Genre g
    JOIN Content c ON c.genre_id = g.genre_id
    LEFT JOIN Content_WatchHistory ch ON ch.content_id = c.content_id
    WHERE ch.date_watched >= DATE_SUB(CURRENT_DATE, INTERVAL 30 DAY)
    GROUP BY g.genre_id, c.content_id
    HAVING ranking <= 10;
END //

DELIMITER ;

-- Enable the event scheduler
SET GLOBAL event_scheduler = ON; 