#!/bin/bash
#
#
# v1.1 by Johan Denoyer
# Feb 2nd, 2013
#
# v1.0 by Alex Günsche
# June 11th, 2008
# http://www.lxg.de/code/shell-script-to-optimize-all-tables-in-all-databases-mysql

MYSQL_LOGIN='-uADMIN_USER -pYOUR_PASSWORD'
 
for db in $(echo "SHOW DATABASES;" | mysql $MYSQL_LOGIN | grep -v -e "Database" -e "information_schema")
do
        TABLES=$(echo "USE $db; SHOW TABLES;" | mysql $MYSQL_LOGIN |  grep -v Tables_in_)
        echo "Switching to database $db"
        for table in $TABLES
        do
                echo -n " * Optimizing table $table ... "
                echo "USE $db; OPTIMIZE TABLE $table" | mysql $MYSQL_LOGIN  >/dev/null
                echo "done."
        done
done