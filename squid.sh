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

# ACLs all, manager, localhost, and to_localhost are predefined.
# Recommended minimum configuration:
# Example rule allowing access from your local networks.
# Adapt to list your (internal) IP networks from where browsing
# should be allowed
acl localnet src 10.0.0.0/8	# RFC1918 possible internal network
acl localnet src 172.16.0.0/12	# RFC1918 possible internal network
acl localnet src 192.168.0.0/16	# RFC1918 possible internal network
#acl localnet src fc00::/7       # RFC 4193 local private network range
#acl localnet src fe80::/10      # RFC 4291 link-local (directly plugged) machines

acl SSL_ports port 443 2222
acl Safe_ports port 80		# http
acl Safe_ports port 21		# ftp
acl Safe_ports port 443		# https
acl Safe_ports port 70		# gopher
acl Safe_ports port 210		# wais
acl Safe_ports port 1025-65535	# unregistered ports
acl Safe_ports port 280		# http-mgmt
acl Safe_ports port 488		# gss-http
acl Safe_ports port 591		# filemaker
acl Safe_ports port 777		# multiling http
acl safe_ports port 2222	# eset agent
acl safe_ports port 2221	# eset
acl safe_ports port 2223	# eset web
acl safe_ports port 8080	# eset webconsole
acl CONNECT method CONNECT
cache_peer 10.1.12.41 parent 3128 0 no-query
prefer_direct off
never_direct allow all

# Deny requests to certain unsafe ports
http_access deny !Safe_ports

# Deny CONNECT to other than secure SSL ports
http_access deny CONNECT !SSL_ports

# Only allow cachemgr access from localhost
http_access allow localhost manager
http_access deny manager

#detection Update
acl allowed dstdomain um01.eset.com um02.eset.com um03.eset.com um04.eset.com um05.eset.com um06.eset.com um07.eset.com um08.eset.com um09.eset.com um10.eset.com um11.eset.com um12.eset.com um13.eset.com um21.eset.com um23.eset.com um01.$
#pico update
acl allowed dstdomain pico.eset.com www.eset.com
#product installers updates
acl allowed dstdomain download.eset.com
#expire date
acl allowed dstdomain expire.eset.com edf.eset.com
#support request
acl allowed dstdomain suppreq.eset.eu
#allow communication with ESET Secure Authentication
acl allowed dstdomain ecp.eset.systems esa.eset.com m.esa.eset.com repository.eset.com
#ESET Live Grid
acl allowed dstdomain a.cwip.eset.com ae.cwip.eset.com c.cwip.eset.com ce.cwip.eset.com dnsj.e5.sk dnsje.e5.sk i1.cwip.eset.com i1e.cwip.eset.com i3.cwip.eset.com i4.cwip.eset.com i4e.cwip.eset.com u.cwip.eset.com ue.cwip.eset.com c.eset$
#Advanced Machine Learning:
acl allowed dstdomain h1-aidc01.eset.com h3-aidc01.eset.com h5-aidc01.eset.com
#To submit suspicious files and anonymous statistical information to ESET’s Threat Lab:
acl allowed dstdomain tsm09.eset.com tsm10.eset.com tsm11.eset.com tsm12.eset.com tsm13.eset.com tsm14.eset.com tsm15.eset.com tsm16.eset.com ts.eset.com
#To use the Parental Control module (ESET Smart Security only):
acl allowed dstdomain h1-arsp01-v.eset.com h1-arsp02-v.eset.com h3-arsp01-v.eset.com h3-arsp02-v.eset.com h5-arsp01-v.eset.com h5-arsp02-v.eset.com
#To use ESET Password Manager
acl allowed dstdomain ext-pwm.eset.com eset-870273198.eu-west-1.elb.amazonaws.com esetpwmdata-1.s3.amazonaws.com s3-3-w.amazonaws.com
#To use the Antispam module
acl allowed dstdomain h1-ars01-v.eset.com h1-ars02-v.eset.com h1-ars03-v.eset.com h1-ars04-v.eset.com h1-ars05-v.eset.com h3-ars01-v.eset.com h3-ars02-v.eset.com h3-ars03-v.eset.com h3-ars04-v.eset.com h3-ars05-v.eset.com h5-ars01-v.eset$
acl allowed dstdomain ds1-uk-rules-1.mailshell.net ds1-uk-rules-2.mailshell.net ds1-uk-rules-3.mailshell.net fh-uk11.mailshell.net
#To ensure proper functionality of linking and redirection from your ESET product’s graphical user interface:
acl allowed dstdomain go.eset.eu support-go.eset.eu h1-redir02-v.eset.com h3-redir02-v.eset.com
#active mobile security
acl allowed dstdomain reg01.eset.com reg04.eset.com

#ESET Data Framework (Anti-Theft, ESET License Administrator, Parental control, Web control):
acl allowed dstdomain edf.eset.com edfpcs.trafficmanager.net bal-edf-pcs-app-vmss-01.westus.cloudapp.azure.com bal-edf-pcs-app-vmss-02.westus.cloudapp.azure.com h1-edfspy02-v.eset.com h1-edfspy02-v.eset.com h1-arse01-v.eset.com h1-arse02$
#ERA/ESMC Repository – repository.eset.com (ESET Remote Administrator 6.x and ESET Security Management Center 7):
acl allowed dstdomain repository.eset.com
#push notification
acl allowed dstdomain epns.eset.com h1-epns01-v.eset.com h1-epns02-v.eset.com h3-epns01-v.eset.com h3-epns02-v.eset.com h5-epns01.eset.com h5-epns02.eset.com h1-epnsbroker01.eset.com h1-epnsbroker02.eset.com h3-epnsbroker01.eset.com h3-e$
#EDTD
acl allowed dstdomain r.edtd.eset.com d.edtd.eset.com
#Services (activation, expiration, IP location, trace, versioncheck, redirector, in-product images & messages, SSL certificate check):
acl allowed dstdomain proxy.eset.com h1-weblb01-v.eset.com h3-weblb01-v.eset.com edf.eset.com edfpcs.trafficmanager.net bal-edf-pcs-app-vmss-01.westus.cloudapp.azure.com bal-edf-pcs-app-vmss-02.westus.cloudapp.azure.com register.eset.com$
#Online help and Knowledgebase:
acl allowed dstdomain help.eset.com support.eset.com int.form.eset.com
#ESET MSP
acl allowed dstdomain ftp.eset.sk mspapi.esetsoftware.com go.eset.com
#DNS load balancers
acl allowed dstdomain h1-f5lb01-s.eset.com h3-f5lb01-s.eset.com h5-f5lb01-s.eset.com
#telementery
acl allowed dstdomain gallup.eset.com
# And finally deny all other access to this proxy
http_access allow allowed
http_access deny all
http_port 3128
# Uncomment and adjust the following to add a disk cache directory.
cache_dir ufs /var/spool/squid 5000 16 256 max-size=200000000

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

# ——————- End Konfigurasi Squid ———————–
EOF
systemctl enable squid && systemctl restart squid
