//Download krakow maps
wget http://home.agh.edu.pl/~wojnicki/wiki/_media/pl:ztb:krakow.tar.bz2

//untar file
tar xjf ...

//generate db sql files
shp2pgsql -s 3785 admin.shp > admin.sql
shp2pgsql -s 3785 amenities.shp > amenities.sql
shp2pgsql -s 3785 roads.shp > roads.sql

//create tables from sql files
psql -f filename.sql
(or)
(after psql) \i filename.sql

//copy tables into own schema
CREATE TABLE fdziedzic.admin AS (SELECT * FROM admin);
CREATE TABLE fdziedzic.amenities AS (SELECT * FROM amenities);
CREATE TABLE fdziedzic.roads AS (SELECT * FROM roads);

//add GEOGRAPHY column to tables
ALTER TABLE fdziedzic.admin ADD COLUMN geogr geography(MULTIPOLYGON, 4326);
ALTER TABLE fdziedzic.amenities ADD COLUMN geogr geography(POINT, 4326);
ALTER TABLE fdziedzic.roads ADD COLUMN geogr geography(MULTILINESTRING, 4326);

//Insert values from geom into geogr
UPDATE fdziedzic.admin SET geogr = ST_Transform(geom, 4326);
UPDATE fdziedzic.amenities SET geogr = ST_Transform(geom, 4326);
UPDATE fdziedzic.roads SET geogr = ST_Transform(geom, 4326);

SELECT geography(ST_Transform(geom, 4326)) from fdziedzic.admin;
