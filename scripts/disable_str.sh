#!/bin/bash
DEVICE=
NSID=
usage() { echo "Usage: $0 [-d <device>] [-n <ns_id>]" 1>&2; exit 1; }

while getopts ":d:n:" opt; do
  case $opt in
    d)
      DEVICE=${OPTARG}
      ;;
    n)
      NSID=${OPTARG}
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

if [ -z "$NSID" ]; then
     NSID=0xffffffff
fi

### disable directive type 1 (Streams)
CMDLINE="sudo nvme dir-send ${DEVICE} --dir-type 0 --dir-oper 1 --target-dir 1 --endir 0 --namespace-id ${NSID}"
echo $CMDLINE
exec $CMDLINE

