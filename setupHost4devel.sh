#!/bin/bash

# insert temporas input and output rules in iptables
# to enable my device access tftp and nfs servers in the host
iptables -A INPUT -s 192.168.180.40 -j ACCEPT
iptables -A OUTPUT -d 192.168.180.40 -j ACCEPT

# make sure  the xinetd service is stopped
 bash /etc/rc.d/rc.xinetd stop
# start (restart) the xinetd service
 bash /etc/rc.d/rc.xinetd start
