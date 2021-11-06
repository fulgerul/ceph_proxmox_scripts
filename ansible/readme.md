# Proxmox Host Initial Configurations

This simple Ansible playbook configures a few basic things on your Proxmox host.

This playbook will:

- Delete Proxmox Enterprise repo and add the community one
- Configure NTP
- Update APT cache, install ifupdown2 and upgrade all packages
- Enable nested virtualization
- Reboot if required

## Prerequisites

- Internal DNS and DHCP
- Proxmox VE 6.x host
- Linux control host - to run Ansible and SSH connection to Proxmox
- SSH with key pair authentication to Proxmox host - [Generate SSH key pair](#generate-ssh-key-pair)
- Ansible - i.e. `sudo apt install ansible`

## Getting Started

### Make sure all prerequisites are met or configured correctly

- Clone or download this repository
  - `git clone git@gitlab.com:itnoobs-automation/ansible/proxmox-host-setup.git`
  - `wget https://gitlab.com/itnoobs-automation/ansible/proxmox-host-setup/-/archive/master/proxmox-host-setup-master.zip`
- Change directory, `cd proxmox-host-setup`
- Change values in **inventory.yml** to match your environment
- Run `ansible-playbook -i inventory.yml host_init.yml`

## Generate SSH key pair

- Generate key pair `ssh-keygen`
- Add public key to the remote host `ssh-copy-id -i ~/.ssh/id_rsa.pub <username>@<hostname>`
- Add private key to SSH session ```eval `ssh-agent` && ssh-add -i ~/.ssh/id_rsa```
- Log in without password authentication `ssh <username>@<hostname>`

## Misc

- [Ansible playbook](https://gitlab.com/itnoobs-automation/ansible/proxmox-template) to create VM template on Proxmox
- [Ansible playbook](https://gitlab.com/itnoobs-automation/ansible/proxmox-vm) to create multiple VMs with hostname verification to avoid conflicts
- [Ansible playbook](https://gitlab.com/itnoobs-automation/ansible/proxmox-vm-init) to configure basic settings on new VMs
