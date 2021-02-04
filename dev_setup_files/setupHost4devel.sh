#!/bin/bash

set -e

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd)"
PROJ_DIR=${SCRIPT_DIR}/..
IMAGE=$(grep "machine:" ${PROJ_DIR}/kas-projSetup.yml)
TARGET=$(grep " - " ${PROJ_DIR}/kas-projSetup.yml)

if [[ -z $IMAGE && -z $TARGET ]]; then
    echo "No Image or Target detected."
    echo "Cannot continue."
    echo "Exiting."
    exit 1
fi

# check if the build is ready for this setup to be set
if [ ! -d "${PROJ_DIR}/build/tmp/deploy/images/${IMAGE##*\ }" ]; then
    echo "Image must be built first. Cannot continue."
    echo "Exiting."
    exit 1
elif [ ! -d "${PROJ_DIR}/build/tmp/work/$(sed 's/-/_/g' <<< ${IMAGE##*\ })-poky-linux/${TARGET##*\ }/1.0-r0/rootfs" ]; then
    echo "Image must be built first. rootfs folder not found."
    echo "Cannot continue."
    echo "Exiting."
    exit 1
fi

# insert temporas input and output rules in iptables
# to enable my device access tftp and nfs servers in the host
iptables -A INPUT -s 192.168.180.1/24 -j ACCEPT
iptables -A OUTPUT -d 192.168.180.1/24 -j ACCEPT

# prepare xinetd.conf file
sed -e 's/#service tftp definition/service tftp\
{\
       socket_type \= dgram\
       protocol \= udp\
       wait \= yes\
       user \= root\
       server \= \/usr\/sbin\/in.tftpd\
       server_args \= -s \/tftpserver\
       disable \= no\
}/' \
    /etc/xinetd.conf.in > /etc/xinetd.conf
# prepare thet /tftpserver directory
ln -s ${PROJ_DIR}/build/tmp/deploy/images/${IMAGE##*\ } /tftpserver

# start the xinetd service
bash /etc/rc.d/rc.xinetd start

# create rootfs directory for nfs export
# (loot at /etc/exports or execute exportfs to see which shares are being
# shared)
if [ -d ${PROJ_DIR}/rootfs ]; then
    rm -fr ${PROJ_DIR}/rootfs
fi
cp -fr "${PROJ_DIR}/build/tmp/work/$(sed 's/-/_/g' <<< ${IMAGE##*\ })-poky-linux/${TARGET##*\ }/1.0-r0/rootfs" ${PROJ_DIR}
ln -s ${PROJ_DIR}/rootfs /fsrootfs
chown -R root:root /fsrootfs

# prepare exports file
sed -e 's/#dev_share_here/\/fsrootfs 192.168.180.0\/24(rw,sync,no_root_squash,no_subtree_check)/' \
    /etc/exports.in > /etc/exports

## restart rpc and nfsd services
bash /etc/rc.d/rc.nfsd start
bash /etc/rc.d/rc.rpc start

# prepare dnsmasc.conf file
sed -e 's/#dhcp-range=192.168.180.39,192.168.180.40,12h/dhcp-range=192.168.180.39,192.168.180.40,255.255.255.0,12h/' \
    /etc/dnsmasq.conf.in > /etc/dnsmasq.conf

# start dnsmasq service
bash /etc/rc.d/rc.dnsmasq start

# provide a shutdown script to runt shutdown and clean up tasks for the
# development setup
if [ ! -d ${HOME}/bin ]; then
    mkdir -p ${HOME}/bin
fi
cp ${SCRIPT_DIR}/shutdown_task.sh /home/eindemwort/bin/shutdown_task.sh
chmod 100 /home/eindemwort/bin/shutdown_task.sh
chown 1000:100 /home/eindemwort/bin/shutdown_task.sh
