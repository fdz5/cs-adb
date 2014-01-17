#!/bin/bash

cd printer
for i in *.xml
do

escaped=`sed "s/'/\"/g" $i` 
psql -c "INSERT INTO printer (name,description) VALUES( '$i', '$escaped');"
 
done
