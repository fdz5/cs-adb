CREATE TABLE fdziedzic.city (
	id serial PRIMARY KEY,
	name varchar(20) NOT NULL
);

SELECT AddGeometryColumn('fdziedzic', 'city', 'place', 4326, 'POINT', 2);

INSERT INTO fdziedzic.city VALUES (1, 'Krakow', ST_GeomFromText('POINT(19.938333 50.061389)', 4326));

INSERT INTO fdziedzic.city VALUES (2, 'Rzeszow', ST_GeomFromText('POINT(22.004722 50.033611)', 4326));

SELECT ST_Distance(
	(SELECT place from fdziedzic.city where name = 'Krakow'),
	(SELECT place from fdziedzic.city where name = 'Rzeszow')
) FROM fdziedzic.city;

// dla innego srid

INSERT INTO fdziedzic.city VALUES (3, 'Krakow', ST_GeomFromText('POINT(19.938333 50.061389)', 2805));

INSERT INTO fdziedzic.city VALUES (4, 'Krakow', ST_GeomFromText('POINT(22.004722 50.033611)', 2805));

//

CREATE TABLE fdziedzic.city-geo (
	id serial PRIMARY KEY,
	name varchar(20) NOT NULL
);
