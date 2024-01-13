## Multi-vm stack, for local setup of vprofile project

'''
VM setup order:                         |
                                        |   User(s)-----> <Nginx.web01> <-------> <Tomcat.app01> 
1. db01: Database server                |                                                |
   - MySQL server (mariaDB SRV)         |                                                |
                                        |                                                |
2. mc01: Database Cache Memory          |                             .------------------:
   - Memcache                           |                             |
                                        |                             |
3. rmq01: Message Broker                |                             |
   - RabbitMq                           |   <Memcache.mc01> <---------:---------> <RabbitMQ.rmq01>
                                        |          |
4. app01: Application server            |          |
   - Tomcat (only java)                 |          |
                                        |          :----------> <MySQL.db01>
5. web01: Web server                    |
   - Nginx                              |
'''

Vagrant.configure("2") do |config|      # object config for vagrant 1.1+ configuration

## Global variables:
# place them here


## DB on centos-stream-9 - implement configurations using object db01: 
    config.vm.define "db01" do |db01|
        
        db01.vm.box = "eurolinux-vagrant/centos-stream-9"   # official box name from https://app.vagrantup.com/eurolinux-vagrant/boxes/centos-stream-9
        db01.vm.hostname = "db01"                           # hostname preset (instead of localhost)
        
        # Set a private static IP 192.168.y.x , where y,x @ [0, 255]. Use a distinct set of x and y,
        # in order to avoid IP conflicts (2 or more devices in the same network with the same IP address).
        db01.vm.network "private_network", ip: "192.168.50.10"  

        # Oracle VirtualBOx (chosen hypervisor) configurations
        db01.vm.provider "virtualbox" do |vb|   # select hypervisor - implement configurations using object vb
            vb.memory = "1024"  # if you have less than 8gb run, change it to "600"
        end

        # bash script for provisioning on file mysql.sh. This file should be in the same folder, or
        # you should update the path, starting from here.
        db01.vm.provision "shell", path: "/provisioning/mysql.sh"

    end

## Memcache on centos-stream-9 - implement configurations using object mc01:
    config.vm.define "mc01" do |mc01|

        mc01.vm.box = "eurolinux-vagrant/centos-stream-9"   # official box name from https://app.vagrantup.com/eurolinux-vagrant/boxes/centos-stream-9
        mc01.vm.hostname = "mc01"                           # hostname preset (instead of localhost)

        # Set a private static IP 192.168.y.x , where y,x @ [0, 255]. 
        # Occupied IPs:
        #   (db01) -> 192.168.50.10
        mc01.vm.network "private_network", ip: "192.168.50.11"

        # Oracle VirtualBOx (chosen hypervisor) configurations
        db01.vm.provider "virtualbox" do |vb|   # select hypervisor - implement configurations using object vb
            vb.memory = "1024"  # if you have less than 8gb run, change it to "600"
        end

        # Memcache provisioning bash script is placed in "provisioning" folder, at mysql.sh.
        # Type the full file path, starting from current folder.
        mc01.vm.provision "shell", path: "/provisioning/memcache.sh"

    end

end