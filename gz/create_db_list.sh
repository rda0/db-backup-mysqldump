#!/bin/bash

mysql -A --skip-column-names -e"SELECT DISTINCT table_schema FROM information_schema.tables WHERE table_schema NOT IN ('information_schema','mysql')" > db.list
sed -i.bak '/performance_schema/d' ./db.list
