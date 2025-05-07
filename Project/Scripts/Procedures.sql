-- Procedure-based Requirements Implementation

-- 7. Generate Monthly User Activity Report
-- Generate a report detailing user activity for the past month

DELIMITER //

CREATE PROCEDURE generate_monthly_user_activity_report()
BEGIN
    -- Create temporary table for the report
    DROP TEMPORARY TABLE IF EXISTS monthly_activity;
    CREATE TEMPORARY TABLE monthly_activity (
        user_id INT,
        user_name VARCHAR(100),
        content_watched INT,
        avg_rating DECIMAL(3,2),
        total_hours DECIMAL(10,2)
    );
    
    -- Insert activity data
    INSERT INTO monthly_activity
    SELECT 
        u.user_id,
        u.name,
        COUNT(DISTINCT ch.content_id) AS content_watched,
        AVG(r.rating) AS avg_rating,
        SUM(c.duration * (ch.progress / 100.0)) / 60 AS total_hours
    FROM User u
    LEFT JOIN Content_WatchHistory ch ON ch.user_id = u.user_id
    LEFT JOIN Content c ON c.content_id = ch.content_id
    LEFT JOIN Review r ON r.user_id = u.user_id
    WHERE ch.date_watched >= DATE_SUB(CURRENT_DATE, INTERVAL 1 MONTH)
    GROUP BY u.user_id, u.name;
    
    -- Return the report
    SELECT * FROM monthly_activity
    ORDER BY total_hours DESC;
    
    -- Clean up
    DROP TEMPORARY TABLE IF EXISTS monthly_activity;
END //

DELIMITER ;

-- 8. Process Batch Content Updates
-- Update Content_Availability status for multiple Content entries

DELIMITER //

CREATE PROCEDURE update_content_availability(
    IN release_date_threshold DATE,
    IN min_view_count INT,
    IN new_status VARCHAR(20)
)
BEGIN
    -- Update availability status based on criteria
    UPDATE Content_Availability ca
    JOIN Content c ON c.availability_id = ca.availability_id
    SET ca.status = new_status
    WHERE c.release_id IN (
        SELECT release_id 
        FROM Content_Release 
        WHERE release_date <= release_date_threshold
    )
    AND c.content_id IN (
        SELECT content_id
        FROM Content_WatchHistory
        GROUP BY content_id
        HAVING COUNT(*) >= min_view_count
    );
    
    -- Return affected content
    SELECT 
        c.content_id,
        c.title,
        ca.status AS new_availability_status
    FROM Content c
    JOIN Content_Availability ca ON ca.availability_id = c.availability_id
    WHERE ca.status = new_status;
END //

DELIMITER ;

-- 9. Handle Failed Payments
-- Log failed payment attempts and notify users

DELIMITER //

CREATE PROCEDURE handle_failed_payment(
    IN user_id_param INT,
    IN payment_method_id_param INT,
    IN plan_id_param INT,
    IN amount_param DECIMAL(6,2)
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Error processing failed payment';
    END;
    
    START TRANSACTION;
    
    -- Log the failed payment
    INSERT INTO Transaction (
        user_id,
        payment_method_id,
        plan_id,
        transaction_date,
        amount_paid,
        status
    ) VALUES (
        user_id_param,
        payment_method_id_param,
        plan_id_param,
        CURRENT_DATE,
        amount_param,
        'failed'
    );
    
    -- Create notification record (assuming we have a notifications table)
    INSERT INTO User_Notification (
        user_id,
        notification_type,
        message,
        created_date
    ) VALUES (
        user_id_param,
        'payment_failed',
        CONCAT('Your payment of $', amount_param, ' has failed. Please update your payment method.'),
        CURRENT_DATE
    );
    
    -- Update subscription status if needed
    UPDATE User_Subscription
    SET status = 'expired'
    WHERE user_id = user_id_param
    AND plan_id = plan_id_param
    AND status = 'active';
    
    COMMIT;
END //

DELIMITER ; 