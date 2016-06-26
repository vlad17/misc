#!/bin/bash
# Backup script to S3. Assumes s3cmd keys have been set up.
# Not reentrant. Uses enviornment variable BUCKET for your s3 bucket.
#
# Feel free to use/modify this, but with citation to my repo:
# https://github.com/vlad17/misc

BACKUPLOGDIR="$HOME/Desktop/backup-logs"

mkdir -p "$HOME/Desktop"
mkdir -p "$BACKUPLOGDIR"

DATE=$(date "+%F-%T")
STDOUTFILE="$BACKUPLOGDIR/backup-stdout-$DATE.txt"
STDERRFILE="$BACKUPLOGDIR/backup-stderr-$DATE.txt"

cd

echo "Started full s3cmd sync on" $(date) >> Desktop/s3syncs.txt

SECONDS=0
/usr/bin/s3cmd sync --delete-removed --delete-after --rexclude-from ~/.s3ignore --include 'dev/README.txt' $HOME s3://$BUCKET 2>$STDERRFILE | tee $STDOUTFILE
success="$?"
duration=$SECONDS

echo "          finished sync on" $(date) >> Desktop/s3syncs.txt
echo "          backup duration: $duration s"

if [ "$success" -eq 0 ]; then
    success="YES"
else
    success="NO! Check $BACKUPLOGDIR for $DATE files."
fi
echo "               successful? $success"

