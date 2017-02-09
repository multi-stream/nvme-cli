#!/bin/bash
if [ $# -lt 2 ]; then
   tput bold
   echo "***************************************************"
   echo "FAILED to perform the requested operation.........."
   echo "***************************************************"
   tput sgr0
   echo "Usage $0 <dev_handle> <stream_count>"
   exit 1
fi

# allocate stream resource
CMDLINE="sudo nvme dir-receive ${1} --dir-type 1 --dir-oper 3 --req-resource ${2} --human-readable"
echo $CMDLINE
exec $CMDLINE

