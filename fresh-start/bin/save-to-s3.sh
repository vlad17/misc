#!/bin/bash
# Backup script to S3. Assumes s3cmd keys have been set up.
# Not reentrant.

echo 'SYNC IS DISABLED ON THIS MACHINE'
exit 0


BACKUPLOGDIR="$HOME/Desktop/backup-logs"

mkdir -p "$HOME/Desktop"
mkdir -p "$BACKUPLOGDIR"

DATE=$(date "+%F-%T")
STDOUTFILE="$BACKUPLOGDIR/backup-stdout-$DATE.txt"
STDERRFILE="$BACKUPLOGDIR/backup-stderr-$DATE.txt"

cd

LOGFILE="$HOME/Desktop/s3syncs.txt"

echo "Started full s3cmd sync on" $(date) | tee --append $LOGFILE

SECONDS=0
/usr/bin/s3cmd sync --debug --verbose --cache-file=$HOME/.cache/s3cache --delete-removed --delete-after --rexclude-from ~/.s3ignore --include 'dev/README.txt' $HOME s3://vlad-pc-backups 2>$STDERRFILE | tee $STDOUTFILE
success="$?"
duration=$SECONDS

echo "    finished sync on" $(date) | tee --append $LOGFILE
echo "    backup duration: $duration s" | tee --append $LOGFILE
echo "    stdout: $STDOUTFILE" | tee --append $LOGFILE
echo "    stderr: $STDERRFILE" | tee --append $LOGFILE
echo "    errors:" | tee --append $LOGFILE
errors=$(grep ERROR $STDERRFILE | tee --append $LOGFILE)

if grep ERROR $STDERRFILE; then
    sparkpostmail.sh "vladimirfeinberg@gmail.com" "ERROR: backup $DATE" "$errors"
fi



