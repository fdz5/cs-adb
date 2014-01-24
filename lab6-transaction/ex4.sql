BEGIN TRANSACTION ISOLATION LEVEL REPEATABLE READ;
BEGIN TRANSACTION ISOLATION LEVEL REPEATABLE READ;
SELECT *, xmin, xmax FROM x;
-- wstaw pierwszy wiersz do tabeli:
INSERT INTO x VALUES (1, 2);
SELECT *, xmin, xmax FROM x;
UPDATE x set a = 10;
SELECT *, xmin, xmax FROM x;
DELETE FROM x where b = 2;
SELECT *, xmin, xmax FROM x;
COMMIT;
SELECT *, xmin, xmax FROM x;
select * from *;
-- tu zmieniliśmy dane, o która pytała druga transakcja
ROLLBACK;

SELECT *, xmin, xmax FROM x;

SELECT txid_current();
