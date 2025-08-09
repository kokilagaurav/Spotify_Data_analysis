--Advance sql project spotify

-- create table
DROP TABLE IF EXISTS spotify;
CREATE TABLE spotify (
    artist VARCHAR(255),
    track VARCHAR(255),
    album VARCHAR(255),
    album_type VARCHAR(50),
    danceability FLOAT,
    energy FLOAT,
    loudness FLOAT,
    speechiness FLOAT,
    acousticness FLOAT,
    instrumentalness FLOAT,
    liveness FLOAT,
    valence FLOAT,
    tempo FLOAT,
    duration_min FLOAT,
    title VARCHAR(255),
    channel VARCHAR(255),
    views FLOAT,
    likes BIGINT,
    comments BIGINT,
    licensed BOOLEAN,
    official_video BOOLEAN,
    stream BIGINT,
    energy_liveness FLOAT,
    most_played_on VARCHAR(50)
);

--EDA
SELECT COUNT(*) FROM spotify;

SELECT COUNT(DISTINCT artist) from spotify;

SELECT COUNT(DISTINCT album) FROM spotify;

SELECT DISTINCT album_type FROM spotify;

SELECT MIN(duration_min) FROM spotify;

DELETE FROM SPOTIFY
WHERE duration_min = 0;
SELECT * FROM spotify WHERE duration_min = 0;

SELECT DISTINCT most_played_on FROM spotify;


-- query to name of all the track that have more than 1 billion stream
SELECT * FROM spotify 
WHERE stream >= 1000000000;

-- ALL THE ALBUM WITH THEIR RESPECTIVE ARTIST
SELECT DISTINCT(album), artist
FROM spotify

-- TOTAL NUMBER OF COMMENT FOR TRACK WHERE LICENSED = TRUE
SELECT SUM(comments) as total_comments FROM spotify
WHERE licensed = 'true';

-- total track that belong to album type single
SELECT * FROM spotify
WHERE album_type = 'single'

-- count total number of track by each artist

SELECT COUNT(track) AS total_number_songs , artist 
FROM spotify
GROUP BY artist
ORDER BY total_number_songs DESC;

--CALCULATE average DENCIBILITY OF TRACK IN EACH ALBUM
SELECT AVG(danceability) AS avg_danceability, track, album 
FROM spotify
GROUP BY track, album

-- find top 5 track with highest energy value
SELECT 
	track, 
	AVG(energy) as avg_enegy
FROM spotify
GROUP BY track
ORDER BY 2 DESC
LIMIT 5;

-- list all the track with their view, likes where official vedio = true

SELECT 	
	track, 	
	SUM(views) AS total_views, 
	SUM(likes) AS total_likes 
FROM spotify
WHERE official_video = 'true'
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5

-- CALCULATE THE TOTAL VIEW OF ALL ASOCIATED TRACK

SELECT  
	DISTINCT(track),
	sum(views) as total_view
FROM spotify
GROUP BY 1
ORDER BY 2 DESC

-- TRACKE NAME THAT HAVE BEEN STREAMED ON SPOTIFY MORE THAN YOUTUBE
SELECT *
FROM (
    SELECT 
        track, 
        COALESCE(SUM(CASE WHEN most_played_on = 'Youtube' THEN stream END), 0) AS streamed_on_youtube, 
        COALESCE(SUM(CASE WHEN most_played_on = 'Spotify' THEN stream END), 0) AS streamed_on_Spotify
    FROM spotify
    GROUP BY track
) AS T1
WHERE streamed_on_Spotify > streamed_on_youtube
  AND streamed_on_youtube <> 0;

-- find top 3 most viewed track for each artist using window function 
WITH artist_rank
as (SELECT 
	artist,
	track,
	SUM(views) AS total_view,
	DENSE_RANK() OVER(PARTITION BY artist ORDER BY SUM(views) DESC) AS RANK
FROM spotify
GROUP BY 1,2
ORDER BY 1, 3 DESC)

SELECT * FROM artist_rank
WHERE RANK <=3

-- QUERY TO FIND TRACK WHERE THE LIVENESS SCORE IS ABOVE AVERAGE

SELECT
	track,
	artist,
	liveness
FROM spotify
WHERE liveness > (SELECT AVG(liveness) from spotify)


-- use with clause to calculate the diffrence between the high and low energy value for track in each albums
WITH cte
AS
(SELECT 
	album,
	MAX(energy) as high_energy,
	MIN(energy) as low_energy
FROM spotify
GROUP BY 1)

SELECT
	album, 
	high_energy - low_energy AS energy_diff
from cte
ORDER BY 2 DESC

--FINISH