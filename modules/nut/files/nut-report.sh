#!/bin/bash

set -e
set -u

grep -e upsmon /var/log/sysmgt/all | \
	grep -ve 'Poll UPS .* failed - Driver not connected'
