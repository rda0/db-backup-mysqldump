#!/bin/bash

mkdir -p schema
cd schema

for DB in information_schema performance_schema
do
    mysqldump --skip-extended-insert --hex-blob --routines --triggers --skip-lock-tables --add-drop-database --databases ${DB} | gzip > ${DB}.sql.gz
done

cd ..
