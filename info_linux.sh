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
echo "==== Local Domain"
hostname --nis
echo "==== long host name (FQDN)"
hostname -f
echo "==== Show current hostname settings"
if type hostnamectl > /dev/null 2>&1 ;
then
hostnamectl status
fi

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
  systemctl status firewalld | grep 'Loaded\|Active'
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
    echo "You are using EFI boot mode."
  else
    cat /var/log/dmesg.old | grep -q "EFI v"
    if [ $? -eq 0 ]
    then
        echo "You are using EFI boot mode"
      else
        echo "You are not using EFI boot mode"
    fi
fi
echo " "

if type /usr/bin/rpm > /dev/null 2>&1 ;
then
  echo "==== List installed rpm"
  rpm -qa --qf '%{NAME} %{VERSION} %{ARCH} rpm %{SUMMARY}\n' | sort
else
  echo "Cannot collecte rpm, perhaps you are not on centos or redhad."
fi

