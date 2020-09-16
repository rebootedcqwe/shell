#!/bin/bash
A()
{
if [ `whoami` != "root" ];then
 echo "root is no"
 exit 0
else
 echo "root is ok"
fi
b=`cat /etc/redhat-release |awk 'NR==1' |  awk -F '[ ]+' '{print $4}'| cut -d . -f 1`
if [ $b != "7" ];then
 echo "centos7.X is no"
 exit 0
else
 echo "centos7.X ok"
fi
}
B()
{
read -p "Please input your hostname: " name
hostnamectl --static set-hostname $name
systemctl stop firewalld.service
systemctl disable firewalld.service
sed  -i  '7  s/enforcing/disabled/g'  /etc/selinux/config
setenforce 0
}


C()
{
free -h | awk 'NR==2' | awk '{print $2}' > 1.txt
awk '{print int($1+0.5)}' 1.txt > 2.txt
sed -i 's/$/&G/' 2.txt
aq=`cat 2.txt`      
cat << EOF >> /etc/fstab 
tmpfs                    /dev/shm               tmpfs        defaults,size=$aq        0 0
EOF

awk ' !x[$0]++' /etc/fstab > /etc/fstab.bak
\cp /etc/fstab.bak /etc/fstab

mount -o remount /dev/shm
as=`df -h /dev/shm/ | awk 'NR==2' | awk '{print $2}' |cut -d. -f 1`
ax=`cat 2.txt | cut -d G  -f 1`
if [ $ax != $as ];then
 echo " no"
 exit 0
else
 echo "ok"
fi
}

D()
{
groupadd oinstall
groupadd dba
useradd -g oinstall -G dba oracle 
read -s -p "Please input your password: " mypwd
echo "$mypwd" | passwd --stdin oracle
sleep 0.1
}

E()
{
aa=`cat /proc/meminfo | grep MemTotal |awk -F '[:]+' '{print $2}'|cut -d " "  -f 9`
echo "scale=0;$aa*1024*0.9"|bc > 3.txt
awk '{print int($1+0.5)}' 3.txt > 4.txt
bb=`cat 4.txt`
echo "scale=0;$bb/4096"|bc > 5.txt
cc=`cat 5.txt`
echo $bb $cc
cat > /etc/sysctl.d/97-oracledatabase-sysctl.conf  <<EOF
fs.aio-max-nr = 1048576
fs.file-max = 6815744
kernel.shmall = xv         
kernel.shmmax = xx
kernel.shmmni = 4096
kernel.sem = 250 32000 100 128 
net.ipv4.ip_local_port_range = 9000 65500 
net.core.rmem_default = 262144 
net.core.rmem_max = 4194304 
net.core.wmem_default = 262144 
net.core.wmem_max = 1048576
EOF
sed -i "s#xx#$bb#g" /etc/sysctl.d/97-oracledatabase-sysctl.conf
sed -i "s#xv#$cc#g" /etc/sysctl.d/97-oracledatabase-sysctl.conf
sysctl --system
sysctl -a|grep shmmax 
sysctl -a|grep shmall

cat << EOF >> /etc/security/limits.conf
oracle soft nproc 2047
oracle hard nproc 16384
oracle soft nofile 1024
oracle hard nofile 65536
oracle soft stack 3145728
oracle hard stack 3145728
EOF
awk ' !x[$0]++' /etc/security/limits.conf > /etc/security/limits.conf.bak
\cp /etc/security/limits.conf.bak  /etc/security/limits.conf
}
F()
{
mkdir -p /u01/app/oracle/product/12.2.0.1/db_1 
chown -R oracle:oinstall /u01
chmod -R 775 /u01
}
G()
{
ip a |  awk 'NR==9' |  awk -F '[: ]+' '{print $3}'|cut -d/ -f 1 > 6.txt
hostname > 7.txt
paste 6.txt 7.txt  >> /etc/hosts
awk ' !x[$0]++' /etc/hosts  > /etc/hosts.bak
\cp /etc/hosts.bak  /etc/hosts
}
H()
{
sed -i  's/quiet/& transparent_hugepage=never/' /etc/default/grub 
awk ' !x[$0]++' /etc/default/grub  > /etc/default/grub.bak
\cp /etc/default/grub.bak  /etc/default/grub
grub2-mkconfig -o /boot/grub2/grub.cfg
}
I()
{
  yum install -y compat-libcap*  ksh    libaio-devel*   xdpyinfo
}
A
B
C
D
E
F
G
H
I
rm -f *.txt
