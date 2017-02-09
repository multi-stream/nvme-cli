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

### release all allocated streams resource(s)
CMDLINE="sudo nvme dir-send ${1} --dir-type 1 --dir-oper 2"
echo $CMDLINE
exec $CMDLINE

