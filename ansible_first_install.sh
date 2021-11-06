# Create a pair of ansible ssh keys
sudo ssh-keygen -t rsa -b 4096 -f ansible_ssh_key
ssh-copy-id $user@$node-1-ip

# Install ansible
sudo apt-get install ansible
