#!/bin/bash
# Backup data from local drive to attached USB drive
# and copy to cloud
# split archive into pieces in order to fit cloud limit

# archive file name 
filename=$(date '+%d-%m-%Y')

# Delete archive volumes older than 1 minute
find /Users/zamir/cloud.mail/backup/* -type d -ctime +11d -exec rm -rf {} \;

# Create archive volume folder
mkdir /Users/zamir/cloud.mail/backup/$filename

# Archive target folders
tar -zcvf "/Users/zamir/temp/$filename.tar" \
/Users/zamir/Documents/ \
/Users/zamir/cloud.mail/KeePass/ \
/Users/zamir/Movies/video_archive/ \
/Users/zamir/Pictures/photo_archive/;

# Split archive into chunks to fit cloud
split -b 1900m /Users/zamir/temp/$filename.tar \
/Users/zamir/cloud.mail/backup/$filename/$filename;

# Remove original archive file
rm -rf /Users/zamir/temp/$filename.tar

# Delete archive volumes from USB drive older than 11 days minute
find /Volumes/Backup/backup/** -type d -ctime +11d -exec rm -rf {} \;

#Copy archive volume to USB drive
cp -r /Users/zamir/cloud.mail/backup/$filename /Volumes/Backup/backup
