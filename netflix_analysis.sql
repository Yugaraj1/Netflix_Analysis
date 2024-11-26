-- give me the names of director who have done both movie and TV Shows

SELECT 
    nd.director, 
    COUNT(DISTINCT CASE WHEN n.type = 'Movie' THEN n.show_id END) AS number_of_movies,
    COUNT(DISTINCT CASE WHEN n.type = 'TV Show' THEN n.show_id END) AS number_of_TV_shows
FROM 
    netflix n
INNER JOIN 
    netflix_director nd
ON 
    n.show_id = nd.show_id
GROUP BY 
    nd.director
HAVING 
    COUNT(DISTINCT n.type) > 1
ORDER BY 
    number_of_movies DESC, number_of_TV_shows DESC;

--which country have the highest number of movies

SELECT 
    nc.country, 
    COUNT(ng.genre) AS total_comedy_movies
FROM 
    netflix_genre ng
INNER JOIN 
    netflix_country nc 
    ON ng.show_id = nc.show_id
INNER JOIN 
    netflix n 
    ON n.show_id = ng.show_id
WHERE  
    ng.genre = 'Comedies' 
    AND n.type = 'Movie'
GROUP BY 
    nc.country
ORDER BY 
    total_comedy_movies DESC
limit 5;

--which director have maximum number of movies per year added in netflix

with cte as (
	select nd.director , 
		count(extract (Year from n.date_added)) as Total_no_of_movies_released , 
		extract( year from n.date_added) as Year
	from netflix n
	inner join netflix_director nd
		on n.show_id = nd.show_id
	group by nd.director , Year
	order by Total_no_of_movies_released desc
	),
	cte2 as (
		select * ,
				row_number() over (partition by Year order by Total_no_of_movies_released desc, director ) as rank
		from cte
	)
	select * from cte2 where rank = 1;

-- what is the average duration of each movie in each genre

select ng.genre ,CAST (AVG( CAST(REPLACE(duration, ' min', '') AS INT)) AS INT) AS avg_duration
from netflix n
inner join  netflix_genre ng
on n.show_id = ng.show_id
where n.type = 'Movie'
group by ng.genre;


-- get me the names of the directors who have done both comedy and horror movies and get count of movies as well

SELECT 
    nd.director, 
    COUNT(DISTINCT CASE WHEN ng.genre = 'Comedies' THEN n.show_id END) AS total_comedy,
    COUNT(DISTINCT CASE WHEN ng.genre = 'Horror Movies' THEN n.show_id END) AS total_Horror_Movie
FROM 
    netflix n
INNER JOIN 
    netflix_genre ng ON n.show_id = ng.show_id
INNER JOIN 
    netflix_director nd ON n.show_id = nd.show_id
GROUP BY 
    nd.director
HAVING 
    COUNT(DISTINCT CASE WHEN ng.genre = 'Comedies' THEN n.show_id END) > 1
    AND COUNT(DISTINCT CASE WHEN ng.genre = 'Horror Movies' THEN n.show_id END) > 1
ORDER BY 
    total_comedy DESC, total_Horror_Movie DESC;



