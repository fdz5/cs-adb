//show top 10 longest streets in Krakow
SELECT c.name, r.name, sum(ST_Length(r.geom))/1000 AS road_km FROM fdziedzic.roads AS r, fdziedzic.admin AS c where ST_Contains(c.geom,r.geom) AND r.name IS NOT NULL GROUP BY c.name, r.name ORDER BY road_km DESC LIMIT 10;
