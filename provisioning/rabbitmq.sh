#!/bin/bash

<<description

Bash script for DB service setup provisioning.  With #!/bin/bash (1st line) 
we provide the absolute path of the selected interprenter, in order to 
execute the script using "bash".

description

# Install basic and extra packages and wget
sudo yum update -y
sudo yum install epel-release -y
sudo yum install wget -y

# Install RabbitMQ repository in temporary directory, which clears temporary files after a session.
# We don't need installation files after service installation
cd /tmp/
sudo dnf -y install centos-release-rabbitmq-38

# Install RabbitMQ server, enable the "start on boot", start it immediately and check it's status
sudo dnf --enablerepo=centos-rabbitmq-38 -y install rabbitmq-server
sudo systemctl enable --now rabbitmq-server
sudo systemctl status rabbitmq-server

# Run a shell command, in order to create a RabbitMQ configuration file, allowing connection
# for all users, including the loopback users (localhost) 
sudo sh -c 'echo "[{rabbit, [{loopback_users, []}]}]." > /etc/rabbitmq/rabbitmq.config'

# Add a test user (tstuser with password R4ndP4ss) to RabbitMQ-server and set a password. You can
# replace username and password with your choices. Grant this user administrative privileges.
sudo rabbitmqctl add_user tstuser R4ndP4ss
sudo rabbitmqctl set_user_tags tstuser administrator

# Restart the service, in order to apply changes
sudo systemctl restart rabbitmq-server