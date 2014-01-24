BEGIN TRANSACTION ISOLATION LEVEL REPEATABLE READ;
BEGIN TRANSACTION ISOLATION LEVEL REPEATABLE READ;

-- T2
select * from x for update;

-- T1
UPDATE x SET a = 16;
COMMIT;
-- ERROR:  could not serialize access due to concurrent update
