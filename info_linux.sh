#!/bin/sh
#if type /opt/BSMHW_NG/bin/bsmsensor.sh > /dev/null 2>&1 ; then
echo "============="
echo "Etat Versions"
echo "============="
echo "Linux Release : "
cat /etc/*{release,version}
echo "/proc/version : "
cat /proc/version
uname -a
echo " "
echo "============="
echo "Etat Network"
echo "============="
echo "==== Hostname :"
hostname -s
echo "==== Domain name :"
domainname -s

if type /usr/sbin/ip > /dev/null 2>&1 ;
then
  echo "==== ip link "
  ip l
  echo "==== ip adress"
  ip -4 address show
  echo "==== ip route "
  ip r
else
  ifconfig
fi
echo " "
echo "=============="
echo "System Product"
echo "=============="
dmidecode -s system-product-name
echo " "
echo "============="
echo "reverse path "
echo "============="
sysctl -a | grep \\.rp_filter
echo " "
echo "============="
echo "SE Linus et Iptable"
echo "============="
sestatus
echo "Firewalld status :"
if [ -e "/etc/init.d/iptables" ]
then
  /etc/init.d/iptables status
else
  systemctl status firewalld | grep Active
fi
echo " "
echo "============="
echo "Etat Memoire"
echo "============="
cat /proc/meminfo | grep Mem
echo " "
echo "=============="
echo "Nomobre de CPU"
echo "=============="
cat /proc/cpuinfo | grep processor | wc -l
echo " "
echo "============="
echo "Etat Volumes"
echo "============="
df -h
mount
echo " "
echo "============="
echo "Etat Boot"
echo "============="
dmesg | grep -q "EFI v"		# -q tells grep to output nothing
if [ $? -eq 0 ] 	#check exit code; if 0 EFI, else BIOS
then
    echo "You are using EFI boot."
  else
    cat /var/log/dmesg.old | grep -q "EFI v"
    if [ $? -eq 0 ]
    then
        echo "You are using EFI boot"
      else
        echo "You are using BIOS boot"
    fi
fi
