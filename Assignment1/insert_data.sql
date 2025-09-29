USE HW1;

TRUNCATE TABLE player;
TRUNCATE TABLE player_profile_picture;
TRUNCATE TABLE game_type;
TRUNCATE TABLE game;
TRUNCATE TABLE game_player;

INSERT INTO player (name, networth) VALUES
( 'Alice', 1000 ),
( 'Bob', 2000 ),
( 'Charlie', 3000 ),
( 'David', 2000 ),
( 'Emily', 1000 );

INSERT INTO player_profile_picture (player_id, picture_url) VALUES
(2, 'url_1'),
(4, 'url_2'),
(5, 'url_3');

INSERT INTO game_type (name) VALUES
('casual'), 
('rapid'), 
('random');

INSERT INTO game (game_type_id) VALUES
(1), (1), (2), (3);

INSERT INTO game_player (game_id, player_id) VALUES
(1, 1), 
(1, 2), 
(1, 3), 
(1, 4), 
(2, 3), 
(2, 5),
(2, 1), 
(3, 2), 
(3, 3), 
(4, 3),
(4, 5);
