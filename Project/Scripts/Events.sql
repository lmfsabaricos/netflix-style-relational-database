
DELIMITER //

-- 1 Remove Expired Subscriptions
-- This event executes every single day and checks subscriptions that have expired..
-- It sets their status to expired when found and notifies the user.

CREATE EVENT IF NOT EXISTS remove_expired_subscriptions
ON SCHEDULE EVERY 1 DAY
DO
BEGIN
    -- Temporary table to hold expired subscriptions
    DROP TEMPORARY TABLE IF EXISTS expired_subs;
    CREATE TEMPORARY TABLE expired_subs AS
    SELECT
        us.subscription_id,
        us.user_id,
        sp.plan_name
    FROM user_subscription us
    JOIN subscription_plan sp ON sp.plan_id = us.plan_id
    WHERE us.status = 'active'
      AND DATE_ADD(us.start_date, INTERVAL sp.duration DAY) < CURRENT_DATE;

    -- Mark those subscriptions as expired
    UPDATE user_subscription us
    JOIN expired_subs es ON us.subscription_id = es.subscription_id
    SET us.status = 'expired';

    -- Create notifications for affected users
    INSERT INTO user_notification (
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
END;
//

-- 2. Refresh Popular Content Rankings
-- This event updates the list of the top 10 most viewed content per genre every day.


CREATE EVENT IF NOT EXISTS refresh_popular_content_rankings
ON SCHEDULE EVERY 1 DAY
DO
BEGIN
    -- Drop and recreate the rankings table
    DROP TABLE IF EXISTS popular_content_rankings;
    CREATE TABLE popular_content_rankings (
        ranking_id INT AUTO_INCREMENT PRIMARY KEY,
        genre_id INT NOT NULL,
        content_id INT NOT NULL,
        view_count INT NOT NULL,
        ranking INT NOT NULL,
        last_updated TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        FOREIGN KEY (genre_id) REFERENCES genre(genre_id),
        FOREIGN KEY (content_id) REFERENCES content(content_id)
    );

    -- Fill in the table with top 10 content per genre (according to views over the last 30 days)
    INSERT INTO popular_content_rankings (genre_id, content_id, view_count, ranking)
    SELECT
        g.genre_id,
        c.content_id,
        COUNT(ch.watch_id) AS view_count,
        RANK() OVER (PARTITION BY g.genre_id ORDER BY COUNT(ch.watch_id) DESC) AS ranking
    FROM genre g
    JOIN content c ON c.genre_id = g.genre_id
    LEFT JOIN content_watchhistory ch ON ch.content_id = c.content_id
        AND ch.date_watched >= DATE_SUB(CURRENT_DATE, INTERVAL 30 DAY)
    GROUP BY g.genre_id, c.content_id
    HAVING ranking <= 10;
END;
//

DELIMITER ;

-- Enable the event scheduler, if this is not already enabled.
SET GLOBAL event_scheduler = ON;
