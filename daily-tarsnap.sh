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

logecho "--- Dumping list of installations"

port installed > /Users/ixmatus/mac_ports_installed.txt
ls -al /Applications > /Users/ixmatus/mac_dmgs_installed.txt

logecho "--- Executing tarsnap backup"

# Only backing up my home dir as everything else *should* be
# configurable from what's in my homedir only
tarsnap -c -f \
system_backup-`date +\%Y-%m-%d` \
/Users/ixmatus/Certs \
/Users/ixmatus/Cloud \
/Users/ixmatus/Documents \
/Users/ixmatus/Desktop \
/Users/ixmatus/.* \
--exclude .vagrant.d .emacs .emacs.d *dialyzer_plt .emacs.elc .fabricrc \
>> ${DAILYLOG} 2>&1

logecho "--- Tarsnap backup complete"

logecho "--- Cleaning up after myself"

rm -f /Users/ixmatus/mac_ports_installed.txt
rm -f /Users/ixmatus/mac_dmgs_installed.txt

# Append the log for this backup to the main log file
cat $DAILYLOG >> $LOGFILE
