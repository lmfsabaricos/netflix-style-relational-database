USE MultimediaContentDB;

-- Drop all referencing tables first
--DROP TABLE IF EXISTS Content_WatchHistory;
--DROP TABLE IF EXISTS Watchlist_Content;
--DROP TABLE IF EXISTS Watchlist;
--DROP TABLE IF EXISTS Review;
--DROP TABLE IF EXISTS Playlist_Content;
--DROP TABLE IF EXISTS Playlist;
--DROP TABLE IF EXISTS Tag_Content;
--DROP TABLE IF EXISTS Tag;
--DROP TABLE IF EXISTS Actor_Content;
--DROP TABLE IF EXISTS Actor;

-- Drop core content table
--DROP TABLE IF EXISTS Content;

-- Drop all reference tables
--DROP TABLE IF EXISTS Director;
--DROP TABLE IF EXISTS Content_Format;
--DROP TABLE IF EXISTS Content_Availability;
--DROP TABLE IF EXISTS Content_Accessibility;
--DROP TABLE IF EXISTS Content_Release;
--DROP TABLE IF EXISTS Genre;
--DROP TABLE IF EXISTS Rating;
--DROP TABLE IF EXISTS Country;

-- Drop subscription/payment/user core tables
--DROP TABLE IF EXISTS Transaction;
--DROP TABLE IF EXISTS User_Subscription;
--DROP TABLE IF EXISTS Subscription_Plan;
--DROP TABLE IF EXISTS Payment_Method;
--DROP TABLE IF EXISTS User;

CREATE TABLE User (
    user_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    created_date DATE NOT NULL
);

CREATE TABLE Subscription_Plan (
    plan_id INT PRIMARY KEY AUTO_INCREMENT,
    price DECIMAL(6,2) NOT NULL,
    duration INT NOT NULL,
    plan_name VARCHAR(50) NOT NULL,
    description TEXT
);

CREATE TABLE User_Subscription (
    subscription_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    plan_id INT NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    status ENUM('active', 'expired') DEFAULT 'active', -- to track status values, active when no value

    FOREIGN KEY (user_id) REFERENCES User(user_id),
    FOREIGN KEY (plan_id) REFERENCES Subscription_Plan(plan_id)
);

CREATE TABLE Payment_Method (
    payment_method_id INT PRIMARY KEY AUTO_INCREMENT,
    method_type VARCHAR(50) NOT NULL,        -- eg., Credit Card, PayPal
    provider_name VARCHAR(100),              -- eg., Visa, Amex
    account_number VARCHAR(20),               -- eg, **** 1234
    billing_address TEXT
);

CREATE TABLE Transaction (
    transaction_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    payment_method_id INT NOT NULL,
    plan_id INT NOT NULL,
    transaction_date DATE NOT NULL,
    amount_paid DECIMAL(6,2) NOT NULL,
    status ENUM('completed', 'pending', 'failed') DEFAULT 'completed',
    FOREIGN KEY (user_id) REFERENCES User(user_id),
    FOREIGN KEY (payment_method_id) REFERENCES Payment_Method(payment_method_id),
    FOREIGN KEY (plan_id) REFERENCES Subscription_Plan(plan_id)
);

CREATE TABLE Country (
    country_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL
);

CREATE TABLE Rating (
    rating_id INT PRIMARY KEY AUTO_INCREMENT,
    rating_label VARCHAR(10) NOT NULL, -- eg, 'PG-13'
    description TEXT
);

CREATE TABLE Genre (
    genre_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    description TEXT
);

CREATE TABLE Content_Release (
    release_id INT PRIMARY KEY AUTO_INCREMENT,
    release_date DATE NOT NULL,
    platform VARCHAR(100) NOT NULL         -- eg, 'Netflix'
);

CREATE TABLE Content_Accessibility (
    accessibility_id INT PRIMARY KEY AUTO_INCREMENT,
    type VARCHAR(50) NOT NULL,  -- eg, Subtitles
    language VARCHAR(50)        -- eg, English, Spanish
);

CREATE TABLE Content_Availability (
    availability_id INT PRIMARY KEY AUTO_INCREMENT,
    region VARCHAR(100) NOT NULL,      -- eg, US,Europe
    status ENUM('available', 'unavailable') DEFAULT 'available'
);

CREATE TABLE Content_Format (
    format_id INT PRIMARY KEY AUTO_INCREMENT,
    format_type VARCHAR(50) NOT NULL  -- eg, HD
);

CREATE TABLE Director (
    director_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    bio TEXT
);

CREATE TABLE Content (
    content_id INT PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(150) NOT NULL,
    description TEXT,
    duration INT,

    genre_id INT,
    rating_id INT,
    release_id INT,
    country_id INT,
    accessibility_id INT,
    availability_id INT,
    format_id INT,
    director_id INT,

    FOREIGN KEY (genre_id) REFERENCES Genre(genre_id),
    FOREIGN KEY (rating_id) REFERENCES Rating(rating_id),
    FOREIGN KEY (release_id) REFERENCES Content_Release(release_id),
    FOREIGN KEY (country_id) REFERENCES Country(country_id),
    FOREIGN KEY (accessibility_id) REFERENCES Content_Accessibility(accessibility_id),
    FOREIGN KEY (availability_id) REFERENCES Content_Availability(availability_id),
    FOREIGN KEY (format_id) REFERENCES Content_Format(format_id),
    FOREIGN KEY (director_id) REFERENCES Director(director_id)
);

CREATE TABLE Actor (
    actor_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    bio TEXT
);

CREATE TABLE Actor_Content (
    content_id INT,
    actor_id INT,
    actor_role VARCHAR(100),

    PRIMARY KEY (content_id, actor_id),
    FOREIGN KEY (content_id) REFERENCES Content(content_id),
    FOREIGN KEY (actor_id) REFERENCES Actor(actor_id)
);


CREATE TABLE Tag (
    tag_id INT PRIMARY KEY AUTO_INCREMENT,
    tag_name VARCHAR(100) NOT NULL         -- 'Comedy'
);

CREATE TABLE Tag_Content (
    content_id INT,
    tag_id INT,

    PRIMARY KEY (content_id, tag_id),
    FOREIGN KEY (content_id) REFERENCES Content(content_id),
    FOREIGN KEY (tag_id) REFERENCES Tag(tag_id)
);


CREATE TABLE Playlist (
    playlist_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    title VARCHAR(255) NOT NULL,
    created_date DATE NOT NULL,

    FOREIGN KEY (user_id) REFERENCES User(user_id)
);

CREATE TABLE Playlist_Content (
    playlist_id INT,
    content_id INT,
    added_date DATE NOT NULL,
    description TEXT,

    PRIMARY KEY (playlist_id, content_id),
    FOREIGN KEY (playlist_id) REFERENCES Playlist(playlist_id),
    FOREIGN KEY (content_id) REFERENCES Content(content_id)
);

CREATE TABLE Review (
    review_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    content_id INT NOT NULL,
    rating INT CHECK (rating BETWEEN 1 AND 5), -- 5 point system
    review_description TEXT,
    created_date DATE NOT NULL,

    FOREIGN KEY (user_id) REFERENCES User(user_id),
    FOREIGN KEY (content_id) REFERENCES Content(content_id)
);

CREATE TABLE Watchlist (
    watchlist_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    created_date DATE NOT NULL,

    FOREIGN KEY (user_id) REFERENCES User(user_id)
);

CREATE TABLE Watchlist_Content (
    watchlist_id INT,
    content_id INT,
    added_date DATE NOT NULL,
    description TEXT,

    PRIMARY KEY (watchlist_id, content_id),
    FOREIGN KEY (watchlist_id) REFERENCES Watchlist(watchlist_id),
    FOREIGN KEY (content_id) REFERENCES Content(content_id)
);


CREATE TABLE Content_WatchHistory (
    watch_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    content_id INT NOT NULL,
    date_watched DATE NOT NULL,
    progress INT CHECK (progress BETWEEN 0 AND 100),  -- percent

    FOREIGN KEY (user_id) REFERENCES User(user_id),
    FOREIGN KEY (content_id) REFERENCES Content(content_id)
);