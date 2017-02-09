#!/bin/bash
if [ $# -lt 2 ]; then
   tput bold
   echo "***************************************************"
   echo "FAILED to perform the requested operation.........."
   echo "***************************************************"
   tput sgr0
   echo "Usage $0 <dev_handle> <stream_id>"
   exit 1
fi

### enable directive type 1 (Streams)
CMDLINE="sudo nvme dir-send ${1} --dir-type 1 --dir-oper 1 --dir-spec ${2}"
echo $CMDLINE
exec $CMDLINE

