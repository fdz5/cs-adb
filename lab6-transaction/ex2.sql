BEGIN TRANSACTION ISOLATION LEVEL READ committed;
LOCK TABLE x IN ACCESS EXCLUSIVE MODE;

BEGIN TRANSACTION ISOLATION LEVEL READ committed;
select * from x;
-- wstaw pierwszy wiersz do tabeli:
INSERT INTO x VALUES (1, 2);
.....
COMMIT;
select * from *;
-- tu zmieniliśmy dane, o która pytała druga transakcja
ROLLBACK;
