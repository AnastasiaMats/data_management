SELECT 'ФИО: Мацыкина А.C.';

SELECT userId, movieId,
(rating - MIN(rating) OVER (PARTITION BY userId))/
(MAX(rating) OVER (PARTITION BY userId) - MIN(rating) OVER (PARTITION BY userId)) normed_rating,
AVG(rating) OVER (PARTITION BY userId) avg_rating
FROM (
SELECT DISTINCT userId, movieId, rating
FROM movie.ratings WHERE userId <> 1
LIMIT 1000
) as sample
ORDER BY userId, rating DESC
LIMIT 30;