#!/bin/bash -l

cat /root/.bashrc|egrep -v "GOVC" > /tmp/.bashrc
echo "export GOVC_URL='192.168.100.102'"                  >> /tmp/.bashrc
echo "export GOVC_USERNAME='administrator@vsphere.local'" >> /tmp/.bashrc
echo "export GOVC_PASSWORD='W@ster123'"                   >> /tmp/.bashrc
echo "export GOVC_INSECURE=1"                             >> /tmp/.bashrc
mv -f /tmp/.bashrc /root/.bashrc
. /root/.bashrc


conf_timezone()
{
	timedatectl set-timezone America/Sao_Paulo
}

conf_sshkey()
{
	echo " "
	echo "---- ssh key "
	rm -rf /root/.ssh/*
	cat /dev/zero | ssh-keygen -q -N ""

         echo "StrictHostKeyChecking no"       >> /etc/ssh/ssh_config
         echo "UserKnownHostsFile /dev/null"   >> /etc/ssh/ssh_config
         echo "LogLevel QUIET"                 >> /etc/ssh/ssh_config  
  
	sshpass -p "jakarosa" ssh-copy-id -o StrictHostKeyChecking=no root@$host_full
}

conf_yum()
{
	echo " "
	echo "----- yum"
	#    8  subscription-manager register
	#    9  subscription-manager refresh
	#   10  subscription-manager list --available --matches '*OpenShift*'
	#   11  subscription-manager attch --pool=8a85f99b6e12cc13016e3baad78f45f0
	#   12  subscription-manager attach --pool=8a85f99b6e12cc13016e3baad78f45f0
	#   13  subscription-manager repos --disable="*"
	yum -y install atomic-openshift-clients openshift-ansible screen
	yum -y update
	yum install -y wget
	subscription-manager repos --enable="rhel-7-server-rpms"  --enable="rhel-7-server-extras-rpms" --enable="rhel-7-server-ose-3.11-rpms" --enable="rhel-7-server-ansible-2.6-rpms"
	
}

conf_govc()
{
	curl -LO https://github.com/vmware/govmomi/releases/download/v0.15.0/govc_linux_amd64.gz
	gunzip -f govc_linux_amd64.gz
	chmod +x govc_linux_amd64
	mv -f govc_linux_amd64 /usr/bin/govc
	
	#[root@ocp ~]# cat .bashrc
	#
	#export GOVC_URL='192.168.100.102'
	#export GOVC_USERNAME='administrator@vsphere.local'
	#export GOVC_PASSWORD='W@ster123'
	#export GOVC_INSECURE=1
	##
	# $govc vm.change -e="disk.enableUUID=1" -vm='VM Path'
	
	#vm_path_full=$(govc ls -L|grep vm)/$vm_path/$host_full
	#echo $vm_path_full
	#echo "govc vm.change -e=\"disk.enableUUID=1\" -vm='$vm_path_full'"|sh
	#govc ls -L
}

conf_timezone
conf_network
conf_hosts
conf_sshkey
conf_yum
conf_govc




