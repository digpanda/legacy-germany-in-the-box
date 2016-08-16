#!/bin/bash
# Bash Menu Script Example

BACKUP="-backup"
FIRST_COLUMN="_1st_col"

############### Qiniu Bucket names ###############
BUCKET_NAME_PROD=carrierwave-laiyinn-prod
BUCKET_NAME_PROD_BACKUP=$BUCKET_NAME_PROD$BACKUP

BUCKET_NAME_STAGING=carrierwave-laiyinn-staging
BUCKET_NAME_STAGING_BACKUP=$BUCKET_NAME_STAGING$BACKUP

############### Qiniu Bucket commands using qshell tool for qiniu ############### 

############### Step1: get all file names into a list for a bucket###############
CMD_LIST_BUCKET_PROD="./qshell listbucket $BUCKET_NAME_PROD $BUCKET_NAME_PROD.txt"
CMD_LIST_BUCKET_PROD_BACKUP="./qshell listbucket $BUCKET_NAME_PROD_BACKUP $BUCKET_NAME_PROD_BACKUP.txt"

CMD_LIST_BUCKET_STAGING="./qshell listbucket $BUCKET_NAME_STAGING $BUCKET_NAME_STAGING.txt"
CMD_LIST_BUCKET_STAGING_BACKUP="./qshell listbucket $BUCKET_NAME_STAGING_BACKUP $BUCKET_NAME_STAGING_BACKUP.txt"

#CMD_SHORT_LIST_PROD=$(cat $BUCKET_NAME_PROD.txt | awk '{print $1}' > $BUCKET_NAME_PROD$FIRST_COLUMN.txt)
#CMD_SHORT_LIST_PROD_BACKUP=$(cat $BUCKET_NAME_PROD_BACKUP.txt | awk '{print $1}' > $BUCKET_NAME_PROD_BACKUP$FIRST_COLUMN.txt)

#CMD_SHORT_LIST_STAGING=$(cat $BUCKET_NAME_STAGING.txt | awk '{print $1}' > $BUCKET_NAME_STAGING$FIRST_COLUMN.txt)
#CMD_SHORT_LIST_STAGING_BACKUP=$(cat $BUCKET_NAME_STAGING_BACKUP.txt | awk '{print $1}' > $BUCKET_NAME_STAGING_BACKUP$FIRST_COLUMN.txt)

# in 1 command to export file lists for all buckets
#CMD_CREATE_FILE_LIST="echo export file lists for all buckets..." && $CMD_LIST_BUCKET_PROD && $CMD_SHORT_LIST_PROD && $CMD_LIST_BUCKET_PROD_BACKUP && $CMD_SHORT_LIST_PROD_BACKUP && $CMD_LIST_BUCKET_STAGING && $CMD_SHORT_LIST_STAGING && $CMD_LIST_BUCKET_STAGING_BACKUP && $CMD_SHORT_LIST_STAGING_BACKUP 
#CMD_CREATE_FILE_LIST="echo export file lists for all buckets...";$CMD_LIST_BUCKET_PROD;$CMD_SHORT_LIST_PROD;$CMD_LIST_BUCKET_PROD_BACKUP;$CMD_SHORT_LIST_PROD_BACKUP;$CMD_LIST_BUCKET_STAGING;$CMD_SHORT_LIST_STAGING;$CMD_LIST_BUCKET_STAGING_BACKUP;$CMD_SHORT_LIST_STAGING_BACKUP 


############### Step2: make backup for prod and staging bucket ###############
# remove all from prod backup bucket
CMD_CLEAN_PROD_BACKUP="./qshell batchdelete $BUCKET_NAME_PROD_BACKUP $BUCKET_NAME_PROD_BACKUP$FIRST_COLUMN.txt"

# copy from prod bucket to prod-backup bucket
CMD_MAKE_PROD_BACKUP="./qshell batchcopy $BUCKET_NAME_PROD $BUCKET_NAME_PROD_BACKUP $BUCKET_NAME_PROD$FIRST_COLUMN.txt"

# remove all from staging backup bucket
CMD_CLEAN_STAGING_BACKUP="./qshell batchdelete $BUCKET_NAME_STAGING_BACKUP $BUCKET_NAME_STAGING_BACKUP$FIRST_COLUMN.txt"

# copy from staging bucket to staging-backup bucket
CMD_MAKE_STAGING_BACKUP="./qshell batchcopy $BUCKET_NAME_STAGING $BUCKET_NAME_STAGING_BACKUP $BUCKET_NAME_STAGING$FIRST_COLUMN.txt"

# in 1 command to make backup for prod and staging bucket
#CMD_BACKUP_PROD_AND_STAGING="echo make backup for prod and staging bucket..." && $CMD_CLEAN_PROD_BACKUP && $CMD_MAKE_PROD_BACKUP && $CMD_CLEAN_STAGING_BACKUP && $CMD_MAKE_STAGING_BACKUP


############### Step3: copy from prod to staging bucket ###############
# remove all from staging bucket
CMD_CLEAN_STAGING="./qshell batchdelete $BUCKET_NAME_STAGING $BUCKET_NAME_STAGING$FIRST_COLUMN.txt"

# copy from prod bucket to staging bucket
CMD_PROD_TO_STAGING="./qshell batchcopy $BUCKET_NAME_PROD $BUCKET_NAME_STAGING $BUCKET_NAME_PROD$FIRST_COLUMN.txt"

PS3='Please enter your next choice from 1 to 11:'
options=("export prod bucket file list" "process prod bucket file list" "export prod-backup bucket file list" "process prod-backup bucket file list" "export staging bucket file list" "process staging bucket file list" "clean prod backup" "backup prod" "clean staging" "prod to staging" "Quit")
select opt in "${options[@]}"
do
    case $opt in
        "export prod bucket file list")
            echo "you chose choice 1"
            $CMD_LIST_BUCKET_PROD
            ;;
        "process prod bucket file list")
            echo "you chose choice 2"
            cat $BUCKET_NAME_PROD.txt | awk '{print $1}' > $BUCKET_NAME_PROD$FIRST_COLUMN.txt
            ;;
        "export prod-backup bucket file list")
            echo "you chose choice 3"
            $CMD_LIST_BUCKET_PROD_BACKUP
            ;;
        "process prod-backup bucket file list")
	        echo "you chose choice 4"
            cat $BUCKET_NAME_PROD_BACKUP.txt | awk '{print $1}' > $BUCKET_NAME_PROD_BACKUP$FIRST_COLUMN.txt
	        ;;
        "export staging bucket file list")
	        echo "you chose choice 5"
	        $CMD_LIST_BUCKET_STAGING
	        ;;
        "process staging bucket file list")
	        echo "you chose choice 6"
            cat $BUCKET_NAME_STAGING.txt | awk '{print $1}' > $BUCKET_NAME_STAGING$FIRST_COLUMN.txt
	        ;;
        "clean prod backup")
	        echo "you chose choice 7"
            $CMD_CLEAN_PROD_BACKUP
	        ;;
        "backup prod")
	        echo "you chose choice 8"
            $CMD_MAKE_PROD_BACKUP
	        ;;
        "clean staging")
	        echo "you chose choice 9"
            $CMD_CLEAN_STAGING
	        ;;
        "prod to staging")
	        echo "you chose choice 10"
            $CMD_PROD_TO_STAGING
	        ;;
        "Quit")
            break
            ;;
        *) echo invalid option;;
    esac
done
