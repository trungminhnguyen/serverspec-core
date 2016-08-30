#!/bin/bash

fqdn=`hostname -f`

serverspec "check:server:$fqdn $*" &> ./cron_run.log

echo -n $(date) >> ./cron_run.log

if [ $? -ne 0 ];then
  cat ./cron_run.log
  echo 'LAST RUN: Failed' >> ./cron_run.log
else
  echo 'LAST RUN: OK' >> ./cron_run.log
fi

cat ./cron_run.log >> /var/log/serverspec.log
rm -f ./cron_run.log
