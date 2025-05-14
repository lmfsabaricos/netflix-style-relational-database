
DELIMITER //

-- Shows which genres got the most watch time (in hours)
CREATE PROCEDURE get_top_genres_by_watch_hours()
BEGIN
    SELECT
        g.name AS genre_name,
        ROUND(SUM(c.duration * (ch.progress / 100)) / 60, 2) AS total_watch_hours
    FROM Content c
    JOIN Genre g ON c.genre_id = g.genre_id
    JOIN Content_WatchHistory ch ON c.content_id = ch.content_id
    GROUP BY g.name
    ORDER BY total_watch_hours DESC;
END;
//

DELIMITER //
-- Shows top 5 actor-director duos that worked together the most
CREATE PROCEDURE get_top_actor_director_pairs()
BEGIN
    SELECT
        ac.actor_id,
        a.name AS actor_name,
        c.director_id,
        d.name AS director_name,
        COUNT(*) AS pair_count
    FROM actor_content ac
    JOIN actor a ON ac.actor_id = a.actor_id
    JOIN content c ON ac.content_id = c.content_id
    JOIN director d ON c.director_id = d.director_id
    GROUP BY ac.actor_id, c.director_id
    ORDER BY pair_count DESC
    LIMIT 5;
END;
//

DELIMITER ;



DELIMITER //

-- Monthly User Activity Report
-- This procedure gathers what each user did in the last month:
-- - How many content items they watched
-- - Average rating they gave
-- - Total time they spent watching

CREATE PROCEDURE generate_monthly_user_activity()
BEGIN
    DROP TEMPORARY TABLE IF EXISTS monthly_user_activity;

    CREATE TEMPORARY TABLE monthly_user_activity AS
    SELECT
        u.user_id,
        u.name AS user_name,
        COUNT(DISTINCT ch.content_id) AS content_watched,
        AVG(r.rating) AS avg_rating,
        ROUND(SUM(c.duration * (ch.progress / 100)) / 60, 2) AS total_hours
    FROM User u
    LEFT JOIN Content_WatchHistory ch ON ch.user_id = u.user_id
    LEFT JOIN Content c ON c.content_id = ch.content_id
    LEFT JOIN Review r ON r.user_id = u.user_id
    WHERE ch.date_watched >= DATE_SUB(CURDATE(), INTERVAL 1 MONTH)
    GROUP BY u.user_id, u.name;

    SELECT * FROM monthly_user_activity;
END;
//

DELIMITER //

-- Batch Content Availability Update
-- This enables you to update several content entries according to release date and view count.


DELIMITER //

CREATE PROCEDURE batch_update_content_availability(
    IN cutoff_date DATE,
    IN min_views INT,
    IN new_status VARCHAR(20)
)
BEGIN
    UPDATE Content_Availability ca
    JOIN (
        SELECT c.availability_id, c.content_id
        FROM Content c
        JOIN Content_Release cr ON c.release_id = cr.release_id
        JOIN (
            SELECT content_id
            FROM Content_WatchHistory
            GROUP BY content_id
            HAVING COUNT(*) >= min_views
        ) AS high_views ON c.content_id = high_views.content_id
        WHERE cr.release_date <= cutoff_date
    ) AS eligible ON ca.availability_id = eligible.availability_id
    SET ca.status = new_status;

    -- Show what was updated
    SELECT c.content_id, c.title, ca.status AS updated_status
    FROM Content c
    JOIN Content_Availability ca ON ca.availability_id = c.availability_id
    WHERE ca.status = new_status;
END;
//

DELIMITER ;


-- Failed Payment Handler
-- This logs failed payment attempts and sends notifications to affected users

CREATE PROCEDURE handle_failed_payment(
    IN user_id_input INT,
    IN payment_method_input INT,
    IN plan_input INT,
    IN amount_input DECIMAL(6,2)
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Something went wrong during the failed payment process.';
    END;

    START TRANSACTION;

    -- Log the failed transaction
    INSERT INTO Transaction (
        user_id,
        payment_method_id,
        plan_id,
        transaction_date,
        amount_paid,
        status
    ) VALUES (
        user_id_input,
        payment_method_input,
        plan_input,
        CURDATE(),
        amount_input,
        'failed'
    );

    -- Notify the user
    INSERT INTO User_Notification (
        user_id,
        notification_type,
        message
    ) VALUES (
        user_id_input,
        'payment_failed',
        CONCAT('Your payment of $', amount_input, ' was not successful. Please update your payment method.')
    );

    COMMIT;
END;
//

DELIMITER ;
