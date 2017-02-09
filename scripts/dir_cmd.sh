#!/bin/bash
### enable directive type 1 (Streams)
CMDLINE="sudo nvme dir-send /dev/nvme0n1 --dir-type 0 --dir-oper 1 --target-dir 1 --endir 1"
echo $CMDLINE
exec $CMDLINE

### read directive type 0 (Identify)
CMDLINE="sudo nvme dir-receive /dev/nvme0n1 --dir-type 0 --dir-oper 1"
echo $CMDLINE
exec $CMDLINE

### disable directive type 1 (Streams)
CMDLINE="sudo nvme dir-send /dev/nvme0n1 --dir-type 0 --dir-oper 1 --target-dir 1 --endir 0"
echo $CMDLINE
exec $CMDLINE

### read directive type 0 (Identify)
CMDLINE="sudo nvme dir-receive /dev/nvme0n1 --dir-type 0 --dir-oper 1"
echo $CMDLINE
exec $CMDLINE

### read directive type 0 (Identify)
CMDLINE="sudo nvme dir-receive /dev/nvme0n1 --dir-type 0 --dir-oper 1"
echo $CMDLINE
exec $CMDLINE
