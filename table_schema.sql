create table netflix_director(
	show_id varchar,
	director Varchar
)

create table netflix_casts(
	show_id varchar,
	casts Varchar
)

create table netflix_country(
	show_id varchar,
	country Varchar
)

create table netflix_genre(
	show_id varchar,
	genre Varchar
)

CREATE TABLE netflix_stg (
    show_id VARCHAR(50) PRIMARY KEY,       
    title VARCHAR(200) NOT NULL,         
    type VARCHAR(50),                    
    date_added DATE,                      
    release_year INT,                    
    duration VARCHAR(50),                
    rating VARCHAR(10),                   
    description TEXT                      
);

