# Spotify Data Analysis

This project is an advanced SQL-based analysis of Spotify music data. It involves creating a comprehensive table to store track, artist, and streaming information, followed by a series of exploratory data analysis (EDA) and analytical SQL queries to extract insights from the dataset.

## Table Schema

The main table, `spotify`, contains the following columns:

- `artist`: Name of the artist
- `track`: Name of the track
- `album`: Album name
- `album_type`: Type of album (e.g., single, album)
- `danceability`, `energy`, `loudness`, `speechiness`, `acousticness`, `instrumentalness`, `liveness`, `valence`, `tempo`: Audio features (FLOAT)
- `duration_min`: Duration of the track in minutes
- `title`, `channel`: Additional metadata
- `views`, `likes`, `comments`: YouTube statistics
- `licensed`, `official_video`: Boolean flags
- `stream`: Number of streams
- `energy_liveness`: Combined metric
- `most_played_on`: Platform with most streams (e.g., Spotify, YouTube)

**Key findings from the analysis include:**
- Identification of tracks with over 1 billion streams, highlighting the most popular songs.
- Discovery of artists with the highest number of tracks and albums, revealing prolific contributors.
- Insights into user engagement through metrics like total comments, likes, and views for official videos.
- Comparison of streaming performance across platforms (Spotify vs YouTube) for each track.
- Recognition of tracks and albums with unique audio features, such as highest energy or liveness scores.
- Understanding of the diversity in album types and track durations within the dataset.

These insights can help music industry professionals, analysts, and enthusiasts better understand trends, audience preferences, and the dynamics of music streaming platforms.

## Key SQL Queries and Analysis

- **Data Cleaning & EDA**
  - Count total records, distinct artists, and albums
  - Identify album types and minimum track duration
  - Remove tracks with zero duration

- **Analytical Queries**
  - List tracks with over 1 billion streams
  - List all albums with their respective artists
  - Calculate total comments for licensed tracks
  - Find all tracks belonging to album type 'single'
  - Count total number of tracks by each artist
  - Calculate average danceability of tracks in each album
  - Find top 5 tracks with highest energy values
  - List tracks with their total views and likes where official video is true
  - Calculate total views for all tracks
  - Identify tracks streamed more on Spotify than YouTube
  - Find top 3 most viewed tracks for each artist using window functions
  - List tracks where liveness score is above average
  - Calculate the difference between highest and lowest energy values for tracks in each album

## Example Questions and Queries

Here are some example business questions and the SQL queries used to answer them:

### 1. Which tracks have more than 1 billion streams?
```sql
SELECT * FROM spotify 
WHERE stream >= 1000000000;
```

### 2. What is the total number of comments for tracks where licensed is true?
```sql
SELECT SUM(comments) as total_comments FROM spotify
WHERE licensed = 'true';
```

### 3. Which are the top 5 tracks with the highest average energy?
```sql
SELECT 
    track, 
    AVG(energy) as avg_energy
FROM spotify
GROUP BY track
ORDER BY avg_energy DESC
LIMIT 5;
```

### 4. Which tracks have been streamed more on Spotify than on YouTube?
```sql
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
```

### 5. What is the difference between the highest and lowest energy values for tracks in each album?
```sql
WITH cte AS (
    SELECT 
        album,
        MAX(energy) as high_energy,
        MIN(energy) as low_energy
    FROM spotify
    GROUP BY album
)
SELECT
    album, 
    high_energy - low_energy AS energy_diff
FROM cte
ORDER BY energy_diff DESC;
```

## Usage

- Run the provided SQL scripts in your SQL environment to create the table and perform analysis.
- Modify queries as needed for deeper insights or to fit your specific dataset.

## License

This project is for educational and analytical purposes.

## Conclusion

This project demonstrates how advanced SQL queries can be used to perform in-depth analysis of Spotify music data. By leveraging various SQL techniques, we can extract valuable insights about artists, tracks, albums, and streaming trends. The approach outlined here can be adapted to similar datasets for further exploration and business intelligence.

