#!/bin/bash

mkdir -p schema
cd schema

for DB in mysql
do
    mysqldump --skip-extended-insert --hex-blob --routines --triggers --events --lock-all-tables --add-drop-database --databases ${DB} | gzip > ${DB}.sql.gz
done

cd ..
