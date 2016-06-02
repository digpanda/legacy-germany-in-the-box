#!/bin/sh
DIR=`date +%Y-%m-%d`
PROD_BACKUP_DIR=/home/ubuntu/dbbackup/prod_$DIR
STAGING_BACKUP_DIR=/home/ubuntu/dbbackup/staging_$DIR

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

echo "mongodump --host $PROD_DB_HOST --port $PROD_DB_PORT --db $PROD_DB_NAME --username $PROD_DB_USER --password $PROD_DB_PASSWORD --out $PROD_BACKUP_DIR"
mongodump --host $PROD_DB_HOST --port $PROD_DB_PORT --db $PROD_DB_NAME --username $PROD_DB_USER --password $PROD_DB_PASSWORD --out $PROD_BACKUP_DIR

echo "mongodump --host $STAGING_DB_HOST --port $STAGING_DB_PORT --db $STAGING_DB_NAME --username $STAGING_DB_USER --password $STAGING_DB_PASSWORD --out $STAGING_BACKUP_DIR"
mongodump --host $STAGING_DB_HOST --port $STAGING_DB_PORT --db $STAGING_DB_NAME --username $STAGING_DB_USER --password $STAGING_DB_PASSWORD --out $STAGING_BACKUP_DIR