SET memory_limit = '4GB';

CREATE TABLE game_analysis AS (
    SELECT
        ROW_NUMBER() OVER () AS id,
        unnested_games.value.appid AS game_id,
        unnested_games.value.name_from_applist AS name,
        unnested_games.value.app_details.data.release_date.coming_soon AS coming_soon,
        regexp_extract(unnested_games.value.app_details.data.release_date.date, '(\d{4})') AS release_year,
        if (unnested_games.value.app_details.data.is_free, 0, unnested_games.value.app_details.data.price_overview.final) AS price,
        genre.value.description AS genre_name,
        tag.value.description AS tag_name
    FROM
        read_json_auto('steam_2025_5k-dataset-games_20250831.json', maximum_object_size=1073741824) AS raw_data,
        json_each(raw_data.games) AS unnested_games,
        json_each(IFNULL(unnested_games.value.app_details.data.genres, [{"id": 0, "description": null}])) AS genre,
        json_each(IFNULL(unnested_games.value.app_details.data.categories, [{"id": 0, "description": null}])) AS tag
);

CREATE TABLE game_reviews AS (
    SELECT
        ROW_NUMBER() OVER () AS id,
        unnested_data.value.appid AS game_id,
        json_array_length(unnested_data.value.review_data.reviews) AS reviews_count
    FROM
        read_json_auto('steam_2025_5k-dataset-reviews_20250901.json', maximum_object_size = 1073741824) AS raw_data,
        json_each(raw_data.reviews) AS unnested_data
);

SELECT DISTINCT g.game_id, g.name, r.reviews_count
FROM game_analysis g
LEFT JOIN game_reviews r
ON g.game_id = r.game_id
ORDER BY r.reviews_count DESC
LIMIT 20;

SELECT release_year, COUNT(*) AS repeats
FROM game_analysis
GROUP BY release_year
ORDER BY repeats DESC;

SELECT AVG(CAST(price AS INT)) as avg_price, genre_name
FROM game_analysis
GROUP BY genre_name
ORDER BY avg_price DESC;

SELECT tag_name, COUNT(*) AS count
FROM game_analysis
GROUP BY tag_name
ORDER BY count DESC;