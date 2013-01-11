#!/bin/bash

set -e
set -u

MAILTO=${1:-"root@localhost"}
FILE=${2:-"/var/log/sysmgt/all"}

# create delete-on-exit temporary file
TMPFILE=`mktemp`
trap 'rm -f $TMPFILE' 0 1 2 15

# gather data
grep -e upsmon $FILE | \
	grep -ve 'Poll UPS .* failed - Driver not connected' >$TMPFILE 2>&1

# report results, if necessary
test -s $TMPFILE || exit 0
if [ -n "$MAILTO" ]; then
	mail -s 'Weekly UPS report' $MAILTO < $TMPFILE
else
	cat $TMPFILE
fi
