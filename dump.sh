#!/bin/bash

HOST="$(hostname)"
DATE="$(date +"%Y%m%d")"
DIR="${HOST}-${DATE}"

if [ -d "${DIR}" ]; then
    echo "Directory ${DIR} does already exist. exiting..."
    exit 1
fi

echo "Starting backup..."

echo "Create db.list..."
./create_db_list.sh
for DB in `cat db.list`
do
    echo "    ${DB}"
done

echo "Dump grants..."
./dump_grants.sh
echo "Dump stored procedures..."
./dump_stored_procedures.sh
echo "Dump information and performance schema..."
./dump_information_and_performance_schema.sh
echo "Dump mysql db..."
./dump_mysql_db.sh
echo "Dump views..."
./dump_views.sh
#./dump_all_dbs_skip_extented_insert.sh
echo "Dump all databases..."
./dump_all_dbs.sh

echo "Create directory ${DIR}..."
mkdir -p "${DIR}"
echo "Move all files to ${DIR}..."
mv db.list "${DIR}"
mv db.list.bak "${DIR}"
mv db "${DIR}"
mv schema "${DIR}"

echo "Host: ${HOST}"
echo "Date: ${DATE}"
echo "Backup finished."
