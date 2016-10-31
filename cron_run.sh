#!/bin/bash

FQDN=$1
shift
source /etc/profile
TEMP='./serverspec_tmp.log'

serverspec "check:server:$FQDN $*" &> $TEMP
EXIT_CODE=$?
RESULT="$(grep -Pe "\d+ examples?, \d+ failures?, \d+ pending" $TEMP)"
if [ -z "$RESULT" ]; then
	RESULT="Result is null"
fi

if [ $EXIT_CODE -ne 0 ];then
  echo "$(date +%s) - LAST RUN: Failed - $RESULT" >> $TEMP
else
  echo "$(date +%s) - LAST RUN: OK - $RESULT" >> $TEMP
fi

cat $TEMP >> /var/log/serverspec.log
rm -f $TEMP

