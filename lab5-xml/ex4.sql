-- Napisz zapytanie, które znajdzie nazwy i rozdzielczości poziome wszystkich drukarek. Rozdzielczość reprezentowana jest przez element x w dpi w resolution w mechanism w printer

EXPLAIN ANALYZE select name, (xpath('//printer/mechanism/resolution/dpi/x/text()', description))[1] as res_x from printer;

-- Napisz zapytanie, które znajdzie nazwy i rozdzielczości poziome wszystkich drukarek i uporządkuj je rosnąco z uwagi na rozdzielczość zakłądająć, że rozdzielczość jesty typu text (dokonaj odpowiedniego rzutowania). Rozdzielczość reprezentowana jest przez element x w dpi w resolution w mechanism w printer

EXPLAIN ANALYZE select name, (xpath('//printer/mechanism/resolution/dpi/x/text()', description))[1]::text as res_x from printer order by res_x asc;

-- Napisz zapytanie, które znajdzie nazwy i rozdzielczości poziome wszystkich drukarek i uporządkuj je rosnąco z uwagi na rozdzielczość zakłądająć, że rozdzielczość jesty typu int (dokonaj odpowiedniego rzutowania). Rozdzielczość reprezentowana jest przez element x w dpi w resolution w mechanism w printer

EXPLAIN ANALYZE select name, ((xpath('//printer/mechanism/resolution/dpi/x/text()', description))[1]::text)::integer as res_x from printer order by res_x asc;

-- Napisz zapytania, które znajdzie nazwy wszystkich kolorowych drukarek o rozdzielczości poziomej większej niż 1200. Rozdzielczość reprezentowana jest przez element x w dpi w resolution w mechanism w printer Drukarka kolorowa będzie zawierała element color w mechanism w printer. 

EXPLAIN ANALYZE select name from printer where ((xpath('//printer/mechanism/resolution/dpi/x/text()', description))[1]::text)::integer > 1200 and xpath_exists('//printer/mechanism/color', description);

CREATE INDEX idx_xml_printer_asc ON printer USING btree (
  (
    (xpath('//printer/mechanism/resolution/dpi/x/text()', description))
    [1]::text::integer
  )
);

SET ENABLE_SEQSCAN TO OFF;

