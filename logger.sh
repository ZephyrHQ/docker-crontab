#!/bin/sh
date=$(date "+%Y/%m/%d %H:%M")

function execute() {
    $* 2>&1 | tee /var/log/cron/current.log
}

function log() {
    echo "$date execution $*" >> /var/log/cron/cron.log
    log=$(execute $*)
    echo "$date $log" >> /var/log/cron/cron.log
}

log $*