# HI!

This is a simple little shell script scheduled by cron meand to run tarsnap for daily backup.

# Installation

After Tarsnap has been compiled; move `tarsnap.conf` to `/usr/local/etc/` (that's where it likes to be),
`daily-tarsnap.sh` to `/opt/local/bin/`; and copy-paste the contents of `crontab` into `sudo crontab -e`.

You also need to `mkdir /var/log/backups` and `cd /var/log/backups && touch tarsnap_backups.log && touch
tarsnap_daily.log`.
