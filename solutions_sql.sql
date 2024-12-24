
--creating table 
create table netflix1
(
show_id varchar(10),
type varchar(10),
title varchar(110),
director varchar(220),
casts varchar(800),
country varchar(150), 
date_added varchar(50), 
release_year int, 
rating varchar(10), 
duration varchar(15), 
listed_in varchar(100), 
description varchar(300)
);

--to see all the data--
select * from netflix1;

--to see how may rows in the table--
select 
count(*) as total_countent 
from netflix1;

--to see the distinct types
select 
DISTINCT type
from netflix1;

--no of movies vs tv_shows
select 
type, 
count(*)
from netflix1 
group by type;

-- most common ratings for movies and tv_shows

SELECT 
type,
rating
from
		(
		select 
		type, 
		rating,
		count(*),
		RANK() OVER(PARTITION by type order by count(*) DESC) as ranking
		from netflix1
		group by 1, 2
		) as t1
			
where ranking =1

--movies relesed in a specific year
select 
title, 
release_year 
from netflix1 
where release_year = 2020 
and 
type = 'Movie';

--top 5 countries with most content in netflix
select 
UNNEST(STRING_TO_ARRAY(country,',')) AS new_country,
COUNT(show_id) as total_content
from netflix1
group by 1
order by 2 desc
limit 5;

--longest movie
select 
title,duration  
from netflix1
where 
type = 'Movie'
AND
duration = (select Max(duration) from netflix1);


--content added in the last five years
SELECT 
    *
FROM netflix1
WHERE 
    TO_DATE(date_added, 'Month DD, YYYY') >= CURRENT_DATE - INTERVAL '5 YEARS';

---all the movies/tv_shows direct by rajiv chilaka

select
title,
type,
director 
from netflix1
where director ILIKE '%rajiv chilaka%'

--tv_shows with more than 5 seasons
select
*
from netflix1
where 
type = 'TV Show'
AND
SPLIT_PART(duration, ' ' , 1)::numeric > 5;

--no of content in each genre
select 
UNNEST(STRING_TO_ARRAY(listed_in, ',')) AS genre,
count(show_id) as total_content
from netflix1
group by genre
order by total_content desc;

---each year and avg no of content release by india on netflix & top 5 years with highest
--avg content release

select 
EXTRACT(YEAR FROM TO_DATE(date_added, 'Month DD,YYYY')) as year,
count(*) as total_content_added,
ROUND(
count(*)::numeric/(select count(*) from netflix1 where country = 'India')::numeric * 100, 2)
as avg_content_added
from netflix1
where
country = 'India'
group by 1
ORDER BY 3 DESC;

--all documentarie movies
select * 
from netflix1
where 
type = 'Movie'
and
listed_in ILIKE '%documentaries%';


---content without directors
select * 
from netflix1
where 
director is NULL

---no of movies salman khan appeared in last 10 years

select *
from netflix1 
where 
casts ILIKE '%SALMAN KHAN%'
AND
release_year > EXTRACT(YEAR FROM CURRENT_DATE) - 10;


---TOP 10 actors appeared in highest no of movies produced in india

select 
UNNEST(STRING_TO_ARRAY(casts,',')) as actor,
count(*)
from netflix1
where
country = 'India'
group by actor
order by count(*) desc
limit 10;


---categorization based on kill and violence
WITH category_table
AS
(
select
*,
	CASE
	WHEN
	description ILIKE '%kill%' OR
	description ILIKE '%voilence' THEN'Bad_content'
	ELSE 'Good_content'
END category
from netflix1
)
SELECT category,
count(*)
from category_table
group by 1










