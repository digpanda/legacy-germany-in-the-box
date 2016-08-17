#!/bin/bash
# Bash Menu Script Example

#PROD_BACKUP="-backup"
PROD_BACKUP="-replica" #swap to this only when manual updating prod replica bucket! Normally you do not use it! use task1:1-4/task2:1-2 for making prod->replica. 
STAGING_BACKUP="-backup"
FIRST_COLUMN="_1st_col"

############### Qiniu Bucket names ###############
BUCKET_NAME_PROD=carrierwave-laiyinn-prod
BUCKET_NAME_PROD_BACKUP=$BUCKET_NAME_PROD$PROD_BACKUP
#BUCKET_NAME_PROD_BACKUP=$BUCKET_NAME_PROD$PROD_BACKUP #swap to this only when manual updating prod replica bucket! Normally you do not use it! use task1:1-4/task2:1-2 for making prod->replica. 

BUCKET_NAME_STAGING=carrierwave-laiyinn-staging
BUCKET_NAME_STAGING_BACKUP=$BUCKET_NAME_STAGING$STAGING_BACKUP

############### Qiniu Bucket commands using qshell tool for qiniu ############### 

############### Task1 Commands: get all file names into a list for a bucket###############
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


############### Task2 Commands: make backup for prod and staging bucket ###############
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

function print_quit_message() {
    bye="        Oops, you chose Quit/Skip, bye bye!\n"
    printf "$bye"
    printf "$1"
}

function check_quit_case() {
    case $REPLY in
                "Q")
                    print_quit_message "$1"
                    break
                    ;;
                "q")
                    print_quit_message "$1"
                    break
                    ;;
    esac
}

function image_bucket_imagefile_list {
    printf "\n====== Task1: Image bucket imagefile list export and processing: Start! ======\n"
    printf "    - Please enter your step number 1-8 \n    - To quit this task/skip the rest steps in task enter q or 9\n\n"

    Stepcount=1
    local PS3=$'\n :: Task1: Please enter your step number (1-8):'
    local options=("export prod bucket file list" "process prod bucket file list" "export prod-backup bucket file list" "process prod-backup bucket file list" "export staging bucket file list" "process staging bucket file list" "export staging-backup bucket file list" "process staging-backup bucket file list" "Quit/Skip")
    select opt in "${options[@]}"
    do
        echo "    You chose Step $REPLY : $opt"
        check_quit_case "====== Task1: Image bucket imagefile list export and processing: Quit/Skip! ======\n\n"
        
        case $opt in
            "export prod bucket file list")
                echo "        execute step 1..."
                $CMD_LIST_BUCKET_PROD
                let Stepcount=Stepcount+1
                ;;
            "process prod bucket file list")
                echo "        execute step 2..."
                cat $BUCKET_NAME_PROD.txt | awk '{print $1}' > $BUCKET_NAME_PROD$FIRST_COLUMN.txt
                let Stepcount=Stepcount+1
                ;;
            "export prod-backup bucket file list")
                echo "        execute step 3..."
                $CMD_LIST_BUCKET_PROD_BACKUP
                let Stepcount=Stepcount+1
                ;;
            "process prod-backup bucket file list")
                echo "        execute step 4..."
                cat $BUCKET_NAME_PROD_BACKUP.txt | awk '{print $1}' > $BUCKET_NAME_PROD_BACKUP$FIRST_COLUMN.txt
                let Stepcount=Stepcount+1
                ;;
            "export staging bucket file list")
                echo "        execute step 5..."
                $CMD_LIST_BUCKET_STAGING
                let Stepcount=Stepcount+1
                ;;
            "process staging bucket file list")
                echo "        execute step 6..."
                cat $BUCKET_NAME_STAGING.txt | awk '{print $1}' > $BUCKET_NAME_STAGING$FIRST_COLUMN.txt
                let Stepcount=Stepcount+1
                ;;
            "export staging-backup bucket file list")
                echo "        execute step 7..."
                $CMD_LIST_BUCKET_STAGING_BACKUP
                let Stepcount=Stepcount+1
                ;;
            "process staging-backup bucket file list")
                echo "        execute step 8..."
                cat $BUCKET_NAME_STAGING_BACKUP.txt | awk '{print $1}' > $BUCKET_NAME_STAGING_BACKUP$FIRST_COLUMN.txt
                printf "====== Task1: Image bucket imagefile list export and processing: Done! ======\n\n"
                break
                ;;            
            "Quit/Skip")
                print_quit_message "====== Task1: Image bucket imagefile list export and processing: Quit/Skip! ======\n\n"
                break
                ;;
            *) echo "        invalid option, please choose 1-8";;
        
        esac
        echo "    Next Step: $Stepcount"
    done
}

function image_bucket_imagefile_export_import {
    printf "\n====== Task2: Image bucket image files export and import: Start! ======\n"
    printf "    - Please enter your step number 1-6 \n    - To quit this task/skip the rest steps in task enter q or 7\n\n"

    Stepcount=1
    local PS3=$'\n :: Task2: Please enter your step number (1-6):'
    local options=("clean prod backup" "backup prod" "clean stagging backup" "backup stagging" "clean staging" "prod to staging" "Quit/Skip")
    select opt in "${options[@]}"
    do
        echo "    You chose Step $REPLY : $opt"
        check_quit_case "====== Task2: Image bucket image files export and import: Quit/Skip! ======\n\n"

        case $opt in
            "clean prod backup")
                echo "        execute step 1..."
                $CMD_CLEAN_PROD_BACKUP
                let Stepcount=Stepcount+1
                ;;
            "backup prod")
                echo "        execute step 2..."
                $CMD_MAKE_PROD_BACKUP
                let Stepcount=Stepcount+1
                ;;
            "clean stagging backup")
                echo "        execute step 3..."
                $CMD_CLEAN_STAGING_BACKUP
                let Stepcount=Stepcount+1
                ;;
            "backup stagging")
                echo "        execute step 4..."
                $CMD_MAKE_STAGING_BACKUP
                let Stepcount=Stepcount+1
                ;;
            "clean staging")
                echo "        execute step 5..."
                $CMD_CLEAN_STAGING
                let Stepcount=Stepcount+1
                ;;
            "prod to staging")
                echo "        execute step 6..."
                $CMD_PROD_TO_STAGING
                printf "====== Task2: Image bucket image files export and import: Done! ======\n\n"
                break
                ;;
            "Quit/Skip")
                print_quit_message "====== Task2: Image bucket image files export and import: Quit/Skip! ======\n\n"
                break
                ;;
            *) echo "        invalid option, please choose 1-6";;
        esac
        echo "    Next Step: $Stepcount"
    done
}

printf "************************************************************\n"
printf "******** Germanyinthebox Qiniu image bucket manager ********\n"
printf "************************************************************\n\n"
printf "Note: Task2 is based on output of Task1, normally you will do 1 then 2\n"

printf "    - Please choose Task number 1,2 \n    - To quit enter q or 3\n\n"

PS3="Please select a Task (1,2): "
TASKS=("Task1: Image bucket imagefile list export and processing" "Task2: Image bucket image files export and import" "Quit/Skip")
select task in "${TASKS[@]}"
do
    echo "    You chose Task $REPLY : $opt"
    check_quit_case "====== Germanyinthebox Qiniu image bucket manager: Quit! ======\n\n"

    case $REPLY in
        "Q")
            echo "        Oops, you chose Quit/Skip, bye bye!"
            break
            ;;
        "q")
            echo "        Oops, you chose Quit/Skip, bye bye!"
            break
            ;;
    esac

    case $task in
        "Task1: Image bucket imagefile list export and processing") 
            image_bucket_imagefile_list
            ;;
        "Task2: Image bucket image files export and import") 
            image_bucket_imagefile_export_import 
            ;;
        "Quit/Skip") 
            print_quit_message "====== Germanyinthebox Qiniu image bucket manager: Quit! ======\n\n"
            break 
            ;;
    esac
done