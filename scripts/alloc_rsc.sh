#!/bin/bash
DEVICE=
RSC=
usage() { echo "Usage: $0 [-d <device>] [-r <rsc_count>]" 1>&2; exit 1; }

while getopts ":d:r:" opt; do
  case $opt in
    d)
      DEVICE=${OPTARG}
      ;;
    r)
      RSC=${OPTARG}
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

if [ -z "$RSC" ]; then
     RSC=8
fi

# allocate stream resource
CMDLINE="sudo nvme dir-receive ${DEVICE} --dir-type 1 --dir-oper 3 --req-resource ${RSC} --human-readable"
echo $CMDLINE
exec $CMDLINE

