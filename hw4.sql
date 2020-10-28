SELECT 'ФИО: Мацыкина А.C';


--Создание таблицы в схеме movie
CREATE TABLE movie.content_genres
( movieid numeric,
genre TEXT );

--Копирование данных в таблцу из csv файла
psql  --host $APP_POSTGRES_HOST -U postgres \
-c "\\copy movie.content_genres FROM '/usr/share/data_store/raw_data/genres.csv' DELIMITER ',' CSV HEADER";

--ЗАПРОС 3
WITH top_rated AS
( SELECT movieid, avg(rating) AS avg_rating
    FROM movie.ratings
    GROUP BY movieid
    HAVING count(*) >= 50
    ORDER BY avg_rating DESC LIMIT 150 )
SELECT tr.movieid, tr.avg_rating, teg.keywords
INTO movie.top_rated_tags
FROM top_rated AS tr
INNER JOIN
( SELECT movieid, array_agg(genre) AS keywords
    FROM movie.content_genres
    GROUP BY movieid ) AS teg
    ON teg.movieid = tr.movieid;

--Запись таблицы в файл
psql  --host $APP_POSTGRES_HOST -U postgres \
-c "\\copy movie.top_rated_tags TO '/usr/share/data_store/raw_data/HW4.csv' WITH CSV HEADER DELIMITER as ',';"