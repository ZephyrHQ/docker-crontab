#!/bin/sh
DATE=$(date "+%Y/%m/%d %H:%M:%S")
PID=$(ps aux | grep cron | grep -v grep | awk '{print $1}')
TIMEOUT=$1
shift
COMMAND=$*
FID=$(shuf -i10000-99999 -n1)

function currentDate() {
    date "+%Y/%m/%d %H:%M:%S"
}

function execute() {

/usr/bin/expect <<EOD
set timeout $TIMEOUT
spawn sh
expect -re "PROMPT" { send  "id \r" }
expect -re "PROMPT" { send "$COMMAND \r" }
expect -re "PROMPT" { exit 1 }
expect timeout 
    send \x03
    exit 1
}
EOD

}

function log() {
    DATE=$(currentDate)
    echo "$DATE [$FID] begin execution $COMMAND with timeout $TIMEOUT" > /proc/${PID}/fd/1
    execute 2>&1 |
        sed -r "s/\x1b\[([0-9]{1,2}(;[0-9]{1,2})?)?m//g" |
        sed -r "s/\e\[([0-9]{1,2}(;[0-9]{1,2})?)?m//g" |
        sed "s/\r/\n/g" |
        sed "s/\e\[2K//g" |
        grep -v "^$" |
        awk -v prefix="$DATE [$FID]" '{print prefix" "$0}' > /proc/${PID}/fd/1
    DATE=$(currentDate)
    echo "$DATE [$FID] fin execution $COMMAND" > /proc/${PID}/fd/1 2>&1
    echo
}

log
