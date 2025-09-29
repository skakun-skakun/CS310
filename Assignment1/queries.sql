USE HW1;

SELECT p.name, p.networth, IFNULL(pp.picture_url, '') AS picture_url, g.id, gt.name
FROM player p
LEFT JOIN player_profile_picture pp ON pp.player_id = p.id
INNER JOIN game_player gp ON gp.player_id = p.id
INNER JOIN game g ON gp.game_id = g.id
INNER JOIN game_type gt ON g.game_type_id = gt.id;

WITH cte AS (SELECT * FROM player)
SELECT * FROM cte WHERE networth > 1000
UNION ALL
SELECT * FROM cte WHERE id < 3;

SELECT * FROM player WHERE id IN (SELECT player_id FROM game_player WHERE game_id = 1);

SELECT g.id FROM game g WHERE (SELECT COUNT(*) FROM game_player WHERE game_id = g.id) >= 3;

SELECT networth, COUNT(*) as number FROM player GROUP BY networth HAVING COUNT(*) > 1;

SELECT * FROM player ORDER BY networth;

SELECT * FROM player LIMIT 2; 