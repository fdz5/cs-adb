-- Napisz zapytanie, które znajdzie nazwy i rozdzielczości poziome wszystkich drukarek. Rozdzielczość reprezentowana jest przez element x w dpi w resolution w mechanism w printer

select name, (xpath('//printer/mechanism/resolution/dpi/x/text()', description))[1] as res_x from printer;

-- Napisz zapytanie, które znajdzie nazwy i rozdzielczości poziome wszystkich drukarek i uporządkuj je rosnąco z uwagi na rozdzielczość zakłądająć, że rozdzielczość jesty typu text (dokonaj odpowiedniego rzutowania). Rozdzielczość reprezentowana jest przez element x w dpi w resolution w mechanism w printer

select name, (xpath('//printer/mechanism/resolution/dpi/x/text()', description))[1]::text as res_x from printer order by res_x asc;

-- Napisz zapytanie, które znajdzie nazwy i rozdzielczości poziome wszystkich drukarek i uporządkuj je rosnąco z uwagi na rozdzielczość zakłądająć, że rozdzielczość jesty typu int (dokonaj odpowiedniego rzutowania). Rozdzielczość reprezentowana jest przez element x w dpi w resolution w mechanism w printer

select name, ((xpath('//printer/mechanism/resolution/dpi/x/text()', description))[1]::text)::integer as res_x from printer order by res_x asc;

-- Napisz zapytania, które znajdzie nazwy wszystkich kolorowych drukarek o rozdzielczości poziomej większej niż 1200. Rozdzielczość reprezentowana jest przez element x w dpi w resolution w mechanism w printer Drukarka kolorowa będzie zawierała element color w mechanism w printer. 

select name from printer where ((xpath('//printer/mechanism/resolution/dpi/x/text()', description))[1]::text)::integer > 1200 and xpath_exists('//printer/mechanism/color', description);

