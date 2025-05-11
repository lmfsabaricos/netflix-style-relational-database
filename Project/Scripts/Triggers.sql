
DELIMITER //

-- 1. Watchlist Limit Trigger
-- This trigger verifies whether a user had 50 items in their watchlist already.
-- If they do then the system will remove the oldest before adding the new item


CREATE TRIGGER before_watchlist_insert
BEFORE INSERT ON watchlist_content
FOR EACH ROW
BEGIN
    DECLARE total_items INT;

    SELECT COUNT(*) INTO total_items
    FROM watchlist_content
    WHERE watchlist_id = NEW.watchlist_id;

    IF total_items >= 50 THEN
        DELETE FROM watchlist_content
        WHERE watchlist_id = NEW.watchlist_id
        AND added_date = (
            SELECT MIN(added_date)
            FROM watchlist_content
            WHERE watchlist_id = NEW.watchlist_id
        )
        LIMIT 1;
    END IF;
END;
//

-- 2. Rating Check for Content Availability
-- After a reviewer leaves a review, this trigger then checks the new average rating.
-- If the Average is below 2.0 it is marked as ‘Archived’.

CREATE TRIGGER after_review_insert
AFTER INSERT ON review
FOR EACH ROW
BEGIN
    DECLARE avg_score DECIMAL(3,2);

    SELECT AVG(rating) INTO avg_score
    FROM review
    WHERE content_id = NEW.content_id;

    IF avg_score < 2.0 THEN
        UPDATE content_availability ca
        JOIN content c ON ca.availability_id = c.availability_id
        SET ca.status = 'Archived'
        WHERE c.content_id = NEW.content_id;
    END IF;
END;
//

-- 3. Prevent Duplicate Director Assignment
--  This trigger stops someone from assigning the same director to the same content again.
-- If it happens, the attempt is logged and the update is blocked.

CREATE TRIGGER before_director_update
BEFORE UPDATE ON content
FOR EACH ROW
BEGIN
    IF NEW.director_id = OLD.director_id THEN
        INSERT INTO director_assignment_errors (
            content_id,
            director_id,
            error_message
        ) VALUES (
            NEW.content_id,
            NEW.director_id,
            'Duplicate director assignment attempt.'
        );

        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'This director is already assigned to the content.';
    END IF;
END;
//

DELIMITER ;
