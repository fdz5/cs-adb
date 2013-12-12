//create table miasta2 using type GEOGRAPHY
CREATE TABLE fdziedzic.miasta2 (id BIGSERIAL PRIMARY KEY, nazwa varchar(20) NOT NULL, geom geography(POINT, 4326));

//insert records
INSERT INTO fdziedzic.miasta2 (nazwa, geom) VALUES ('Krakow', ST_GeomFromText('POINT(19.938333 50.061389)',4326));

INSERT INTO fdziedzic.miasta2 (nazwa, geom) VALUES ('Warszawa', ST_GeomFromText('POINT(21.008333 52.232222)',4326));

//show distance (in km)
SELECT ST_Distance((SELECT geom FROM fdziedzic.miasta2 WHERE nazwa='Krakow'), (SELECT geom FROM fdziedzic.miasta2 WHERE nazwa='Warszawa'))/1000 as distance;
