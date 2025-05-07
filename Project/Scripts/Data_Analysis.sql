-- Section IV: Data Analysis Queries

-- 1. User Engagement Analysis
-- 1.1 Average watch time per user
SELECT 
    u.user_id,
    u.username,
    COUNT(DISTINCT ch.content_id) as total_content_watched,
    ROUND(AVG(ch.progress), 2) as avg_watch_progress,
    ROUND(SUM(c.duration * (ch.progress / 100.0)) / 60, 2) as total_watch_hours
FROM User u
LEFT JOIN Content_WatchHistory ch ON u.user_id = ch.user_id
LEFT JOIN Content c ON ch.content_id = c.content_id
GROUP BY u.user_id, u.username
ORDER BY total_watch_hours DESC
LIMIT 10;

-- 1.2 User activity by time of day
SELECT 
    HOUR(date_watched) as hour_of_day,
    COUNT(*) as watch_count,
    COUNT(DISTINCT user_id) as unique_users
FROM Content_WatchHistory
GROUP BY HOUR(date_watched)
ORDER BY hour_of_day;

-- 2. Content Popularity Analysis
-- 2.1 Most watched content
SELECT 
    c.content_id,
    c.title,
    g.name as genre,
    COUNT(DISTINCT ch.user_id) as unique_viewers,
    ROUND(AVG(ch.progress), 2) as avg_completion_rate,
    ROUND(AVG(r.rating), 2) as avg_rating
FROM Content c
JOIN Genre g ON c.genre_id = g.genre_id
LEFT JOIN Content_WatchHistory ch ON c.content_id = ch.content_id
LEFT JOIN Review r ON c.content_id = r.content_id
GROUP BY c.content_id, c.title, g.name
ORDER BY unique_viewers DESC
LIMIT 10;

-- 2.2 Content performance by genre
SELECT 
    g.name as genre,
    COUNT(DISTINCT c.content_id) as total_content,
    COUNT(DISTINCT ch.user_id) as total_viewers,
    ROUND(AVG(r.rating), 2) as avg_rating,
    ROUND(SUM(c.duration * (ch.progress / 100.0)) / 60, 2) as total_watch_hours
FROM Genre g
LEFT JOIN Content c ON g.genre_id = c.genre_id
LEFT JOIN Content_WatchHistory ch ON c.content_id = ch.content_id
LEFT JOIN Review r ON c.content_id = r.content_id
GROUP BY g.name
ORDER BY total_watch_hours DESC;

-- 3. Subscription and Revenue Analysis
-- 3.1 Subscription plan popularity
SELECT 
    sp.plan_name,
    COUNT(DISTINCT us.user_id) as total_subscribers,
    ROUND(AVG(sp.price), 2) as avg_price,
    COUNT(DISTINCT CASE WHEN us.status = 'active' THEN us.user_id END) as active_subscribers
FROM Subscription_Plan sp
LEFT JOIN User_Subscription us ON sp.plan_id = us.plan_id
GROUP BY sp.plan_name
ORDER BY total_subscribers DESC;

-- 3.2 Monthly revenue trends
SELECT 
    DATE_FORMAT(t.transaction_date, '%Y-%m') as month,
    COUNT(DISTINCT t.user_id) as unique_payers,
    ROUND(SUM(t.amount), 2) as total_revenue,
    ROUND(AVG(t.amount), 2) as avg_transaction
FROM Transaction t
GROUP BY DATE_FORMAT(t.transaction_date, '%Y-%m')
ORDER BY month DESC;

-- 4. Content Performance Analysis
-- 4.1 Director performance
SELECT 
    d.name as director,
    COUNT(DISTINCT c.content_id) as total_content,
    ROUND(AVG(r.rating), 2) as avg_rating,
    COUNT(DISTINCT ch.user_id) as total_viewers
FROM Director d
LEFT JOIN Content c ON d.director_id = c.director_id
LEFT JOIN Review r ON c.content_id = r.content_id
LEFT JOIN Content_WatchHistory ch ON c.content_id = ch.content_id
GROUP BY d.name
ORDER BY avg_rating DESC;

-- 4.2 Actor popularity
SELECT 
    a.name as actor,
    COUNT(DISTINCT c.content_id) as total_content,
    ROUND(AVG(r.rating), 2) as avg_rating,
    COUNT(DISTINCT ch.user_id) as total_viewers
FROM Actor a
JOIN Actor_Content ac ON a.actor_id = ac.actor_id
JOIN Content c ON ac.content_id = c.content_id
LEFT JOIN Review r ON c.content_id = r.content_id
LEFT JOIN Content_WatchHistory ch ON c.content_id = ch.content_id
GROUP BY a.name
ORDER BY total_viewers DESC
LIMIT 10;

-- 5. User Behavior Analysis
-- 5.1 Watchlist vs. Watch History correlation
SELECT 
    u.user_id,
    u.username,
    COUNT(DISTINCT wc.content_id) as watchlist_items,
    COUNT(DISTINCT ch.content_id) as watched_items,
    ROUND(COUNT(DISTINCT ch.content_id) * 100.0 / 
        NULLIF(COUNT(DISTINCT wc.content_id), 0), 2) as completion_rate
FROM User u
LEFT JOIN Watchlist w ON u.user_id = w.user_id
LEFT JOIN Watchlist_Content wc ON w.watchlist_id = wc.watchlist_id
LEFT JOIN Content_WatchHistory ch ON u.user_id = ch.user_id
GROUP BY u.user_id, u.username
HAVING watchlist_items > 0
ORDER BY completion_rate DESC;

-- 5.2 User rating patterns
SELECT 
    u.user_id,
    u.username,
    COUNT(r.review_id) as total_reviews,
    ROUND(AVG(r.rating), 2) as avg_rating_given,
    ROUND(STDDEV(r.rating), 2) as rating_std_dev
FROM User u
LEFT JOIN Review r ON u.user_id = r.user_id
GROUP BY u.user_id, u.username
HAVING total_reviews > 0
ORDER BY total_reviews DESC;

-- 6. Content Accessibility Analysis
-- 6.1 Content availability by format
SELECT 
    cf.name as content_format,
    COUNT(DISTINCT c.content_id) as total_content,
    COUNT(DISTINCT ch.user_id) as total_viewers,
    ROUND(AVG(ch.progress), 2) as avg_completion_rate
FROM Content_Format cf
LEFT JOIN Content c ON cf.format_id = c.format_id
LEFT JOIN Content_WatchHistory ch ON c.content_id = ch.content_id
GROUP BY cf.name
ORDER BY total_viewers DESC;

-- 6.2 Accessibility feature usage
SELECT 
    ca.name as accessibility_feature,
    COUNT(DISTINCT c.content_id) as total_content,
    COUNT(DISTINCT ch.user_id) as total_viewers
FROM Content_Accessibility ca
LEFT JOIN Content c ON ca.accessibility_id = c.accessibility_id
LEFT JOIN Content_WatchHistory ch ON c.content_id = ch.content_id
GROUP BY ca.name
ORDER BY total_viewers DESC;

-- 7. Geographic Analysis
-- 7.1 User distribution by country
SELECT 
    co.name as country,
    COUNT(DISTINCT u.user_id) as total_users,
    COUNT(DISTINCT CASE WHEN us.status = 'active' THEN u.user_id END) as active_subscribers,
    ROUND(COUNT(DISTINCT CASE WHEN us.status = 'active' THEN u.user_id END) * 100.0 / 
        NULLIF(COUNT(DISTINCT u.user_id), 0), 2) as subscription_rate
FROM Country co
LEFT JOIN User u ON co.country_id = u.country_id
LEFT JOIN User_Subscription us ON u.user_id = us.user_id
GROUP BY co.name
ORDER BY total_users DESC;

-- 7.2 Content popularity by region
SELECT 
    co.name as country,
    COUNT(DISTINCT c.content_id) as total_content,
    COUNT(DISTINCT ch.user_id) as total_viewers,
    ROUND(AVG(r.rating), 2) as avg_rating
FROM Country co
JOIN User u ON co.country_id = u.country_id
JOIN Content_WatchHistory ch ON u.user_id = ch.user_id
JOIN Content c ON ch.content_id = c.content_id
LEFT JOIN Review r ON c.content_id = r.content_id
GROUP BY co.name
ORDER BY total_viewers DESC; 