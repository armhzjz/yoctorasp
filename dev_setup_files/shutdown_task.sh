#!/bin/bash

set -e

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd)"
FILENAME=$(basename "$0")
THISFILE="${SCRIPT_DIR}/${FILENAME}"
INTERFACE_NAME=@@INTERFACE_NAME@@

# stop services
# stop the tftpd service
systemctl stop tftpd.service
# stop the nfs server service
systemctl stop nfs-server.service
# stop dnsmasq service
systemctl stop dnsmasq.service

# remove files created for development purposes
[ -f /etc/conf.d/tftpd ] && rm /etc/conf.d/tftpd
[ -f /etc/exports ] && rm /etc/exports
[ -f /etc/dnsmasq.conf ] && rm /etc/dnsmasq.conf

# remove softlinks to nfs and tftp servers created by the development scripts
rm -fr /tftpserver
rm -fr /fsrootfs

# remove rules from iptables
iptables -D INPUT -i ${INTERFACE_NAME} -s 192.168.180.1/24 -j ACCEPT
iptables -D INPUT -i ${INTERFACE_NAME} -s 192.168.180.1/24 -p udp --dport 69 -m state --state NEW,ESTABLISHED -j ACCEPT
iptables -D OUTPUT -s 192.168.180.1/24 -p udp --sport 69 -m state --state ESTABLISHED -j ACCEPT
# delete ip adress from ethernet - usb interface
ip address del 192.168.180.33/24 dev ${INTERFACE_NAME}

# change this file's permissions to 766 so tha it can be deleted when powering
# off
chmod +wr ${THISFILE}

echo $((81))
