CREATE database wiki;
USE wiki;
DROP TABLE users_clean;
DROP TABLE articles_clean;
DROP TABLE donations_clean;
DROP TABLE article_analysis;


CREATE TABLE users_clean (
    user_id INT PRIMARY KEY,
    name VARCHAR(50),
    email VARCHAR(50),
    nickname VARCHAR(50),
    credibility_score DECIMAL(5,2)
);

INSERT INTO users_clean (user_id, name, email, nickname, credibility_score)
SELECT
    CAST(id AS UNSIGNED) AS user_id,
    TRIM(name),
    TRIM(email),
    TRIM(nickname),
    IF(credibility_scores < 0 or credibility_scores > 100, NULL, CAST(credibility_scores AS DECIMAL(5,2)))
from users;

CREATE TABLE articles_clean (
article_id INT PRIMARY KEY auto_increment,
title VARCHAR(250),
nickname VARCHAR(50),
likes INT,
dislikes INT,
publish_date datetime,
url VARCHAR(250),
views INT
);

INSERT INTO articles_clean (title, nickname, likes, dislikes, publish_date, url, views)
SELECT
TRIM(title),
TRIM(user_nickname),
CAST(likes as unsigned),
CAST(not_likes as unsigned),
CAST(publish_date as datetime),
TRIM(url),
FLOOR(views)
From articles;

CREATE TABLE donations_clean (
donation_id INT PRIMARY KEY AUTO_INCREMENT,
article_id INT,
article_name varchar(250),
donation_amount DECIMAL(5, 2),
donation_date datetime,
FOREIGN KEY (article_id) REFERENCES articles_clean(article_id)
);

INSERT into donations_clean(article_id, article_name, donation_amount, donation_date)
SELECT
a.article_id,
trim(d.article),
CAST(d.donation_amount as  DECIMAL(5, 2)),
CAST(d.donation_date as datetime)
From donations d
LEFT JOIN articles_clean a on trim(d.article)=trim(a.title);

select * from donations_clean;

CREATE TABLE article_analysis AS
SELECT
a.article_id,
a.title,
a.likes,
a.dislikes,
a.nickname as author,
u.credibility_score as author_credibility_score,
u.email as author_email,
IF(ISNULL(sum(d.donation_amount)), 0, sum(d.donation_amount)) as total_donation, 
max(d.donation_date) as latest_donation_date
from articles_clean a
LEFT JOIN users_clean u on a.nickname = u.nickname
LEFT JOIN donations_clean d on a.article_id = d.article_id
GROUP BY article_id;


SELECT * FROM article_analysis;

