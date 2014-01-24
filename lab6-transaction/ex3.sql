BEGIN TRANSACTION ISOLATION LEVEL REPEATABLE READ;
BEGIN TRANSACTION ISOLATION LEVEL REPEATABLE READ;
select * from x;
-- wstaw pierwszy wiersz do tabeli:
INSERT INTO x VALUES (1, 2);
.....
COMMIT;
select * from *;
-- tu zmieniliśmy dane, o która pytała druga transakcja
ROLLBACK;

-- Problem solved
