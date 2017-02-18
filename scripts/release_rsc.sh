#!/bin/bash
DEVICE=
usage() { echo "Usage: $0 [-d <device>]" 1>&2; exit 1; }

while getopts ":d:" opt; do
  case $opt in
    d)
      DEVICE=${OPTARG}
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

### release all allocated streams resource(s)
CMDLINE="sudo nvme dir-send ${DEVICE} --dir-type 1 --dir-oper 2"
echo $CMDLINE
exec $CMDLINE

