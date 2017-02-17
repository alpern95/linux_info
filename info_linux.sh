#!/bin/sh
#if type /opt/BSMHW_NG/bin/bsmsensor.sh > /dev/null 2>&1 ; then
echo "============="
echo "Etat Versions"
echo "============="
echo "Redhat Release : "
cat /etc/redhat-release
echo "/proc/version : "
cat /proc/version
uname -a
echo "============"
echo "Etat Network"
echo "============"
hostname -s
domainname -s

if type ifconfig > /dev/null 2>&1 ;
then
  ifconfig eth0
  ifconfig eth1
fi
if type /usr/sbin/ip > /dev/null 2>&1 ;
then
  echo "==== ip link "
  ip l
  echo "==== ip address"
  ip -4 address show
  echo "==== ip route"
  ip r
fi

echo "============"
echo "reverse path   "
echo "============"
sysctl -a | grep \\.rp_filter
echo "============"
echo "SE Linus et Iptable"
echo "============"
sestatus
/etc/init.d/iptables status
echo "============"
echo "Etat Volumes"
echo "============"
df -h
mount
echo "========="
echo "Etat Boot"
echo "========="
dmesg | grep -q "EFI v"    # -q tell grep to output nothing
if [ $? -eq 0 ]      # check exit code; if 0 EFI, else BIOS
then
    echo "You are using EFI boot."
  else
    echo "You are using BIOS boot"
fi