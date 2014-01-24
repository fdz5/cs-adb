-- CREATE TABLE x (a integer, b integer);

BEGIN TRANSACTION ISOLATION LEVEL READ committed;
BEGIN TRANSACTION ISOLATION LEVEL READ committed;
select * from x;
-- wstaw pierwszy wiersz do tabeli:
INSERT INTO x VALUES (1, 2);
.....
COMMIT;
select * from *;
-- tu zmieniliśmy dane, o która pytała druga transakcja
ROLLBACK;
