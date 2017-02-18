#!/bin/bash
DEVICE=
STRID=
DSIZE=
usage() { echo "Usage: $0 [-d <device>] [-i <str_id>] [-s <data_size>]" 1>&2; exit 1; }

while getopts ":d:i:s:" opt; do
  case $opt in
    d)
      DEVICE=${OPTARG}
      ;;
    i)
      STRID=${OPTARG}
      ;;
    s)
      DSIZE=${OPTARG}
      ;;
    *)
      usage
      exit 1
      ;;
  esac
done

if [ -z "$DEVICE" ]; then
     DEVICE=/dev/nvme0n1
fi

if [ -z "$STRID" ]; then
     STRID=1
fi

if [ -z "$DSIZE" ]; then
     DSIZE=4096
fi

BSIZE=`echo "${DSIZE} / 512 - 1" | bc`

sudo rm -rf ./sendfile.bin && sudo dd if=/dev/urandom of=./sendfile.bin bs=4k count=1 oflag=direct
sudo dd if=/dev/zero of=${DEVICE} bs=4k count=1 oflag=direct skip=512
echo "Stream write ..."
CMDLINE="sudo nvme write ${DEVICE} --start-block=0x200 --block-count=${BSIZE} --data-size=${DSIZE} \
 --data ./sendfile.bin --dir-type 1 --dir-spec ${STRID}"
echo $CMDLINE
$CMDLINE
CMDLINE="sudo nvme compare ${DEVICE} --start-block=0x200 --block-count=${BSIZE} --data-size=${DSIZE} --data ./sendfile.bin"
echo $CMDLINE
$CMDLINE

sudo rm -rf ./sendfile.bin && sudo dd if=/dev/urandom of=./sendfile.bin bs=4k count=1 oflag=direct
sudo dd if=/dev/zero of=${DEVICE} bs=4k count=1 oflag=direct skip=512
echo "Regular write ..."
CMDLINE="sudo nvme write ${DEVICE} --start-block=0x200 --block-count=${BSIZE} --data-size=${DSIZE} --data ./sendfile.bin" 
echo $CMDLINE
$CMDLINE
CMDLINE="sudo nvme compare ${DEVICE} --start-block=0x200 --block-count=${BSIZE} --data-size=${DSIZE} --data ./sendfile.bin"
echo $CMDLINE
$CMDLINE

sudo rm -rf ./sendfile.bin

