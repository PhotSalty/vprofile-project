## Multi-vm stack, for local setup of vprofile project

Vagrant.configure("2") do |config|      # object config for vagrant 1.1+ configuration

## Global variables:
# place them here


# VM setup order:

# 1. db01: Database server
#    - mysql (mariaDB server)

# 2. mc01: Database Cache Memory
#    - Memcache

# 3. rmq01: Message Broker
#    - RabbitMq

# 4. app01: Application server
#    - Tomcat (only java)

# 5. web01: Web server
#    - Nginx


## DB on centos-stream-9 as "db01" object:
    config.vm.define "db01" do |db01|
        
        db01.vm.box = "eurolinux-vagrant/centos-stream-9"   # official name
        db01.vm.hostname = "db01"                           # hostname preset (instead of local host)
        
        # Set static IP with 192.168.yy.xx, where it is'nt used on ane existing vm
        db01.vm.network "private_network", ip: "192.168.56.10"  
        db01.vm.provider "virtualbox" do |vb|   # oracle virtualbox as hypervisor
            vb.memory = "1024"  # if you have less than 8gb run, change it to "600"
        end
        db01.vm.provision "shell", path: "mysql.sh" # bash script for provisioning

    end