#!/bin/bash

if [[ -z "$1" ]]; then
  fqdn=`hostname -f`
else
  fqdn=$1
fi

serverspec "check:server:$fqdn $*" &> ./cron_run.log

echo $(date) >> ./cron_run.log

if [ $? -ne 0 ];then
  cat ./cron_run.log
  echo 'LAST RUN: Failed' >> ./cron_run.log
else
  echo 'LAST RUN: OK' >> ./cron_run.log
fi

cat ./cron_run.log >> /var/log/serverspec.log
rm -f ./cron_run.log
