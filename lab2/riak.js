curl -v -XPUT  -H 'x-riak-index-lang_bin: pl' -d @f1 http://nosql.kis.agh.edu.pl:8098/riak/fdziedzic/f1
curl -v -XPUT  -H 'x-riak-index-lang_bin: pl' -d @f2 http://nosql.kis.agh.edu.pl:8098/riak/fdziedzic/f2
curl -v -XPUT  -H 'x-riak-index-lang_bin: pl' -d @f3 http://nosql.kis.agh.edu.pl:8098/riak/fdziedzic/f3
curl -v -XPUT  -H 'x-riak-index-lang_bin: en' -d @f4 http://nosql.kis.agh.edu.pl:8098/riak/fdziedzic/f4
curl -v -XPUT  -H 'x-riak-index-lang_bin: en' -d @f5 http://nosql.kis.agh.edu.pl:8098/riak/fdziedzic/f5

curl -X POST -H "Content-type: application/json" http://nosql.kis.agh.edu.pl:8098/mapred -d @riak-pl.json
curl -X POST -H "Content-type: application/json" http://nosql.kis.agh.edu.pl:8098/mapred -d @riak-en.json
