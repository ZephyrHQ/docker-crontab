#!/bin/sh
set -e
[[ $ENABLED != "true" ]] && exit
chown root:root /var/spool/cron/crontabs/root
chmod 777 /var/spool/cron/crontabs/root
echo START $CMD "$@"
exec $CMD "$@"