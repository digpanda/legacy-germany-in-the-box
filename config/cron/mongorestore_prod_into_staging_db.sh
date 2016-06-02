#!/bin/sh
STAGING_DB_HOST=dogen.mongohq.com:10020
DB_NAME=a_chat_development
USER=achat
PASSWORD=achat2cool

DIR=`date +%Y-%m-%d`
PROD_BACKUP_DIR=/home/ubuntu/dbbackup/prod_$DIR/$DB_NAME

echo "mongorestore -h $STAGING_DB_HOST -u $USER -p $PASSWORD --authenticationDatabase $DB_NAME --db $DB_NAME --drop $DB_NAME $PROD_BACKUP_DIR"
mongorestore -h $STAGING_DB_HOST -u $USER -p $PASSWORD --authenticationDatabase $DB_NAME --db $DB_NAME --drop $PROD_BACKUP_DIR