# db-backup-mysqldump
Create a full database backup using mysqldump

## backup

to plain `.sql`:

```
./dump.sh
```

to gzipped `.sql.gz`:

```
cd gz
./dump_gz.sh
```

## restore

plain `.sql` dumps:

```
cd backup-dir
mysql < schema/mysql_grants.sql
mysql -A -e "flush privileges;"
for DB in db/*.sql
do
    gunzip < ${DB} | mysql
done
cd ..
```

gzipped `.sql.gz` dumps:

```
cd backup-dir
gunzip < schema/mysql_grants.sql.qz | mysql
mysql -A -e "flush privileges;"
for DB in db/*.sql.gz
do
    gunzip < ${DB} | mysql
done
cd ..
```

## notes

Using separate process, run `FLUSH TABLES WITH READ LOCK; SELECT SLEEP(86400)` before launching mysqldumps.  
Kill this process after mysqldumps are complete. This is helpful if a database contains both `InnoDB` and `MyISAM`

**Caveat**: mysqldumps created this way can only be reloaded into the same major release version of mysql.

### mysqldump options explained

Required option: **`--opt`** (is on by default), is shorthand for the combination of:

```
--add-drop-table
--add-locks
--create-options
--disable-keys
--extended-insert
--lock-tables
--quick
--set-charset
```

It gives a fast dump operation and produces a dump file that can be reloaded into a MySQL server quickly.  
Because the `--opt` option is enabled by default, you only specify its converse, the `--skip-opt` to turn off several default settings.

### Possibly required additional options

- **`--single-transaction`**: If all tables are `InnoDB`. (this will auto deactivate `--lock-tables`)
- **`--lock-all-tables`**: If one or more tables are `MyISAM`. (this will auto deactivate `--lock-tables`, `--single-transaction`)
- **`--routines`**: If `Number_Of_Stored_Procedures` is greater than zero.
- **`--triggers`**: If `Number_Of_Triggers` is greater than zero. (enabled by default)

### Additional options

- **`--add-drop-database`**: Just makes `DROP TABLE IF EXISTS` faster.
- **`--events`**: Include Event Scheduler events for the dumped databases in the output.
- **`--hex-blob`**: Dump binary columns using hexadecimal notation (for example, `abc` becomes `0x616263`). The affected data types are `BINARY`, `VARBINARY`, the `BLOB` types, and `BIT`.
- **`--skip-extended-insert`**: Disables `--extended-insert`, separate row per `INSERT`, better for viewing.
- **`--extended-insert`**: Write `INSERT` statements using multiple-row syntax that includes several `VALUES` lists. This results in a smaller dump file and speeds up inserts when the file is reloaded.

## Useful queries

### Show table types and row count

```
select `table_schema`, `table_name`, `engine`, `table_rows` from `information_schema`.`tables`
```

### Show table type count

```
SELECT engine,COUNT(1) TableCount FROM information_schema.tables WHERE engine IN ('InnoDB');
```
```
+--------+------------+
| engine | TableCount |
+--------+------------+
| InnoDB |       1153 |
+--------+------------+
```
```
SELECT engine,COUNT(1) TableCount FROM information_schema.tables WHERE engine IN ('MyISAM');
```
```
+--------+------------+
| engine | TableCount |
+--------+------------+
| MyISAM |       1113 |
+--------+------------+
```
```
SELECT engine,COUNT(1) TableCount FROM information_schema.tables WHERE engine IN ('MEMORY');
```
```
+--------+------------+
| engine | TableCount |
+--------+------------+
| MEMORY |         41 |
+--------+------------+
```

### Show number of stored procedures

```
SELECT COUNT(1) Number_Of_Stored_Procedures FROM mysql.proc;
```
```
+-----------------------------+
| Number_Of_Stored_Procedures |
+-----------------------------+
|                          31 |
+-----------------------------+
```

### Show number of triggers

```
SELECT COUNT(1) Number_Of_Triggers FROM information_schema.triggers;
```
```
+--------------------+
| Number_Of_Triggers |
+--------------------+
|                  3 |
+--------------------+
```

