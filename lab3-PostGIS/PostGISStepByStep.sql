//connect to db
psql


//creating schema
CREATE SCHEMA fdziedzic


//creating table
CREATE TABLE fdziedzic.miasta(id bigserial PRIMARY KEY, nazwa varchar(20) NOT NULL);


//standard insert
INSERT INTO fdziedzic.miasta (nazwa) values ('Krakow');


//adding geometry column (schema, table, columnName, srid, type, size)
SELECT AddGeometryColumn('fdziedzic', 'miasta', 'geom', 4326, 'point', 2);


//inserting geometry values
INSERT INTO fdziedzic.miasta (nazwa, geom) VALUES ('Krakow', ST_GeomFromText('POINT(19.938333 50.061389)',4326));

INSERT INTO fdziedzic.miasta (nazwa, geom) VALUES ('Warszawa', ST_GeomFromText('POINT(21.008333 52.232222)',4326));

INSERT INTO fdziedzic.miasta (nazwa, geom) VALUES ('Rzeszow', ST_GeomFromText('POINT(22.004722 50.033611)',4326));


//selecting from table
SELECT id, nazwa, ST_AsText(geom), ST_AsEwkt(geom), ST_X(geom), ST_Y(geom) FROM fdziedzic.miasta;


//Distance
SELECT p1.nazwa, p2.nazwa, ST_Distance_Sphere(p1.geom, p2.geom) FROM fdziedzic.miasta AS p1, fdziedzic.miasta AS p2 WHERE p1.id > p2.id;

SELECT p1.nazwa, p2.nazwa, ST_Distance_Sphere(p1.geom, p2.geom) FROM fdziedzic.miasta AS p1, fdziedzic.miasta AS p2;

SELECT p1.nazwa, p2.nazwa, ST_Distance_Sphere(p1.geom, p2.geom)/1000 FROM fdziedzic.miasta AS p1, fdziedzic.miasta AS p2;

SELECT ST_Distance(ST_Transform((SELECT geom FROM fdziedzic.miasta WHERE nazwa='Krakow'), 26986), ST_Transform((SELECT geom FROM fdziedzic.miasta WHERE nazwa='Warszawa'), 26986));

SELECT ST_Distance(ST_Transform((SELECT geom FROM fdziedzic.miasta WHERE nazwa='Krakow'), 3120), ST_Transform((SELECT geom FROM fdziedzic.miasta WHERE nazwa='Warszawa'), 3120));


//Creating table with type GEOGRAPHY
CREATE TABLE fdziedzic.miasta2 (id BIGSERIAL PRIMARY KEY, nazwa varchar(20) NOT NULL, geom geography(POINT, 4326));


//inserting
INSERT INTO fdziedzic.miasta2 (nazwa, geom) VALUES ('Krakow', ST_GeomFromText('POINT(19.938333 50.061389)',4326));

INSERT INTO fdziedzic.miasta2 (nazwa, geom) VALUES ('Warszawa', ST_GeomFromText('POINT(21.008333 52.232222)',4326));


//distance
SELECT ST_Distance((SELECT geom FROM fdziedzic.miasta2 WHERE nazwa='Krakow'), (SELECT geom FROM fdziedzic.miasta2 WHERE nazwa='Warszawa'))/1000 as distance;


//list schemas
\dn


//list tables
\dt


//exit
\q


//login
ztb@mapserver.kis.agh.edu.pl
...2013
