#!/bin/sh
DIR=`date +%Y-%m-%d`
BACKUP_DIR=/home/ubuntu/dbbackup
PROD_BACKUP_DIR=$BACKUP_DIR/prod_$DIR
PROD_BACKUP_DIR_DB=$PROD_BACKUP_DIR/$DB_NAME
STAGING_BACKUP_DIR=$BACKUP_DIR/staging_$DIR
LOG_DIR=$BACKUP_DIR/log

mkdir $PROD_BACKUP_DIR
mkdir $STAGING_BACKUP_DIR

PROD_DB_HOST=207.226.141.12
PROD_DB_PORT=27017
PROD_DB_NAME=a_chat_development
PROD_DB_USER=achat
PROD_DB_PASSWORD=achat2cool

STAGING_DB_HOST=dogen.mongohq.com
STAGING_DB_PORT=10020
STAGING_DB_NAME=a_chat_development
STAGING_DB_USER=achat
STAGING_DB_PASSWORD=achat2cool

#echo "mongodump --host $PROD_DB_HOST --port $PROD_DB_PORT --db $PROD_DB_NAME --username $PROD_DB_USER --password $PROD_DB_PASSWORD --out $PROD_BACKUP_DIR"
#mongodump --host $PROD_DB_HOST --port $PROD_DB_PORT --db $PROD_DB_NAME --username $PROD_DB_USER --password $PROD_DB_PASSWORD --out $PROD_BACKUP_DIR
CMD_DUMP_PROD="mongodump --host $PROD_DB_HOST --port $PROD_DB_PORT --db $PROD_DB_NAME --username $PROD_DB_USER --password $PROD_DB_PASSWORD --out $PROD_BACKUP_DIR"
echo "CMD_DUMP_PROD: $CMD_DUMP_PROD"

#echo "mongodump --host $STAGING_DB_HOST --port $STAGING_DB_PORT --db $STAGING_DB_NAME --username $STAGING_DB_USER --password $STAGING_DB_PASSWORD --out $STAGING_BACKUP_DIR"
#mongodump --host $STAGING_DB_HOST --port $STAGING_DB_PORT --db $STAGING_DB_NAME --username $STAGING_DB_USER --password $STAGING_DB_PASSWORD --out $STAGING_BACKUP_DIR
CMD_DUMP_STAGING="mongodump --host $STAGING_DB_HOST --port $STAGING_DB_PORT --db $STAGING_DB_NAME --username $STAGING_DB_USER --password $STAGING_DB_PASSWORD --out $STAGING_BACKUP_DIR"
echo "CMD_DUMP_STAGING: $CMD_DUMP_STAGING"

#echo "mongorestore -h $STAGING_DB_HOST -u $USER -p $PASSWORD --authenticationDatabase $DB_NAME --db $DB_NAME --drop $DB_NAME $PROD_BACKUP_DIR_DB"
#mongorestore -h $STAGING_DB_HOST --port $STAGING_DB_PORT -u $USER -p $PASSWORD --authenticationDatabase $DB_NAME --db $DB_NAME --drop $PROD_BACKUP_DIR_DB
CMD_RESTORE="mongorestore -h $STAGING_DB_HOST --port $STAGING_DB_PORT -u $USER -p $PASSWORD --authenticationDatabase $DB_NAME --db $DB_NAME --drop $PROD_BACKUP_DIR_DB"
echo "CMD_RESTORE: $CMD_RESTORE"

$CMD_DUMP_PROD && $CMD_DUMP_STAGING && $CMD_RESTORE > $LOG_DIR/$DIR.log 2>&1
