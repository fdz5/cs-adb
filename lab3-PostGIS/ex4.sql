//Show Krakow area in km (wikipedia = 326,8 km2)
SELECT ST_Area(geom)/1000000 as "powierzchnia[km2]" from fdziedzic.admin where name = 'Kraków';
SELECT ST_Area(geogr)/1000000 as "powierzchnia[km2]" from fdziedzic.admin where name = 'Kraków';
