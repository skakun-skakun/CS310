-- CREATE SCHEMA demo;

DROP TABLE IF EXISTS demo.users_clean;
DROP TABLE IF EXISTS demo.articles_clean;
DROP TABLE IF EXISTS demo.donations_clean;
DROP TABLE IF EXISTS demo.article_analysis;


CREATE TABLE demo.users_clean (
    user_id INT,
    name STRING,
    email STRING,
    nickname STRING,
    credibility_score NUMERIC
);

INSERT INTO demo.users_clean (user_id, name, email, nickname, credibility_score)
SELECT
    CAST(id AS INT64) AS user_id,
    TRIM(name),
    TRIM(email),
    TRIM(nickname),
    IF(credibility_scores < 0 or credibility_scores > 100, NULL, CAST(credibility_scores AS NUMERIC))
from demo.users;

CREATE TABLE demo.articles_clean (
article_id INT,
title STRING,
nickname STRING,
likes INT,
dislikes INT,
publish_date datetime,
url STRING,
views INT
);

INSERT INTO demo.articles_clean (article_id, title, nickname, likes, dislikes, publish_date, url, views)
SELECT
ROW_NUMBER() OVER() AS article_id,
TRIM(` title`) AS title,
TRIM(user_nickname),
CAST(` likes` as INT64),
CAST(` not_likes` as INT64),
CAST(` publish_date` as datetime),
TRIM(` url`),
CAST(FLOOR(` views`) AS INT64)
From demo.articles;

CREATE TABLE demo.donations_clean (
donation_id INT,
article_id INT,
article_name STRING,
donation_amount NUMERIC,
donation_date datetime
);

INSERT into demo.donations_clean(article_id, article_name, donation_amount, donation_date)
SELECT
a.article_id,
trim(d.article),
CAST(d.donation_amount as  NUMERIC),
CAST(d.donation_date as datetime)
From demo.donations d
LEFT JOIN demo.articles_clean a on trim(d.article)=trim(a.title);

select * from demo.donations_clean;

CREATE TABLE demo.article_analysis AS
SELECT
a.article_id,
a.title,
a.likes,
a.dislikes,
a.nickname as author,
u.credibility_score as author_credibility_score,
u.email as author_email,
IFNULL(sum(d.donation_amount), 0) as total_donation, 
max(d.donation_date) as latest_donation_date
from demo.articles_clean a
LEFT JOIN demo.users_clean u on a.nickname = u.nickname
LEFT JOIN demo.donations_clean d on a.article_id = d.article_id
GROUP BY article_id, title, likes, dislikes, author, author_credibility_score, author_email
HAVING latest_donation_date IS NOT NULL;


SELECT * FROM demo.article_analysis;
