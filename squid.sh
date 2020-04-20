#!/bin/bash

export DEBIAN_FRONTEND=noninteractive
locale-gen --purge en_US.UTF-8
echo -e 'LANG="en_US.UTF-8"\nLANGUAGE="en_US:en"\n' > /etc/default/locale
## Setting Repositories, Update and Upgrade system
sed -i 's/http://id.archive.ubuntu.com/http://buaya.klas.or.id/g' /etc/apt/sources.list
apt -y update
apt -y upgrade
apt install squid

##Config squid
mv /etc/squid/squid.conf /etc/squid/squid.bak
cat <<EOF>> /etc/squid/squid.conf
# _____Squid config for eset_____
acl SSL_ports port 443
acl Safe_ports port 80 # http
acl Safe_ports port 21 # ftp
acl Safe_ports port 443 # https
acl Safe_ports port 70 # gopher
acl Safe_ports port 210 # wais
acl Safe_ports port 1025-65535 # unregistered ports
acl Safe_ports port 280 # http-mgmt
acl Safe_ports port 488 # gss-http
acl Safe_ports port 591 # filemaker
acl Safe_ports port 777 # multiling http
acl Safe_ports port 53
acl CONNECT method CONNECT
# Deny requests to certain unsafe ports
http_access deny !Safe_ports
# Deny CONNECT to other than secure SSL ports
http_access deny CONNECT !SSL_ports
# Only allow cachemgr access from localhost
http_access allow localhost manager
http_access deny manager
#detection Update
acl allowed dstdomain .eset.com .eset.sk .amazonaws.com .mailshell.net .eset.eu .trafficmanager.net .azure.com .esetsoftware.com
http_access allow allowed
http_access deny all
# Squid normally listens to port 3128
http_port 3128
# Uncomment and adjust the following to add a disk cache directory.
cache_dir ufs /var/spool/squid 5000 16 256 max-size=10000000
cache_mem 1000 MB
# Leave coredumps in the first cache dir
coredump_dir /var/spool/squid
# Add any of your own refresh_pattern entries above these.
refresh_pattern ^ftp: 1440 20% 10080
refresh_pattern ^gopher: 1440 0% 1440
refresh_pattern -i (/cgi-bin/|\?) 0 0% 0
refresh_pattern (Release|Packages(.gz)*)$ 0 20% 2880
# example lin deb packages
#refresh_pattern (\.deb|\.udeb)$ 129600 100% 129600
refresh_pattern . 0 20% 4320
# _____End of Squid Config_____
EOF
systemctl enable squid && systemctl restart squid
