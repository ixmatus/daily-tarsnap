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

/opt/local/bin/port installed > /Users/ixmatus/mac_ports_installed.txt
ls -al /Applications > /Users/ixmatus/mac_dmgs_installed.txt

logecho "--- Executing tarsnap backup"

# Only backing up text and configuration files in home dir. Large
# media (images, music, video) should be on external hdds!
# 
# Some images/video will be picked up but the major sources of them
# should be excluded.
/usr/local/bin/tarsnap \
--exclude "VirtualBox VMs" \
--exclude .vagrant.d \
--exclude .emacs \
--exclude .emacs.d \
--exclude .virtualenvs \
--exclude *dialyzer_plt \
--exclude .fabricrc \
--exclude .bower \
--exclude .android \
--exclude .dropbox \
--exclude .gem \
--exclude .ghc \
--exclude .npm \
--exclude .pylint.d \
--exclude .python-eggs \
--exclude .saves \
--exclude .pythonz \
--exclude .
--exclude Temp \
--exclude tmp \
--exclude Cloud \
--exclude Programming \
--exclude Downloads \
--exclude Music \
--exclude Movies \
--exclude Pictures \
--exclude Sites \
--exclude Public \
--exclude node_modules \
--exclude ~/Library \
-vcf home_backup-`date +\%Y-%m-%d` \
/Users/ixmatus/ \
>> ${DAILYLOG} 2>&1

logecho "--- Backing up library"

/usr/local/bin/tarsnap \
--exclude "/Users/ixmatus/Library/Application Support/Bitcoin/blocks" \
--exclude "/Users/ixmatus/Library/Application Support/Bitcoin/blk*.dat" \
--exclude "/Users/ixmatus/Library/Application Support/Skype/EmoticonCache.bundle" \
-vcf library_backup-`date +\%Y-%m-%d` \
"/Users/ixmatus/Library/Application Support/"
>> ${DAILYLOG} 2>&1

logecho "--- Tarsnap backup complete"

logecho "--- Cleaning up after myself"

rm -f /Users/ixmatus/mac_ports_installed.txt
rm -f /Users/ixmatus/mac_dmgs_installed.txt

# Append the log for this backup to the main log file
cat $DAILYLOG >> $LOGFILE
