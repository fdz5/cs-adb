DELETE FROM x;
INSERT INTO x VALUES(10, 10);
INSERT INTO x VALUES(5, 5);

BEGIN TRANSACTION ISOLATION LEVEL REPEATABLE READ;
BEGIN TRANSACTION ISOLATION LEVEL REPEATABLE READ;

-- T1
select sum(a) from x;


-- T2
update x set a = 10;
commit;

-- T1
select sum(a) from x;
