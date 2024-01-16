#!/bin/bash

<<description

Bash script for cache memory service provisioning. With #!/bin/bash (1st line) 
we provide the absolute path of the selected interprenter, in order to 
execute the script using "bash".

description

# Install extra packages
sudo dnf install epel-release -y

# Install memached service
sudo dnf install memcached -y

# Start, enable and check the status of memcached service
sudo systemctl start memcached
sudo systemctl enable memcached
sudo systemctl status memcached

# Search in the memcached configuration file for the localhost IP (loopback 127.0.0.1)
# and replace it with 0.0.0.0, in order to allow other devices connect to memcached.
# e.g Database queries are saved on cached memory, for instant response on reuse.
sed -i 's/127.0.0.1/0.0.0.0/g' /etc/sysconfig/memcached

# Restart service
sudo systemctl restart memcached