CREATE DATABASE instaproject;
USE instaproject;
CREATE TABLE Users (
    id INT PRIMARY KEY AUTO_INCREMENT,
    user_name VARCHAR(300) NOT NULL UNIQUE,
    email VARCHAR(250) NOT NULL,
    mobile VARCHAR(10) NOT NULL CHECK(LENGTH(mobile) = 10),
    created_at TIMESTAMP DEFAULT NOW()
);
INSERT INTO Users (user_name, email, mobile) VALUES
('hacker_vasu', 'vasuhacker@gmail.com', '9988775544'),
('pra_bash_rebel', 'rebelbash@gmail.com', '8500075000'),
('kalapana_queen', 'unique_queen@gmail.com', '7569900800'),
('gowtham_mptc', 'powerstar_mptc@gmail.com', '9100560143'),
('rashmika_little_princess', 'princess_rashmika@gmail.com', '9700856956'),
('bapatla_prince', 'prince_bapatla@gmail.com', '9600075000'),
('prasad_harihara', 'veera_prasad@gmail.com', '8500074745'),
('pilli_venkata-simha', 'simhavenkat@gmail.com', '9640123143'),
('trendy_joel', 'hearthacker@gmail.com', '7500096000'),
('tiger_nayeem', 'juniortigernayeem@gmail.com', '9550950143');
SELECT * FROM Users;
CREATE TABLE Photos (
    id INT PRIMARY KEY AUTO_INCREMENT,
    image_url VARCHAR(70) NOT NULL UNIQUE,
    user_id INT NOT NULL,
    created_at TIMESTAMP DEFAULT NOW(),
    FOREIGN KEY(user_id) REFERENCES Users(id)
);
INSERT INTO Photos (image_url, user_id) VALUES
('one.com',1),
('two.com',2),
('thre.com',3),
('foo.com',4),
('ojbn.com',7),
('hiio.com',10),
('tjfwo.com',1),
('twfkjno.com',4),
('fjbn.com',4),
('tkj.com',4),
('khjb .com',4);
SELECT * FROM Photos;
CREATE TABLE Follows (
    follower_id INT NOT NULL,
    followee_id INT NOT NULL,
    created_at TIMESTAMP DEFAULT NOW(),
    FOREIGN KEY(follower_id) REFERENCES Users(id),
    FOREIGN KEY(followee_id) REFERENCES Users(id),
    PRIMARY KEY(follower_id, followee_id)
);
INSERT INTO Follows (follower_id, followee_id) VALUES
(6,4),(6,3),(6,7),(6,2),
(4,10),(4,9),(4,5),(4,1),(4,7),
(1,4),(1,6),
(5,3),(5,6),(5,10),
(2,3),(2,5),(2,6),(2,9),
(9,6),(9,4),(9,5);

#How many people follow each user?
SELECT
    u.id,
    u.user_name,
    COUNT(f.follower_id) AS followers
FROM Users u
LEFT JOIN Follows f
    ON u.id = f.followee_id
GROUP BY u.id, u.user_name;

#Number of People Each User Follows
SELECT
    u.id,
    u.user_name,
    COUNT(f.followee_id) AS following
FROM Users u
LEFT JOIN Follows f
    ON u.id = f.follower_id
GROUP BY u.id, u.user_name;

#Number of Users With Zero Followers
SELECT COUNT(*) AS zero_followers
FROM Users u
LEFT JOIN Follows f
    ON u.id = f.followee_id
WHERE f.follower_id IS NULL;

#Number of Users Having At Least 1 Follower
SELECT COUNT(DISTINCT u.id) AS users_with_followers
FROM Users u
JOIN Follows f
    ON u.id = f.followee_id;

#Number of Users Not Following Anyone
SELECT COUNT(*) AS users_not_following
FROM Users u
LEFT JOIN Follows f
    ON u.id = f.follower_id
WHERE f.followee_id IS NULL;

#Number of Users Following At Least 1 Person
SELECT COUNT(DISTINCT u.id) AS users_following
FROM Users u
JOIN Follows f
    ON u.id = f.follower_id;

#Followers AND Following of Every User
SELECT
    u.id,
    u.user_name,
    COUNT(DISTINCT f1.follower_id) AS followers,
    COUNT(DISTINCT f2.followee_id) AS following
FROM Users u
LEFT JOIN Follows f1
    ON u.id = f1.followee_id
LEFT JOIN Follows f2
    ON u.id = f2.follower_id
GROUP BY u.id, u.user_name;

#Create Likes Table
CREATE TABLE Likes (
    user_id INT NOT NULL,
    photo_id INT NOT NULL,
    created_at TIMESTAMP DEFAULT NOW(),
    FOREIGN KEY(user_id) REFERENCES Users(id),
    FOREIGN KEY(photo_id) REFERENCES Photos(id),
    PRIMARY KEY(user_id, photo_id)
);

#Insert Likes
INSERT INTO Likes (user_id, photo_id) VALUES
(1,2),(1,4),(1,5),(1,7),(1,8),(1,9),(1,11),(1,10),
(2,1),(2,3),(2,6),(2,7),(2,11),
(3,1),(3,2),(3,3),(3,4),(3,10),(3,11),
(4,3),(4,6),(4,9),
(7,3),(7,8),(7,9),(7,11),
(9,2),(9,4),(9,6),(9,9),(9,10),(9,11),
(10,1),(10,2),(10,3),(10,4),(10,5),(10,6),(10,7),(10,10);

#Number of Likes for Each Photo
SELECT
    p.id AS photo_id,
    p.image_url,
    COUNT(l.user_id) AS total_likes
FROM Photos p
LEFT JOIN Likes l
    ON p.id = l.photo_id
GROUP BY p.id, p.image_url;

#Photos Having Zero Likes
SELECT
    p.id,
    p.image_url
FROM Photos p
LEFT JOIN Likes l
    ON p.id = l.photo_id
WHERE l.user_id IS NULL;

#Photos Having At Least 1 Like
SELECT
    p.id,
    p.image_url,
    COUNT(l.user_id) AS total_likes
FROM Photos p
JOIN Likes l
    ON p.id = l.photo_id
GROUP BY p.id, p.image_url;

#Number of Likes Given by Each User
SELECT
    u.id,
    u.user_name,
    COUNT(l.photo_id) AS likes_given
FROM Users u
LEFT JOIN Likes l
    ON u.id = l.user_id
GROUP BY u.id, u.user_name;

#Users Who Didn't Like Any Photo
SELECT
    u.id,
    u.user_name
FROM Users u
LEFT JOIN Likes l
    ON u.id = l.user_id
WHERE l.photo_id IS NULL;

#Users Who Liked At Least One Photo
SELECT
    u.id,
    u.user_name,
    COUNT(l.photo_id) AS likes_given
FROM Users u
JOIN Likes l
    ON u.id = l.user_id
GROUP BY u.id, u.user_name;

CREATE TABLE Comments (
    id INT PRIMARY KEY AUTO_INCREMENT,
    c_text TEXT NOT NULL,
    photo_id INT NOT NULL,
    user_id INT NOT NULL,
    created_at TIMESTAMP DEFAULT NOW(),
    FOREIGN KEY(photo_id) REFERENCES Photos(id),
    FOREIGN KEY(user_id) REFERENCES Users(id)
);

INSERT INTO Comments
(c_text, photo_id, user_id, created_at)
VALUES
('Awesome shot',1,2,'2025-09-08 16:05:00'),
('Love this click',1,3,'2025-09-08 16:25:00'),
('Nice one!',2,1,'2025-09-08 17:10:00'),
('Cool vibes',3,5,'2025-09-08 18:00:00'),
('Sharp details',4,6,'2025-09-08 18:45:00'),
('Creative angle',6,10,'2025-09-09 10:10:00'),
('Well framed',7,2,'2025-09-09 11:30:00'),
('Epic vibes',8,7,'2025-09-09 12:15:00'),
('Looks amazing',9,9,'2025-09-09 13:20:00'),
('Legendary shot',10,3,'2025-09-09 14:00:00'),
('This is cool',1,9,'2025-09-10 09:05:00'),
('Great capture',2,6,'2025-09-10 09:50:00'),
('Classic moment',3,1,'2025-09-10 10:40:00'),
('Really nice',4,2,'2025-09-10 11:30:00'),
('High quality',6,7,'2025-09-10 12:15:00'),
('Very creative',7,10,'2025-09-10 13:20:00'),
('Nice memory',8,5,'2025-09-10 14:10:00'),
('Perfect lighting',9,2,'2025-09-10 15:05:00'),
('Amazing shot',10,1,'2025-09-10 16:00:00'),
('So aesthetic',1,6,'2025-09-11 09:20:00'),
('Tiger mode',2,10,'2025-09-11 10:15:00'),
('Epic one',3,9,'2025-09-11 11:00:00'),
('Good vibes',4,5,'2025-09-11 11:40:00'),
('Beautiful pic',6,3,'2025-09-11 12:30:00'),
('Lovely shot',7,1,'2025-09-11 13:15:00'),
('Superb clarity',8,2,'2025-09-11 14:00:00'),
('Nice background',9,10,'2025-09-11 15:10:00'),
('Wonderful shot',10,7,'2025-09-11 16:20:00'),
('Cool style',1,5,'2025-09-12 09:30:00'),
('Elegant frame',2,3,'2025-09-12 10:10:00');

SELECT
    u.id,
    u.user_name,
    COUNT(c.id) AS comments_posted
FROM Users u
LEFT JOIN Comments c
    ON u.id = c.user_id
GROUP BY u.id, u.user_name;

#Number of Comments Posted by Each User
SELECT
    u.id,
    u.user_name,
    COUNT(c.id) AS comments_posted
FROM Users u
LEFT JOIN Comments c
    ON u.id = c.user_id
GROUP BY u.id, u.user_name;

#Number of Comments Each Photo Got
SELECT
    p.id AS photo_id,
    p.image_url,
    COUNT(c.id) AS total_comments
FROM Photos p
LEFT JOIN Comments c
    ON p.id = c.photo_id
GROUP BY p.id, p.image_url;

#Users Who Have Not Commented
SELECT
    u.id,
    u.user_name
FROM Users u
LEFT JOIN Comments c
    ON u.id = c.user_id
WHERE c.id IS NULL;

#Photos With No Comments
SELECT
    p.id,
    p.image_url
FROM Photos p
LEFT JOIN Comments c
    ON p.id = c.photo_id
WHERE c.id IS NULL;

#Photos Having At Least 3 Comments
SELECT
    p.id,
    p.image_url,
    COUNT(c.id) AS total_comments
FROM Photos p
JOIN Comments c
    ON p.id = c.photo_id
GROUP BY p.id, p.image_url
HAVING COUNT(c.id) >= 3;

#Users Who Commented At Least Twice
SELECT
    u.id,
    u.user_name,
    COUNT(c.id) AS total_comments
FROM Users u
JOIN Comments c
    ON u.id = c.user_id
GROUP BY u.id, u.user_name
HAVING COUNT(c.id) >= 2;
