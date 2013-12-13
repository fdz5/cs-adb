// Indeksy oparte o haszowanie

EXPLAIN ANALYZE select * from zamowienia where idkompozycji = 'buk1';
                                               QUERY PLAN                                                 
-----------------------------------------------------------------------------------------------------------
 Seq Scan on zamowienia  (cost=0.00..167.19 rows=424 width=52) (actual time=0.048..3.509 rows=424 loops=1)
   Filter: (idkompozycji = 'buk1'::bpchar)
 Total runtime: 3.577 ms

                                                QUERY PLAN                                                 
-----------------------------------------------------------------------------------------------------------
 Seq Scan on zamowienia  (cost=0.00..167.19 rows=424 width=52) (actual time=0.022..1.680 rows=424 loops=1)
   Filter: (idkompozycji = 'buk1'::bpchar)
 Total runtime: 1.781 ms


CREATE INDEX hash_idx ON zamowienia(idkompozycji);

                                                      QUERY PLAN                                                      
----------------------------------------------------------------------------------------------------------------------
 Bitmap Heap Scan on zamowienia  (cost=11.54..83.84 rows=424 width=52) (actual time=0.178..0.513 rows=424 loops=1)
   Recheck Cond: (idkompozycji = 'buk1'::bpchar)
   ->  Bitmap Index Scan on hash_idx  (cost=0.00..11.43 rows=424 width=0) (actual time=0.152..0.152 rows=424 loops=1)
         Index Cond: (idkompozycji = 'buk1'::bpchar)
 Total runtime: 0.598 ms


DROP INDEX hash_idx;

// Indeksy oparte o b-drzewa

CREATE INDEX btree_idx ON zamowienia USING btree (idkompozycji);

                                                      QUERY PLAN                                                      
----------------------------------------------------------------------------------------------------------------------
 Bitmap Heap Scan on zamowienia  (cost=11.54..83.84 rows=424 width=52) (actual time=0.170..0.450 rows=424 loops=1)
   Recheck Cond: (idkompozycji = 'buk1'::bpchar)
   ->  Bitmap Index Scan on hash_idx  (cost=0.00..11.43 rows=424 width=0) (actual time=0.145..0.145 rows=424 loops=1)
         Index Cond: (idkompozycji = 'buk1'::bpchar)
 Total runtime: 0.526 ms



EXPLAIN ANALYZE select * from zamowienia where idkompozycji < '%b';
                                                      QUERY PLAN                                                      
----------------------------------------------------------------------------------------------------------------------
 Index Scan using hash_idx on zamowienia  (cost=0.00..8.27 rows=1 width=52) (actual time=0.036..0.036 rows=0 loops=1)
   Index Cond: (idkompozycji < '%b'::bpchar)
 Total runtime: 0.078 ms


EXPLAIN ANALYZE select * from zamowienia where idkompozycji > '%a';
                                                 QUERY PLAN                                                  
-------------------------------------------------------------------------------------------------------------
 Seq Scan on zamowienia  (cost=0.00..167.19 rows=8015 width=52) (actual time=0.021..5.448 rows=8015 loops=1)
   Filter: (idkompozycji > '%a'::bpchar)
 Total runtime: 6.173 ms


EXPLAIN ANALYZE select * from zamowienia where idkompozycji >= '%b';
                                                 QUERY PLAN                                                  
-------------------------------------------------------------------------------------------------------------
 Seq Scan on zamowienia  (cost=0.00..167.19 rows=8015 width=52) (actual time=0.022..5.744 rows=8015 loops=1)
   Filter: (idkompozycji >= '%b'::bpchar)
 Total runtime: 6.489 ms

SET ENABLE_SEQSCAN TO OFF;

filidzie=> EXPLAIN ANALYZE select * from zamowienia where idkompozycji < '%b';
                                                      QUERY PLAN                                                      
----------------------------------------------------------------------------------------------------------------------
 Index Scan using hash_idx on zamowienia  (cost=0.00..8.27 rows=1 width=52) (actual time=0.053..0.053 rows=0 loops=1)
   Index Cond: (idkompozycji < '%b'::bpchar)
 Total runtime: 0.098 ms
                                                       QUERY PLAN                                                        
-------------------------------------------------------------------------------------------------------------------------
 Bitmap Heap Scan on zamowienia  (cost=158.37..325.55 rows=8015 width=52) (actual time=4.138..6.163 rows=8015 loops=1)
   Recheck Cond: (idkompozycji >= '%b'::bpchar)
   ->  Bitmap Index Scan on hash_idx  (cost=0.00..156.36 rows=8015 width=0) (actual time=4.097..4.097 rows=8015 loops=1)
         Index Cond: (idkompozycji >= '%b'::bpchar)
 Total runtime: 6.915 ms

DROP INDEX btree_idx;

// Indeksy a wzorce

CREATE INDEX hash_idx ON zamowienia(uwagi);

filidzie=> EXPLAIN ANALYZE select * from zamowienia where uwagi like 'do%';
                                                        QUERY PLAN                                                         
---------------------------------------------------------------------------------------------------------------------------
 Seq Scan on zamowienia  (cost=10000000000.00..10000000167.19 rows=11 width=52) (actual time=0.016..1.385 rows=11 loops=1)
   Filter: ((uwagi)::text ~~ 'do%'::text)
 Total runtime: 1.416 ms


DROP INDEX hash_idx;
CREATE INDEX zamowienia_uwagi ON zamowienia (uwagi varchar_pattern_ops);

                                                        QUERY PLAN                                                         
---------------------------------------------------------------------------------------------------------------------------
 Bitmap Heap Scan on zamowienia  (cost=4.36..35.13 rows=11 width=52) (actual time=0.290..0.296 rows=11 loops=1)
   Filter: ((uwagi)::text ~~ 'do%'::text)
   ->  Bitmap Index Scan on zamowienia_uwagi  (cost=0.00..4.36 rows=11 width=0) (actual time=0.272..0.272 rows=11 loops=1)
         Index Cond: (((uwagi)::text ~>=~ 'do'::text) AND ((uwagi)::text ~<~ 'dp'::text))
 Total runtime: 0.340 ms


DROP INDEX zamowienia_uwagi;

// Indeksy wielokolumnowe

CREATE INDEX zamowienia_uwagi ON zamowienia (idklienta, idodbiorcy, idkompozycji);

EXPLAIN ANALYZE select * from zamowienia where idklienta = 'mbabik' AND idodbiorcy = 1 AND idkompozycji = 'buk2';

                                                          QUERY PLAN                                                          
------------------------------------------------------------------------------------------------------------------------------
 Index Scan using zamowienia_uwagi on zamowienia  (cost=0.00..8.27 rows=1 width=52) (actual time=0.045..0.047 rows=1 loops=1)
   Index Cond: (((idklienta)::text = 'mbabik'::text) AND (idodbiorcy = 1) AND (idkompozycji = 'buk2'::bpchar))
 Total runtime: 0.089 ms


EXPLAIN ANALYZE select * from zamowienia where idklienta = 'mbabik' OR idodbiorcy = 1 OR idkompozycji = 'buk2';

                                                             QUERY PLAN                                                              
-------------------------------------------------------------------------------------------------------------------------------------
 Bitmap Heap Scan on zamowienia  (cost=462.94..544.76 rows=819 width=52) (actual time=2.280..2.738 rows=810 loops=1)
   Recheck Cond: (((idklienta)::text = 'mbabik'::text) OR (idodbiorcy = 1) OR (idkompozycji = 'buk2'::bpchar))
   ->  BitmapOr  (cost=462.94..462.94 rows=847 width=0) (actual time=2.255..2.255 rows=0 loops=1)
         ->  Bitmap Index Scan on zamowienia_uwagi  (cost=0.00..5.59 rows=179 width=0) (actual time=0.093..0.093 rows=179 loops=1)
               Index Cond: ((idklienta)::text = 'mbabik'::text)
         ->  Bitmap Index Scan on zamowienia_uwagi  (cost=0.00..228.36 rows=287 width=0) (actual time=0.811..0.811 rows=287 loops=1)
               Index Cond: (idodbiorcy = 1)
         ->  Bitmap Index Scan on zamowienia_uwagi  (cost=0.00..228.36 rows=381 width=0) (actual time=1.349..1.349 rows=381 loops=1)
               Index Cond: (idkompozycji = 'buk2'::bpchar)
 Total runtime: 2.860 ms



EXPLAIN ANALYZE select * from zamowienia where idkompozycji = 'buk1';
                                                          QUERY PLAN                                                           
-------------------------------------------------------------------------------------------------------------------------------
 Bitmap Heap Scan on zamowienia  (cost=228.47..300.77 rows=424 width=52) (actual time=1.472..1.765 rows=424 loops=1)
   Recheck Cond: (idkompozycji = 'buk1'::bpchar)
   ->  Bitmap Index Scan on zamowienia_uwagi  (cost=0.00..228.36 rows=424 width=0) (actual time=1.448..1.448 rows=424 loops=1)
         Index Cond: (idkompozycji = 'buk1'::bpchar)
 Total runtime: 1.843 ms


DROP INDEX zamowienia_uwagi;

CREATE INDEX zamowienia_idodbiorcy ON zamowienia (idodbiorcy);
CREATE INDEX zamowienia_idklienta ON zamowienia (idklienta);
CREATE INDEX zamowienia_idkompozycji ON zamowienia (idkompozycji);

EXPLAIN ANALYZE select * from zamowienia where idklienta = 'mbabik' AND idodbiorcy = 1 AND idkompozycji = 'buk2';
                                                                QUERY PLAN                                                                 
-------------------------------------------------------------------------------------------------------------------------------------------
 Bitmap Heap Scan on zamowienia  (cost=23.61..27.62 rows=1 width=52) (actual time=0.296..0.296 rows=1 loops=1)
   Recheck Cond: (((idklienta)::text = 'mbabik'::text) AND (idodbiorcy = 1) AND (idkompozycji = 'buk2'::bpchar))
   ->  BitmapAnd  (cost=23.61..23.61 rows=1 width=0) (actual time=0.290..0.290 rows=0 loops=1)
         ->  Bitmap Index Scan on zamowienia_idklienta  (cost=0.00..5.59 rows=179 width=0) (actual time=0.088..0.088 rows=179 loops=1)
               Index Cond: ((idklienta)::text = 'mbabik'::text)
         ->  Bitmap Index Scan on zamowienia_idodbiorcy  (cost=0.00..6.40 rows=287 width=0) (actual time=0.065..0.065 rows=287 loops=1)
               Index Cond: (idodbiorcy = 1)
         ->  Bitmap Index Scan on zamowienia_idkompozycji  (cost=0.00..11.11 rows=381 width=0) (actual time=0.114..0.114 rows=381 loops=1)
               Index Cond: (idkompozycji = 'buk2'::bpchar)
 Total runtime: 0.349 ms



EXPLAIN ANALYZE select * from zamowienia where idklienta = 'mbabik' OR idodbiorcy = 1 OR idkompozycji = 'buk2';
                                                                QUERY PLAN                                                                 
-------------------------------------------------------------------------------------------------------------------------------------------
 Bitmap Heap Scan on zamowienia  (cost=23.72..105.54 rows=819 width=52) (actual time=0.283..0.735 rows=810 loops=1)
   Recheck Cond: (((idklienta)::text = 'mbabik'::text) OR (idodbiorcy = 1) OR (idkompozycji = 'buk2'::bpchar))
   ->  BitmapOr  (cost=23.72..23.72 rows=847 width=0) (actual time=0.258..0.258 rows=0 loops=1)
         ->  Bitmap Index Scan on zamowienia_idklienta  (cost=0.00..5.59 rows=179 width=0) (actual time=0.087..0.087 rows=179 loops=1)
               Index Cond: ((idklienta)::text = 'mbabik'::text)
         ->  Bitmap Index Scan on zamowienia_idodbiorcy  (cost=0.00..6.40 rows=287 width=0) (actual time=0.059..0.059 rows=287 loops=1)
               Index Cond: (idodbiorcy = 1)
         ->  Bitmap Index Scan on zamowienia_idkompozycji  (cost=0.00..11.11 rows=381 width=0) (actual time=0.110..0.110 rows=381 loops=1)
               Index Cond: (idkompozycji = 'buk2'::bpchar)
 Total runtime: 0.854 ms


EXPLAIN ANALYZE select * from zamowienia where idkompozycji = 'buk1';
                                                             QUERY PLAN                                                              
-------------------------------------------------------------------------------------------------------------------------------------
 Bitmap Heap Scan on zamowienia  (cost=11.54..83.84 rows=424 width=52) (actual time=0.169..0.620 rows=424 loops=1)
   Recheck Cond: (idkompozycji = 'buk1'::bpchar)
   ->  Bitmap Index Scan on zamowienia_idkompozycji  (cost=0.00..11.43 rows=424 width=0) (actual time=0.145..0.145 rows=424 loops=1)
         Index Cond: (idkompozycji = 'buk1'::bpchar)
 Total runtime: 0.760 ms


// Indeksy a sortowanie

filidzie=> EXPLAIN ANALYZE select * from zamowienia order by idkompozycji;
                                                                 QUERY PLAN                                                                  
---------------------------------------------------------------------------------------------------------------------------------------------
 Index Scan using zamowienia_idkompozycji on zamowienia  (cost=0.00..483.99 rows=8015 width=52) (actual time=0.023..4.028 rows=8015 loops=1)
 Total runtime: 4.757 ms


DROP INDEX zamowienia_idkompozycji;
EXPLAIN ANALYZE select * from zamowienia order by idkompozycji;
                                                             QUERY PLAN                                                              
-------------------------------------------------------------------------------------------------------------------------------------
 Sort  (cost=10000000666.86..10000000686.90 rows=8015 width=52) (actual time=21.059..21.676 rows=8015 loops=1)
   Sort Key: idkompozycji
   Sort Method: quicksort  Memory: 819kB
   ->  Seq Scan on zamowienia  (cost=10000000000.00..10000000147.15 rows=8015 width=52) (actual time=0.012..1.491 rows=8015 loops=1)
 Total runtime: 22.197 ms


DROP INDEX zamowienia_idklienta ;
DROP INDEX zamowienia_idodbiorcy ;


// Indeksy częściowe

CREATE INDEX zamowienia_idklienta ON zamowienia (idklienta) WHERE zaplacone;

EXPLAIN ANALYZE select * from zamowienia where zaplacone;
                                                             QUERY PLAN                                                              
-------------------------------------------------------------------------------------------------------------------------------------
 Bitmap Heap Scan on zamowienia  (cost=150.29..297.37 rows=8008 width=52) (actual time=0.742..1.714 rows=8008 loops=1)
   Recheck Cond: zaplacone
   ->  Bitmap Index Scan on zamowienia_idklienta  (cost=0.00..148.29 rows=8008 width=0) (actual time=0.722..0.722 rows=8008 loops=1)
 Total runtime: 2.156 ms


EXPLAIN ANALYZE select * from zamowienia where NOT zaplacone
                                                       QUERY PLAN                                                        
-------------------------------------------------------------------------------------------------------------------------
 Seq Scan on zamowienia  (cost=10000000000.00..10000000147.15 rows=7 width=52) (actual time=0.015..2.429 rows=7 loops=1)
   Filter: (NOT zaplacone)
 Total runtime: 2.468 ms


EXPLAIN ANALYZE select sum(cena) from zamowienia where NOT zaplacone
                                                          QUERY PLAN                                                          
------------------------------------------------------------------------------------------------------------------------------
 Aggregate  (cost=10000000147.17..10000000147.18 rows=1 width=5) (actual time=1.421..1.421 rows=1 loops=1)
   ->  Seq Scan on zamowienia  (cost=10000000000.00..10000000147.15 rows=7 width=5) (actual time=0.013..1.412 rows=7 loops=1)
         Filter: (NOT zaplacone)
 Total runtime: 1.457 ms


DROP INDEX zamowienia_idklienta;

// Indeksy na wyrażeniach

CREATE INDEX klienci_miasto ON klienci (LOWER(miasto) varchar_pattern_ops);

EXPLAIN ANALYZE SELECT * FROM klienci where LOWER(miasto) like LOWER('krak%');
                                                        QUERY PLAN                                                         
---------------------------------------------------------------------------------------------------------------------------
 Index Scan using klienci_miasto on klienci  (cost=0.01..8.28 rows=1 width=121) (actual time=0.033..0.069 rows=23 loops=1)
   Index Cond: ((lower((miasto)::text) ~>=~ 'krak'::text) AND (lower((miasto)::text) ~<~ 'kral'::text))
   Filter: (lower((miasto)::text) ~~ 'krak%'::text)
 Total runtime: 0.111 ms

DROP INDEX klienci_miasto;

// Indeksy GiST

ALTER TABLE zamowienia ADD COLUMN lokalizacja point;
UPDATE zamowienia SET lokalizacja=point(random()*100, random()*100);





