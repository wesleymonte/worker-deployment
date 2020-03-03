# Worker Node deployment

Arrebol tasks are processed by Workers. In a typical deployment, a few Workers are deployed together in a single virtual machine, a Worker Node. As each task run in a isolated docker container, the Docker engine and other dependencies must have be installed and configured into the Worker Node. Below, we described how to configure the Worker Node.

## Requeriments

Before the configuration and installation of Worker Node dependencies, each Worker Node virtual machine should be configured to be reached via SSH (using a rsa key pair). Also, the [Ansible automation tool](https://www.ansible.com/) should be installed in the deploy coordination host.
Warning: Deployment does not work for nodes with Ubuntu version 14 or earlier.

## Configuration

The `hosts.conf` configuration file should be edited to declare the Worker Node. See below how to edit it.

### Example
```
# Required
deployed_worker_ip=10.30.1.36

# Required
remote_user=ubuntu

# Required (if not specified, ansible will use the host ssh keys)
ansible_ssh_private_key_file=/home/admin/.ssh/node_priv

# Default
ansible_files_path=./ansible-playbook
```

## Install

After configuring the `hosts.conf` file, execute the `install.sh` script to setup the Worker Node.

  ```
  sudo bash install.sh
  ```
