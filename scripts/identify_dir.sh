#!/bin/bash
DEVICE=
STREAMID=
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
     NSID=1
fi

### get directive parameters for all supported directives
CMDLINE="sudo nvme dir-receive ${DEVICE} --dir-type 0 --dir-oper 1 --human-readable --namespace-id ${NSID}"
echo $CMDLINE
exec $CMDLINE

