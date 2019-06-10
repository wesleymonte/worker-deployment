#!/bin/bash

MY_PATH="`dirname \"$0\"`"              
MY_PATH="`( cd \"$MY_PATH\" && pwd )`" 

if [ -z "$MY_PATH" ] ; then
  # For some reason, the path is not accessible
  # to the script (e.g. permissions re-evaled after suid)
  exit 1
fi

HOSTS_CONF_FILE=$MY_PATH"/hosts.conf"

# Playbook path
ANSIBLE_FILES_PATH_PATTERN="ansible_files_path"
ANSIBLE_FILES_PATH=$(grep $ANSIBLE_FILES_PATH_PATTERN $HOSTS_CONF_FILE | awk -F "=" '{print $2}')

ANSIBLE_HOSTS_FILE=$ANSIBLE_FILES_PATH/"hosts"

# Ansible ssh private key file path
PRIVATE_KEY_FILE_PATH_PATTERN="ansible_ssh_private_key_file"
PRIVATE_KEY_FILE_PATH=$(grep $PRIVATE_KEY_FILE_PATH_PATTERN $HOSTS_CONF_FILE | awk -F "=" '{print $2}')

SIZE_PATTERN="size"
SIZE=$(grep $SIZE_PATTERN $HOSTS_CONF_FILE | awk -F "=" '{print $2}')

DEPLOYED_WORKER_IP_PATTERN="deployed_worker_ip"
DEPLOYED_WORKER_IP=$(grep $DEPLOYED_WORKER_IP_PATTERN $HOSTS_CONF_FILE | awk -F "=" '{print $2}')

sed -i 's/\[worker-machine\].*\[worker-machine:vars\]/[worker-machine]\n\n[worker-machine:vars]/' $ANSIBLE_HOSTS_FILE
sed -i "2s/.*/$DEPLOYED_WORKER_IP/" $ANSIBLE_HOSTS_FILE

# Writes the path of the private key file in Ansible hosts file
sed -i "s#.*$PRIVATE_KEY_FILE_PATH_PATTERN=.*#$PRIVATE_KEY_FILE_PATH_PATTERN=$PRIVATE_KEY_FILE_PATH#" $ANSIBLE_HOSTS_FILE

readonly DEPLOY_WORKER_YML_FILE="deploy-worker.yml"

(cd $ANSIBLE_FILES_PATH && ansible-playbook -vvv $DEPLOY_WORKER_YML_FILE)