USE HW1;

-- select joining 5 tables
SELECT p.name, p.networth, IFNULL(pp.picture_url, '') AS picture_url, g.id, gt.name
FROM player p
LEFT JOIN player_profile_picture pp ON pp.player_id = p.id -- profile picture by player_id
INNER JOIN game_player gp ON gp.player_id = p.id -- game_player relation by player_id
INNER JOIN game g ON gp.game_id = g.id -- game by game_player relation
INNER JOIN game_type gt ON g.game_type_id = gt.id; -- game type by game_type_id

-- cte
WITH cte AS (SELECT * FROM player) -- basic cte for player selection
SELECT * FROM cte WHERE networth > 1000
UNION
SELECT * FROM cte WHERE id < 3; -- selecting from cte where some two conditions satisfy

-- subquery
SELECT * FROM player WHERE id IN (SELECT player_id FROM game_player WHERE game_id = 3); -- select players from game with id = 3

-- WHERE clause
SELECT g.id FROM game g WHERE (SELECT COUNT(*) FROM game_player WHERE game_id = g.id) >= 3; -- select games with 3 or more players

-- GROUP BY and HAVING
SELECT networth, COUNT(*) as number FROM player GROUP BY networth HAVING COUNT(*) > 1; -- group of networthes that have more that 1 people

-- ORGER BY
SELECT * FROM player ORDER BY networth; -- players ordered by networth

-- LIMIT
SELECT * FROM player LIMIT 2;  -- two players