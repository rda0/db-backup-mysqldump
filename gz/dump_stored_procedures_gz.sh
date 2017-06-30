#!/bin/bash

mkdir -p schema
cd schema

mysqldump --skip-extended-insert --no-data --no-create-info --routines --all-databases | gzip > stored_procedures.sql.gz

cd ..
