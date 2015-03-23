#!/bin/bash

grep '^LAST RUN:' /var/log/serverspec.log | tail -1 | grep -q 'OK' &>/dev/null
