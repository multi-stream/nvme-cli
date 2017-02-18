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

BSIZE=`echo "${DSIZE}/512-1"|bc`

CMDLINE="sudo nvme write ${DEVICE} --start-block=0x200 --block-count=${BSIZE} --data-size=${DSIZE} --data /dev/urandom \
 --dir-type 1 --dir-spec ${STRID}"
echo $CMDLINE
exec $CMDLINE
