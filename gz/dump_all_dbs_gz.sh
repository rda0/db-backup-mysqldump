#!/bin/bash

mkdir -p db
cd db

for DB in `cat ../db.list`
do
    mysqldump --hex-blob --routines --triggers --events --lock-all-tables --add-drop-database --databases ${DB} | gzip > ${DB}.sql.gz &
done
wait

cd ..
