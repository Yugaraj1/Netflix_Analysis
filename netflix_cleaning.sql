-- Check Duplicates(show_id)

SELECT show_id, COUNT(*)
FROM netflix_table
GROUP BY show_id
HAVING COUNT(*) > 1;

-- Duplicates (title)
SELECT title
FROM netflix_table
GROUP BY title
HAVING COUNT(*) > 1

--drop duplicates using title
delete from netflix_table
where title in (
	SELECT title
    FROM netflix_table
    GROUP BY title
    HAVING COUNT(*) > 1
)

--split director column

INSERT INTO netflix_director (show_id, director)
SELECT show_id, 
       TRIM(unnested.director) AS director
FROM netflix_table,
     LATERAL UNNEST(string_to_array(director, ',')) AS unnested(director);

--split casts column

INSERT INTO netflix_casts (show_id, casts)
SELECT show_id, 
       TRIM(unnested.casts) AS director
FROM netflix_table,
     LATERAL UNNEST(string_to_array(casts, ',')) AS unnested(casts);

select * from netflix_casts;

--split country column

insert into netflix_country(show_id , country)
select show_id ,
		trim(unnested.country) as country
from netflix_table,
		Lateral unnest(string_to_array(country,',')) as unnested(country);

--split listed_im column

insert into netflix_genre(show_id , genre)
select show_id ,
		trim(unnested.listed_in) as genre
from netflix_table,
		Lateral unnest(string_to_array(listed_in,',')) as unnested(listed_in);

--populate country column

insert into netflix_country ( show_id , country)
SELECT nt.show_id, 
       m.country
FROM netflix_table nt
INNER JOIN (
    SELECT nd.director, nc.country
    FROM netflix_country nc
    INNER JOIN netflix_director nd 
        ON nc.show_id = nd.show_id
) m 
ON nt.director = m.director
where nt.country is null;
 

select show_id , country
from netflix_table
where country is null;

SELECT *
FROM netflix_table
WHERE director = 'Julien Leclercq';

--check duration column


select * from netflix_table
where duration is null;

with cte as (
	select *, 
		row_number() over (partition by title , type order by show_id) as rn
	from netflix_table
)
select show_id ,
		type , 
		title , 
		cast (date_added as date) as date_added , 
		release_year , 
		rating,
		case 
			when duration is null then rating
			else duration
		end as duration,
		description
into netflix
from cte;




