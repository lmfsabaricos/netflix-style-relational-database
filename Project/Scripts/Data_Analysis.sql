
-- Use this script to see how users behave and how popular a content is also to check statistics of reviews

USE MultimediaContentDB;

-- 1. OverView Of User Engagement
-- Illustrates their watch-list’s uniqueness (what number of unique content items each user had viewed),
-- Average and overall watch time in hours including their average progress.

SELECT
    u.user_id,
    u.name AS user_name,
    COUNT(DISTINCT ch.content_id) AS total_content_watched,
    ROUND(AVG(ch.progress), 2) AS avg_watch_progress,
    ROUND(SUM(c.duration * (ch.progress / 100.0)) / 60, 2) AS total_watch_hours
FROM User u
LEFT JOIN Content_WatchHistory ch ON u.user_id = ch.user_id
LEFT JOIN Content c ON ch.content_id = c.content_id
GROUP BY u.user_id, u.name
ORDER BY total_watch_hours DESC
LIMIT 10;

-- 2. Watch Activity by Time of Day
-- Aggregates view counts and user counts by hour (0–23)

SELECT
    HOUR(ch.date_watched) AS hour_of_day,
    COUNT(*) AS watch_count,
    COUNT(DISTINCT ch.user_id) AS unique_users
FROM Content_WatchHistory ch
GROUP BY HOUR(ch.date_watched)
ORDER BY hour_of_day;

-- 3. Top Viewed Content
-- Lists the most viewed content items and related genres and viewer engagement.

SELECT
    c.content_id,
    c.title,
    g.name AS genre,
    COUNT(DISTINCT ch.user_id) AS unique_viewers,
    ROUND(AVG(ch.progress), 2) AS avg_completion_rate
FROM Content c
JOIN Genre g ON c.genre_id = g.genre_id
LEFT JOIN Content_WatchHistory ch ON ch.content_id = c.content_id
GROUP BY c.content_id, c.title, g.name
ORDER BY unique_viewers DESC
LIMIT 10;

-- 4. Most Active Reviewers
-- Returns users who left the maximum number of reviews along with their average rating score

SELECT
    u.user_id,
    u.name AS user_name,
    COUNT(r.review_id) AS total_reviews,
    ROUND(AVG(r.rating), 2) AS avg_rating_given
FROM User u
JOIN Review r ON r.user_id = u.user_id
GROUP BY u.user_id, u.name
ORDER BY total_reviews DESC
LIMIT 10;
