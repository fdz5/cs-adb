BEGIN TRANSACTION ISOLATION LEVEL REPEATABLE READ;
BEGIN TRANSACTION ISOLATION LEVEL REPEATABLE READ;

-- T1
select * from x;
UPDATE x SET a = 16;

-- T2:
select * from x;
UPDATE x SET a = 5;
-- ERROR:  could not serialize access due to concurrent update
COMMIT;

-- T1
COMMIT; 
