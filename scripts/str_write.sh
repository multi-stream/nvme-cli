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

DSIZE=4096
BSIZE=`echo "${DSIZE}/512-1"|bc`

CMDLINE="sudo nvme write ${1} --start-block=0x200 --block-count=${BSIZE} --data-size=${DSIZE} --data /dev/urandom \
 --dir-type 1 --dir-spec ${2}"
echo $CMDLINE
exec $CMDLINE
