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

### disable directive type 1 (Streams)
CMDLINE="sudo nvme dir-send ${1} --dir-type 0 --dir-oper 1 --target-dir 1 --endir 0"
echo $CMDLINE
exec $CMDLINE

