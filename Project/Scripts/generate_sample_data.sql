-- Generate sample data for MultimediaContentDB

-- Insert sample subscription plans
INSERT INTO Subscription_Plan (price, duration, plan_name, description) VALUES
(9.99, 30, 'Basic', 'Basic streaming plan with standard quality'),
(14.99, 30, 'Premium', 'Premium plan with HD quality'),
(19.99, 30, 'Ultimate', 'Ultimate plan with 4K quality');

-- Insert sample payment methods
INSERT INTO Payment_Method (method_type, provider_name, account_number, billing_address) VALUES
('Credit Card', 'Visa', '****1234', '123 Main St, City, State'),
('PayPal', 'PayPal', 'user@example.com', '456 Oak St, City, State'),
('Credit Card', 'MasterCard', '****5678', '789 Pine St, City, State');

-- Insert sample user subscriptions
INSERT INTO User_Subscription (user_id, plan_id, start_date, end_date, status) VALUES
(1, 1, '2024-01-01', '2024-12-31', 'active'),
(2, 2, '2024-01-01', '2024-12-31', 'active'),
(3, 3, '2024-01-01', '2024-12-31', 'active');

-- Insert sample genres
INSERT INTO Genre (name, description) VALUES
('Action', 'Action movies and shows'),
('Comedy', 'Comedy movies and shows'),
('Drama', 'Drama movies and shows'),
('Sci-Fi', 'Science fiction movies and shows');

-- Insert sample ratings
INSERT INTO Rating (rating_label, description) VALUES
('G', 'General Audiences'),
('PG', 'Parental Guidance Suggested'),
('PG-13', 'Parents Strongly Cautioned'),
('R', 'Restricted');

-- Insert sample countries
INSERT INTO Country (name) VALUES
('United States'),
('United Kingdom'),
('Canada'),
('Australia');

-- Insert sample content formats
INSERT INTO Content_Format (format_type) VALUES
('SD'),
('HD'),
('4K'),
('HDR');

-- Insert sample content accessibility
INSERT INTO Content_Accessibility (type, language) VALUES
('Subtitles', 'English'),
('Subtitles', 'Spanish'),
('Audio Description', 'English'),
('Closed Captions', 'English');

-- Insert sample content availability
INSERT INTO Content_Availability (region, status) VALUES
('US', 'available'),
('UK', 'available'),
('CA', 'available'),
('AU', 'available');

-- Insert sample content releases
INSERT INTO Content_Release (release_date, platform) VALUES
('2024-01-01', 'Netflix'),
('2024-02-01', 'Amazon Prime'),
('2024-03-01', 'Disney+'),
('2024-04-01', 'HBO Max');

-- Insert sample directors
INSERT INTO Director (name, bio) VALUES
('John Smith', 'Award-winning director'),
('Jane Doe', 'Independent filmmaker'),
('Robert Johnson', 'Blockbuster director'),
('Sarah Williams', 'Documentary filmmaker');

-- Insert sample content
INSERT INTO Content (title, description, duration, genre_id, rating_id, release_id, country_id, accessibility_id, availability_id, format_id, director_id) VALUES
('The Adventure Begins', 'An epic adventure story', 120, 1, 2, 1, 1, 1, 1, 2, 1),
('Laugh Out Loud', 'A hilarious comedy', 90, 2, 1, 1, 1, 1, 1, 2, 2),
('Drama in the City', 'A compelling drama', 150, 3, 3, 1, 1, 1, 1, 2, 3),
('Space Odyssey', 'A journey through space', 180, 4, 2, 1, 1, 1, 1, 2, 4);

-- Insert sample actors
INSERT INTO Actor (name, bio) VALUES
('Tom Wilson', 'Lead actor'),
('Emma Brown', 'Supporting actress'),
('Michael Lee', 'Character actor'),
('Lisa Chen', 'Rising star');

-- Insert sample actor-content relationships
INSERT INTO Actor_Content (content_id, actor_id, actor_role) VALUES
(1, 1, 'Lead'),
(1, 2, 'Supporting'),
(2, 3, 'Lead'),
(2, 4, 'Supporting');

-- Insert sample tags
INSERT INTO Tag (tag_name) VALUES
('Blockbuster'),
('Indie'),
('Award Winner'),
('Family Friendly');

-- Insert sample tag-content relationships
INSERT INTO Tag_Content (content_id, tag_id) VALUES
(1, 1),
(2, 2),
(3, 3),
(4, 1);

-- Insert sample playlists
INSERT INTO Playlist (user_id, title, created_date) VALUES
(1, 'My Favorites', '2024-01-01'),
(2, 'Weekend Watchlist', '2024-01-01'),
(3, 'Action Movies', '2024-01-01');

-- Insert sample playlist content
INSERT INTO Playlist_Content (playlist_id, content_id, added_date, description) VALUES
(1, 1, '2024-01-01', 'Favorite action movie'),
(2, 2, '2024-01-01', 'Weekend comedy'),
(3, 1, '2024-01-01', 'Action classic');

-- Insert sample watchlists
INSERT INTO Watchlist (user_id, created_date) VALUES
(1, '2024-01-01'),
(2, '2024-01-01'),
(3, '2024-01-01');

-- Insert sample watchlist content
INSERT INTO Watchlist_Content (watchlist_id, content_id, added_date, description) VALUES
(1, 1, '2024-01-01', 'To watch'),
(2, 2, '2024-01-01', 'Weekend watch'),
(3, 3, '2024-01-01', 'Drama to watch');

-- Insert sample watch history
INSERT INTO Content_WatchHistory (user_id, content_id, date_watched, progress) VALUES
(1, 1, '2024-01-01', 100),
(2, 2, '2024-01-01', 75),
(3, 3, '2024-01-01', 50);

-- Insert sample reviews
INSERT INTO Review (user_id, content_id, rating, review_description, created_date) VALUES
(1, 1, 5, 'Great movie!', '2024-01-01'),
(2, 2, 4, 'Very funny', '2024-01-01'),
(3, 3, 5, 'Excellent drama', '2024-01-01'); 