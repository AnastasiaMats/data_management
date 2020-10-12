SELECT 'ФИО: Мацыкина А.C';

-- Простые выборки
-- выбрать 10 записей из таблицы ratings
SELECT * FROM movie.ratings LIMIT 10;

-- выбрать из таблицы links всё записи, у которых imdbid оканчивается на "42", а поле movieid между 100 и 1000
SELECT * FROM movie.links
WHERE
imdbid LIKE '%42' and movieid > 100 and movieid < 1000;
-- 11 строк


--Сложные выборки: JOIN
-- выбрать из таблицы links все imdbId, которым ставили рейтинг 5
SELECT imdbid FROM movie.links
INNER JOIN movie.ratings
ON links.movieid=ratings.movieid
WHERE rating = 5
LIMIT 10;


-- Аггрегация данных: базовые статистики
-- Посчитать число фильмов без оценок
SELECT
COUNT(links.movieid) as count
FROM movie.links
LEFT JOIN movie.ratings
ON links.movieid=ratings.movieid
WHERE ratings.movieid IS NULL;

-- вывести top-10 пользователей, у который средний рейтинг выше 3.5
SELECT
userId, AVG(rating) as avg_rating
FROM movie.ratings
GROUP BY userId
HAVING AVG(rating) > 3.5
ORDER BY avg_rating DESC
LIMIT 10;
-- или ORDER BY AVG(rating) DESC
-- сортировать по убыванию среднего рейтинга, чтобы видеть именно "top" пользователей


--Иерархические запросы
-- Подзапросы: достать любые 10 imbdId из links у которых средний рейтинг больше 3.5.
SELECT
    imdbid
FROM movie.links
WHERE links.movieid IN (
    SELECT
        movieid
    FROM movie.ratings
    GROUP BY movieid
    HAVING avg(rating) > 3.5
)
LIMIT 10;

-- Common Table Expressions: посчитать средний рейтинг по пользователям, у которых более 10 оценок. Нужно подсчитать средний рейтинг по все пользователям, которые попали под условие - то есть в ответе должно быть одно число.
WITH tmp_table
AS (
SELECT
userid,
COUNT(rating) as activity
FROM movie.ratings
GROUP BY userid
HAVING COUNT(rating) > 10
ORDER BY activity
)
SELECT
AVG(ratings.rating)
FROM movie.ratings
LEFT JOIN tmp_table
ON ratings.userid=tmp_table.userid
WHERE tmp_table.userid IS NOT NULL;
