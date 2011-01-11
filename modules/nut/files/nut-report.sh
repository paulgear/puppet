#!/bin/bash

set -e
set -u

grep -e upsmon /var/log/messages | \
	grep -ve 'Poll UPS [.*] failed - Driver not connected'
