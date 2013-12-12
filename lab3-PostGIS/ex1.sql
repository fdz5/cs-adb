//create table miasta
CREATE TABLE fdziedzic.miasta(id bigserial PRIMARY KEY, nazwa varchar(20) NOT NULL);

//add GEOMETRY column (schema, table, columnName, srid, type, size)
SELECT AddGeometryColumn('fdziedzic', 'miasta', 'geom', 4326, 'point', 2);

//add city records
INSERT INTO fdziedzic.miasta (nazwa, geom) VALUES ('Krakow', ST_GeomFromText('POINT(19.938333 50.061389)',4326));
INSERT INTO fdziedzic.miasta (nazwa, geom) VALUES ('Warszawa', ST_GeomFromText('POINT(21.008333 52.232222)',4326));
INSERT INTO fdziedzic.miasta (nazwa, geom) VALUES ('Rzeszow', ST_GeomFromText('POINT(22.004722 50.033611)',4326));

//selecting GEOMETRY colums (Text/WKT/X/Y) (bonus)
SELECT id, nazwa, ST_AsText(geom), ST_AsEwkt(geom), ST_X(geom), ST_Y(geom) FROM fdziedzic.miasta;

//show distance between all records (in degrees)
SELECT p1.nazwa, p2.nazwa, ST_Distance(p1.geom, p2.geom) FROM fdziedzic.miasta AS p1, fdziedzic.miasta AS p2 WHERE p1.id > p2.id;

//show distance between all records (in meters)
SELECT p1.nazwa, p2.nazwa, ST_Distance_Sphere(p1.geom, p2.geom) FROM fdziedzic.miasta AS p1, fdziedzic.miasta AS p2 WHERE p1.id > p2.id;

//show distance between all records (in meters) - extended (also between the same record)
SELECT p1.nazwa, p2.nazwa, ST_Distance_Sphere(p1.geom, p2.geom) FROM fdziedzic.miasta AS p1, fdziedzic.miasta AS p2;

//show distance between all records (in km)
SELECT p1.nazwa, p2.nazwa, ST_Distance_Sphere(p1.geom, p2.geom)/1000 FROM fdziedzic.miasta AS p1, fdziedzic.miasta AS p2 WHERE p1.id > p2.id;

//show distance between 2 records using function ST_Transform and frame 
SELECT ST_Distance(ST_Transform((SELECT geom FROM fdziedzic.miasta WHERE nazwa='Krakow'), 26986), ST_Transform((SELECT geom FROM fdziedzic.miasta WHERE nazwa='Warszawa'), 26986));

SELECT ST_Distance(ST_Transform((SELECT geom FROM fdziedzic.miasta WHERE nazwa='Krakow'), 4326), ST_Transform((SELECT geom FROM fdziedzic.miasta WHERE nazwa='Warszawa'), 4326));
