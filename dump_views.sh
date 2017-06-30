#!/bin/bash

mkdir -p schema
cd schema

mysqldump --skip-extended-insert information_schema VIEWS > views.sql

cd ..
