-- Trigger-based Requirements Implementation

-- 1. Limit Watchlist Capacity
-- Enforce a maximum of 50 items in a user's Watchlist
-- Automatically remove the oldest item if the user adds an item exceeding the limit

DELIMITER //

CREATE TRIGGER before_watchlist_content_insert
BEFORE INSERT ON Watchlist_Content
FOR EACH ROW
BEGIN
    DECLARE item_count INT;
    
    -- Count current items in the watchlist
    SELECT COUNT(*) INTO item_count
    FROM Watchlist_Content
    WHERE watchlist_id = NEW.watchlist_id;
    
    -- If adding this item would exceed 50, remove the oldest item
    IF item_count >= 50 THEN
        DELETE FROM Watchlist_Content
        WHERE watchlist_id = NEW.watchlist_id
        AND added_date = (
            SELECT MIN(added_date)
            FROM Watchlist_Content
            WHERE watchlist_id = NEW.watchlist_id
        )
        LIMIT 1;
    END IF;
END //

DELIMITER ;

-- 2. Rating Impact on Content Availability
-- Automatically set Content_Availability status to "Archived" if average rating falls below 2.0

DELIMITER //

CREATE TRIGGER after_review_insert
AFTER INSERT ON Review
FOR EACH ROW
BEGIN
    DECLARE avg_rating DECIMAL(3,2);
    
    -- Calculate average rating for the content
    SELECT AVG(rating) INTO avg_rating
    FROM Review
    WHERE content_id = NEW.content_id;
    
    -- If average rating is below 2.0, update availability status
    IF avg_rating < 2.0 THEN
        UPDATE Content_Availability ca
        JOIN Content c ON c.availability_id = ca.availability_id
        SET ca.status = 'unavailable'
        WHERE c.content_id = NEW.content_id;
    END IF;
END //

DELIMITER ;

-- 3. Ensure Unique Director for Content
-- Prevent duplicate Director entries for the same Content
-- Log failed attempts in Director_Assignment_Errors table

-- First, create the error logging table
CREATE TABLE IF NOT EXISTS Director_Assignment_Errors (
    error_id INT PRIMARY KEY AUTO_INCREMENT,
    content_id INT NOT NULL,
    director_id INT NOT NULL,
    error_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    error_message VARCHAR(255),
    FOREIGN KEY (content_id) REFERENCES Content(content_id),
    FOREIGN KEY (director_id) REFERENCES Director(director_id)
);

DELIMITER //

CREATE TRIGGER before_content_director_update
BEFORE UPDATE ON Content
FOR EACH ROW
BEGIN
    -- Check if the director is already assigned to this content
    IF EXISTS (
        SELECT 1 
        FROM Content 
        WHERE director_id = NEW.director_id 
        AND content_id = NEW.content_id
    ) THEN
        -- Log the error
        INSERT INTO Director_Assignment_Errors 
        (content_id, director_id, error_message)
        VALUES 
        (NEW.content_id, NEW.director_id, 'Attempted to assign duplicate director');
        
        -- Prevent the update
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Cannot assign duplicate director to content';
    END IF;
END //

DELIMITER ; 