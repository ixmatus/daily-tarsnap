#!/bin/bash

# Set the HOME ENV variable to avoid some errors
export HOME=/Users/ixmatus

# Setup some logging variables
HOST=`hostname`
LOGFILE="/var/log/backups/tarsnap_backups.log"
DAILYLOG="/var/log/backups/tarsnap_daily.log"

# Clear the daily log
cat /dev/null > ${DAILYLOG}

# Formatting for logfile
logecho () {
    ts=`date +%Y-%m-%d_%H:%M:%S`
    echo "${HOST} $ts: $*" >> ${DAILYLOG}
}

# Execute the backup
logecho "--- Executing tarsnap backup"

tarsnap -c -f system_backup-`date +\%Y-%m-%d` /Applications /Users/ixmatus /Library >> ${DAILYLOG} 2>&1

logecho "--- tarsnap backup complete"

# Append the log for this backup to the main log file
cat $DAILYLOG >> $LOGFILE
