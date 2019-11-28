#!/bin/bash
# Backup data from local drive to attached USB drive
# and copy to cloud
# split archive into pieces in order to fit cloud limit

# Memorize current directory to access credentials file
cur_dir="$(dirname "$0")"
# credentials to access Cloud
. "$cur_dir/credentials.config"

# archive file name 
filename=$(date '+%d-%m-%Y-%H-%M-%S')

# Delete archive volumes from Cloud older than 11 days
find /Volumes/Backup/backup/** -type d -ctime +2s -exec sh -c \
'f="{}";duck -q -y -u '$login' -p '$password' \
-D https://webdav.cloud.mail.ru/backup/"${f##*/}"' \;

# Delete archive volumes from USB drive older than 11 days
find /Volumes/Backup/backup/** -type d -ctime +13d -exec rm -rf {} \;

# Create archive volume folder
mkdir /Volumes/Backup/backup/$filename


# Archive target folders
tar -zcvf "/Users/zamir/temp/$filename.tar" \
/Users/zamir/Documents/ \
/Users/zamir/Movies/video_archive/ \
/Users/zamir/Pictures/photo_archive/;

# Split archive into chunks to file system
split -b 1900m /Users/zamir/temp/$filename.tar \
/Volumes/Backup/backup/$filename/$filename;

# Remove original archive file
rm -rf /Users/zamir/temp/$filename.tar


# Upload files to rhe cloud using WebDav access
duck -q -y -u $login -p $password --nokeychain \
--synchronize https://webdav.cloud.mail.ru/  /Volumes/Backup/backup/ \
--parallel 4 --existing mirror;

# Clear environment variables
unset login
unset password
unset filename

