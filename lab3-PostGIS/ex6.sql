//show how many objects contains every category (amenities table) in 2km distance, order results descending
SELECT type, COUNT(type) as total FROM fdziedzic.amenities WHERE ST_Intersects(geogr, ST_buffer(ST_GeographyFromText('SRID=4326;POINT(19.938333 50.061389)'),2000)) GROUP BY type ORDER BY total DESC;
