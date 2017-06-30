#!/bin/bash

mkdir -p db
cd db

for DB in `cat ../db.list`
do
    mysqldump --skip-extended-insert --hex-blob --routines --triggers --events --lock-all-tables --add-drop-database --databases ${DB} > ${DB}.sql &
done
wait

cd ..
