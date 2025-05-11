DELIMITER //

-- Will identify the top 3 genres that has the highest viewing hours over the last 30 days.

CREATE FUNCTION get_top_genres_by_watch_hours()
RETURNS VARCHAR(1000)
DETERMINISTIC
BEGIN
    DECLARE result VARCHAR(1000);

    SELECT GROUP_CONCAT(CONCAT(genre_name, ' (', total_hours, ' hrs)') SEPARATOR ', ')
    INTO result
    FROM (
        SELECT
            g.name AS genre_name,
            ROUND(SUM(c.duration * (ch.progress / 100.0)) / 60, 2) AS total_hours
        FROM Genre g
        JOIN Content c ON c.genre_id = g.genre_id
        JOIN Content_WatchHistory ch ON ch.content_id = c.content_id
        WHERE ch.date_watched >= DATE_SUB(CURDATE(), INTERVAL 30 DAY)
        GROUP BY g.genre_id
        ORDER BY total_hours DESC
        LIMIT 3
    ) AS TopGenres;

    RETURN result;
END;
//

-- Most Frequent Collaborators
-- Returns the top 5 actor-director pairs with the most collaborations.

CREATE FUNCTION get_top_actor_director_pairs()
RETURNS VARCHAR(1000)
DETERMINISTIC
BEGIN
    DECLARE result VARCHAR(1000);

    SELECT GROUP_CONCAT(CONCAT(actor_name, ' & ', director_name, ' (', project_count, ' projects)') SEPARATOR ', ')
    INTO result
    FROM (
        SELECT
            a.name AS actor_name,
            d.name AS director_name,
            COUNT(DISTINCT c.content_id) AS project_count
        FROM Actor a
        JOIN Actor_Content ac ON a.actor_id = ac.actor_id
        JOIN Content c ON ac.content_id = c.content_id
        JOIN Director d ON c.director_id = d.director_id
        GROUP BY a.actor_id, d.director_id
        ORDER BY project_count DESC
        LIMIT 5
    ) AS TopPairs;

    RETURN result;
END;
//

-- 3. Check Subscription Status
-- Returns 'Active', 'Expired', or 'No Subscription' for a given user.

CREATE FUNCTION check_subscription_status(user_id_input INT)
RETURNS VARCHAR(20)
DETERMINISTIC
BEGIN
    DECLARE status_result VARCHAR(20);
    DECLARE latest_start DATE;
    DECLARE plan_duration INT;

    -- Get most recent subscription info
    SELECT us.start_date, sp.duration
    INTO latest_start, plan_duration
    FROM User_Subscription us
    JOIN Subscription_Plan sp ON us.plan_id = sp.plan_id
    WHERE us.user_id = user_id_input
    ORDER BY us.start_date DESC
    LIMIT 1;

    -- Determine current status
    IF latest_start IS NULL THEN
        SET status_result = 'No Subscription';
    ELSEIF DATE_ADD(latest_start, INTERVAL plan_duration DAY) < CURRENT_DATE THEN
        SET status_result = 'Expired';
    ELSE
        SET status_result = 'Active';
    END IF;

    RETURN status_result;
END;
//

DELIMITER ;
