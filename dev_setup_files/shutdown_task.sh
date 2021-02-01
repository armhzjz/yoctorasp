#!/bin/bash

set -e

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
rm -fr /rootfs
