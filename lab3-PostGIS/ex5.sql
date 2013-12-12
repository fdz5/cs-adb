//display roads length in Krakow
SELECT c.name, sum(ST_Length(r.geom))/1000 as roads_km FROM fdziedzic.roads AS r, fdziedzic.admin AS c WHERE ST_Contains(c.geom, r.geom) and c.name='Kraków' GROUP BY c.name;

//display motorways (highways) length in db
SELECT sum(ST_Length(geom))/1000 as roads_km FROM fdziedzic.roads where class='motorways';
SELECT sum(ST_Length(geogr))/1000 as roads_km FROM fdziedzic.roads where class='motorways';
