#!/bin/bash

set -e

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd)"
FILENAME=$(basename "$0")
THISFILE="${SCRIPT_DIR}/${FILENAME}"

# stop development services
bash /etc/rc.d/rc.xinetd stop
bash /etc/rc.d/rc.nfsd stop
bash /etc/rc.d/rc.rpc stop
bash /etc/rc.d/rc.dnsmasq stop

# remove files created for development purposes
[ -f /etc/xinetd.conf ] && rm /etc/xinetd.conf
[ -f /etc/exports ] && rm /etc/exports
[ -f /etc/dnsmasq.conf ] && rm /etc/dnsmasq.conf

# remove softlinks to nfs and tftp servers created by the development scripts
rm -fr /tftpserver
rm -fr /fsrootfs

# change this file's permissions to 766 so tha it can be deleted when powering
# off
chmod +wr ${THISFILE}
