#!/bin/bash

if [ -z "$1" ]; then
    echo "Name of KAS project (i.e. kas-project.yml) file must be passed as argument"
    exit 1
elif [ -z "$2" ]; then
    echo "Ethernet interface for tftp/nfs server is not specified"
    exit 1
fi

KAS_PROJECT=$1
ETHERNET_INTERFACE=$2
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd)"
PROJ_DIR=${SCRIPT_DIR}/..
DISTRO=$(grep "distro:" ${SCRIPT_DIR}/${KAS_PROJECT})
IMAGE=$(grep "machine:" ${SCRIPT_DIR}/${KAS_PROJECT})
TARGET=$(grep " - " ${SCRIPT_DIR}/${KAS_PROJECT})

# if distro is not explicitly set in the kas file, then 
# the distro resorts to "poky"
if [[ -z "${DISTRO}" ]]; then
    DISTRO=poky
fi
# if IMAGE and TARGET are not explicitly set ....
if [[ -z "${IMAGE}" || -z "${TARGET}" ]]; then
    echo "No Image or Target or Distro detected."
    echo "Cannot continue."
    echo "Exiting."
    exit 1
else
    echo "Seting up for:"
    echo "  Image: ${IMAGE##*\ }"
    echo "  Distro: ${DISTRO##*-}"
    echo "  Target: ${TARGET##*\ }"
fi

# check if the build is ready for this setup to be set
if [ ! -d "${PROJ_DIR}/build/tmp/deploy/images/${IMAGE##*\ }" ]; then
    echo "Image must be built first. Cannot continue."
    echo "Exiting."
    exit 1
elif [ ! -d "${PROJ_DIR}/build/tmp/work/$(sed 's/-/_/g' <<< ${IMAGE##*\ })-${DISTRO##*-}-linux/${TARGET##*\ }/1.0-r0/rootfs" ]; then
    echo "Image must be built first. rootfs folder not found."
    echo "Cannot continue."
    echo "Exiting."
    exit 1
fi


# assign ip address to ${ETHERNET_INTERFACE} interface
ip address add 192.168.180.33/24 dev ${ETHERNET_INTERFACE}
# insert temporal input and output rules in iptables
# to enable my device access tftp and nfs servers in the host
iptables -A INPUT -i ${ETHERNET_INTERFACE} -s 192.168.180.1/24 -j ACCEPT
iptables -A INPUT -i ${ETHERNET_INTERFACE} -s 192.168.180.1/24 -p udp --dport 69 -m state --state NEW,ESTABLISHED -j ACCEPT
iptables -A OUTPUT -s 192.168.180.1/24 -p udp --sport 69 -m state --state ESTABLISHED -j ACCEPT

# prepare tftpd-hpa configuration file
sed -e 's/TFTPD_ARGS="--secure \/srv\/tftp\/"/TFTPD_ARGS="-4 -s -c -a :69 --verbosity 5 \/tftpserver"/' \
    /etc/conf.d/tftpd.in > /etc/conf.d/tftpd
# prepare thet /tftpserver directory
[[ -L "/tftpserver"  ]] && rm /tftpserver
ln -s ${PROJ_DIR}/build/tmp/deploy/images/${IMAGE##*\ } /tftpserver

# create rootfs directory for nfs export
# (looK at /etc/exports or execute exportfs to see which shares are being
# shared)
if [ -d ${PROJ_DIR}/rootfs ]; then
    rm -fr ${PROJ_DIR}/rootfs
fi
cp -fr "${PROJ_DIR}/build/tmp/work/$(sed 's/-/_/g' <<< ${IMAGE##*\ })-${DISTRO##*-}-linux/${TARGET##*\ }/1.0-r0/rootfs" /fsrootfs
chown -R root:root /fsrootfs

# prepare exports file
sed -e 's/#dev_share_here/\/fsrootfs 192.168.180.0\/24(rw,sync,no_root_squash,no_subtree_check)/' \
    /etc/exports.in > /etc/exports

# prepare dnsmasc.conf file
sed -e 's/#dhcp-range=192.168.180.39,192.168.180.40,12h/dhcp-range=192.168.180.39,192.168.180.40,255.255.255.0,12h/' \
    /etc/dnsmasq.conf.in > /etc/dnsmasq.conf
printf "interface=${ETHERNET_INTERFACE}" >> /etc/dnsmasq.conf

# start the tftpd service
systemctl start tftpd.service
# start the nfs server service
systemctl start nfs-server.service
# start dnsmasq service
systemctl start dnsmasq.service

# provide a shutdown script to runt shutdown and clean up tasks for the
# development setup
if [ ! -d ${HOME}/bin ]; then
    mkdir -p ${HOME}/bin
fi
cp ${SCRIPT_DIR}/shutdown_task.sh /home/eindemwort/binowns/shutdown_task.sh
sed -i "s/@@INTERFACE_NAME@@/${ETHERNET_INTERFACE}/g" /home/eindemwort/binowns/shutdown_task.sh
chmod 100 /home/eindemwort/binowns/shutdown_task.sh
chown 1000:100 /home/eindemwort/binowns/shutdown_task.sh
