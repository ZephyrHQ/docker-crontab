#!/bin/sh
set -e

# crond running in background and log file reading by tail to STDOUT
crond -s /var/spool/cron/crontabs -L /var/log/cron/cron.log -b "$@" && tail -f /var/log/cron/cron.log