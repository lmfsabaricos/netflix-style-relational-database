CREATE TABLE User (
    user_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    created_date DATE NOT NULL
);

CREATE TABLE Subscription_Plan (
    plan_id INT PRIMARY KEY AUTO_INCREMENT,
    price DECIMAL(6,2),
    duration INT NOT NULL
);

CREATE TABLE User_Subscription (
    subscription_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    plan_id INT NOT NULL,
    start_date DATE,
    end_date DATE,
    FOREIGN KEY (user_id) REFERENCES User(user_id),
    FOREIGN KEY (plan_id) REFERENCES Subscription_Plan(plan_id)
);

CREATE TABLE Payment_Method (
    payment_method_id INT PRIMARY KEY AUTO_INCREMENT
    -- add details like method_type, card info, etc. if needed
);

CREATE TABLE Transaction (
    transaction_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    payment_method_id INT NOT NULL,
    plan_id INT NOT NULL,
    FOREIGN KEY (user_id) REFERENCES User(user_id),
    FOREIGN KEY (payment_method_id) REFERENCES Payment_Method(payment_method_id),
    FOREIGN KEY (plan_id) REFERENCES Subscription_Plan(plan_id)
);

CREATE TABLE Country (
    country_id INT PRIMARY KEY AUTO_INCREMENT
    -- optionally add: name VARCHAR(100)
);

CREATE TABLE Rating (
    rating_id INT PRIMARY KEY AUTO_INCREMENT
    -- optionally add: rating_value, description
);

CREATE TABLE Genre (
    genre_id INT PRIMARY KEY AUTO_INCREMENT
    -- optionally add: name, description
);

CREATE TABLE Content_Release (
    release_id INT PRIMARY KEY AUTO_INCREMENT
    -- optionally add: release_date, platform
);

CREATE TABLE Content_Accessibility (
    accessibility_id INT PRIMARY KEY AUTO_INCREMENT
    -- optionally add: type (e.g., subtitles, audio desc)
);

CREATE TABLE Content_Availability (
    availability_id INT PRIMARY KEY AUTO_INCREMENT
    -- optionally add: region, status
);

CREATE TABLE Content_Format (
    format_id INT PRIMARY KEY AUTO_INCREMENT
    -- optionally add: format_type (HD, 4K, etc)
);

CREATE TABLE Director (
    director_id INT PRIMARY KEY AUTO_INCREMENT
    -- optionally add: name, bio, etc.
);

CREATE TABLE Content (
    content_id INT PRIMARY KEY AUTO_INCREMENT,
    genre_id INT,
    rating_id INT,
    release_id INT,
    country_id INT,
    accessibility INT,
    availability INT,
    format_id INT,
    director_id INT,
    FOREIGN KEY (genre_id) REFERENCES Genre(genre_id),
    FOREIGN KEY (rating_id) REFERENCES Rating(rating_id),
    FOREIGN KEY (release_id) REFERENCES Content_Release(release_id),
    FOREIGN KEY (country_id) REFERENCES Country(country_id),
    FOREIGN KEY (accessibility) REFERENCES Content_Accessibility(accessibility_id),
    FOREIGN KEY (availability) REFERENCES Content_Availability(availability_id),
    FOREIGN KEY (format_id) REFERENCES Content_Format(format_id),
    FOREIGN KEY (director_id) REFERENCES Director(director_id)
);

CREATE TABLE Actor (
    actor_id INT PRIMARY KEY AUTO_INCREMENT
    -- optionally add: name, bio, etc
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
    tag_id INT PRIMARY KEY AUTO_INCREMENT
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
    user_id INT,
    title VARCHAR(255),
    created_date DATE,
    FOREIGN KEY (user_id) REFERENCES User(user_id)
);

CREATE TABLE Playlist_Content (
    playlist_id INT,
    content_id INT,
    created_date DATE,
    description TEXT,
    PRIMARY KEY (playlist_id, content_id),
    FOREIGN KEY (playlist_id) REFERENCES Playlist(playlist_id),
    FOREIGN KEY (content_id) REFERENCES Content(content_id)
);

CREATE TABLE Review (
    review_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT,
    content_id INT,
    rating INT,
    review_description TEXT,
    created_date DATE,
    FOREIGN KEY (user_id) REFERENCES User(user_id),
    FOREIGN KEY (content_id) REFERENCES Content(content_id)
);

CREATE TABLE Watchlist (
    watchlist_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT,
    created_date DATE,
    FOREIGN KEY (user_id) REFERENCES User(user_id)
);

CREATE TABLE Watchlist_Content (
    watchlist_id INT,
    content_id INT,
    created_date DATE,
    description TEXT,
    PRIMARY KEY (watchlist_id, content_id),
    FOREIGN KEY (watchlist_id) REFERENCES Watchlist(watchlist_id),
    FOREIGN KEY (content_id) REFERENCES Content(content_id)
);

CREATE TABLE Content_WatchHistory (
    watch_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT,
    content_id INT,
    date_watched DATE,
    progress INT,
    FOREIGN KEY (user_id) REFERENCES User(user_id),
    FOREIGN KEY (content_id) REFERENCES Content(content_id)
);





