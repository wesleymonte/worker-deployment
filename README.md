# Deploying a node worker to Arrebol Service

## Base Requeriments

* Access VM with SSH using private key.
* Installed ansible on host.

## Configuration

The config file is `hosts.conf`. Define on it your node address and the ssh access key.

### Example
```
# Required (pattern:deployed_worker_ip{anything})
deployed_worker_ip=10.30.1.36

# Required
remote_user=ubuntu

# Required (if not specified, ansible will use the host ssh keys)
ansible_ssh_private_key_file=/home/admin/.ssh/node_priv

# Standard
ansible_files_path=./ansible-playbook
```

## Install

After the configuration, execute the `install.sh` script to setup node.

  ```
  sudo bash install.sh
  ```

If was success, you view something like this:

```
10.30.1.36            : ok=4    changed=3    unreachable=0    failed=0   
```