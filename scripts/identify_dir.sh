#!/bin/bash
if [ $# -lt 1 ]; then
   tput bold
   echo "***************************************************"
   echo "FAILED to perform the requested operation.........."
   echo "***************************************************"
   tput sgr0
   echo "Usage $0 <dev_handle>"
   exit 1
fi

### get directive parameters for all supported directives
CMDLINE="sudo nvme dir-receive ${1} --dir-type 0 --dir-oper 1 --human-readable"
echo $CMDLINE
exec $CMDLINE | more

