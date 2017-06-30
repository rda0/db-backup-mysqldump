#!/bin/bash

mkdir -p schema
cd schema

mysql --skip-column-names -A -e"SELECT CONCAT('SHOW GRANTS FOR ''',user,'''@''',host,''';') FROM mysql.user WHERE user<>''" | mysql --skip-column-names -A | sed 's/$/;/g' | gzip > mysql_grants.sql.gz

cd ..
