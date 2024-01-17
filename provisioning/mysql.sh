#!/bin/bash

<<description

Bash script for DB service setup provisioning.  With #!/bin/bash (1st line) 
we provide the absolute path of the selected interprenter, in order to 
execute the script using "bash".

description


# Setting variable for database password of your choice
DATABAS_PASS='R4ndP4ss'

# Install basic and extra packages, git, (un)zip-handlers and maria-db server
sudo yum update -y
sudo yum install epel-release -y
sudo yum install git zip unzip -y
sudo yum install mariadb-server -y

# Start and enable the db service, through mariadb-server
sudo systemctl start mariadb
sudo systemctl enable mariadb

# Clone main branch of our git repository in the temporary directory
cd /tmp/
git clone -b main https://github.com/PhotSalty/vprofile-project.git

# As administrator, set mysql password for user "root"
sudo mysqladmin -u root password "$DATABASE_PASS"

# Disable remote connections to mysql root and any connection of other Users. 
# Allow only the connection through the loopback IP (localhost) 127.0.0.1
sudo mysql -u root -p"$DATABASE_PASS" -e "DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1')"
sudo mysql -u root -p"$DATABASE_PASS" -e "DELETE FROM mysql.user WHERE User=''"

# Delete all permissions or entries related to databases named 'test', or starting with 'test_' from
# "mysql.db" table. Used in order to clean up all unnecessary entries from Mysql permissions system.
sudo mysql -u root -p"$DATABASE_PASS" -e "DELETE FROM mysql.db WHERE Db='test' OR Db='test\_%'"

# Refresh and create db "accounts"
sudo mysql -u root -p"$DATABASE_PASS" -e "FLUSH PRIVILEGES"
sudo mysql -u root -p"$DATABASE_PASS" -e "create database accounts" # CAPS-ONLY on the keywords (SELECT, DELETE, FLUSH, FROM etc.)

# Grant privileges on user "admin" for the "accounts" database when he connects from
# localhost or any other location/machine (symbol % for every other location)
sudo mysql -u root -p"$DATABASE_PASS" -e "grant all privileges on accounts.* TO 'admin'@'localhost' identified by 'R4andP4ss'"
sudo mysql -u root -p"$DATABASE_PASS" -e "grant all privileges on accounts.* TO 'admin'@'%' identified by 'R4andP4ss'"

# Copy a backup User DB, provided by Imran Teli Udemy courses for DevOps: https://www.udemy.com/course/decodingdevops/
sudo mysql -u root -p"$DATABASE_PASS" accounts < /tmp/vprofile-project/resources/db_backup_ImTeliDB.sql

# Refresh and restart mysql service (mariadb-server)
sudo mysql -u root -p"$DATABASE_PASS" -e "FLUSH PRIVILEGES"
sudo systemctl restart mariadb