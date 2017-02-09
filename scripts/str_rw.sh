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

DSIZE=`echo "4 * 1024" | bc`
BSIZE=`echo "${DSIZE} / 512 - 1" | bc`

sudo rm -rf ./sendfile.bin && sudo dd if=/dev/urandom of=./sendfile.bin bs=4k count=1 oflag=direct
sudo dd if=/dev/zero of=${1} bs=4k count=1 oflag=direct skip=512
echo "Stream write ..."
CMDLINE="sudo nvme write ${1} --start-block=0x200 --block-count=${BSIZE} --data-size=${DSIZE} \
 --data ./sendfile.bin --dir-type 1 --dir-spec ${2}"
echo $CMDLINE
$CMDLINE
CMDLINE="sudo nvme compare ${1} --start-block=0x200 --block-count=${BSIZE} --data-size=${DSIZE} --data ./sendfile.bin"
echo $CMDLINE
$CMDLINE

sudo rm -rf ./sendfile.bin && sudo dd if=/dev/urandom of=./sendfile.bin bs=4k count=1 oflag=direct
sudo dd if=/dev/zero of=${1} bs=4k count=1 oflag=direct skip=512
echo "Regular write ..."
CMDLINE="sudo nvme write ${1} --start-block=0x200 --block-count=${BSIZE} --data-size=${DSIZE} --data ./sendfile.bin" 
echo $CMDLINE
$CMDLINE
CMDLINE="sudo nvme compare ${1} --start-block=0x200 --block-count=${BSIZE} --data-size=${DSIZE} --data ./sendfile.bin"
echo $CMDLINE
$CMDLINE

sudo rm -rf ./sendfile.bin

