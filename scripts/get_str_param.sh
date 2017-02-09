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

### get streams directive parameters 
CMDLINE="sudo nvme dir-receive ${1} --dir-type 1 --dir-oper 1 --human-readable"
echo $CMDLINE
exec $CMDLINE

