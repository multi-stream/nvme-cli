#!/bin/bash
DEVICE=
STREAMID=
NSID=
usage() { echo "Usage: $0 [-d <device>] [-i <stream_id>] [-n <ns_id>]" 1>&2; exit 1; }

while getopts ":d:i:n:" opt; do
  case $opt in
    d)
      DEVICE=${OPTARG}
      ;;
    i)
      STREAMID=${OPTARG}
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

if [ -z "$STREAMID" ]; then
     STREAMID=1
fi

if [ -z "$NSID" ]; then
     NSID=1
fi

### enable directive type 1 (Streams)
CMDLINE="sudo nvme dir-send ${DEVICE} --dir-type 1 --dir-oper 1 --dir-spec ${STREAMID} --namespace-id ${NSID}"
echo $CMDLINE
exec $CMDLINE

