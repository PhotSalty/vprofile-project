#!/bin/bash

<<description

Bash script for web server Nginx (reverse proxy) setup provisioning. With 
#!/bin/bash (1st line) we provide the absolute path of the selected 
interprenter, in order to execute the script using "bash".

description

# Update apt and install nginx package
sudo apt update
sudo apt install nginx -y

<<vproapp_file_analysis

Vproapp Configuration file (vproapp)

    1. Upstream block (vproapp)     
        - In order to include 1 or more servers
        - We set tomcat app (app01) on port 8080

    2. Sever
        - tell Nginx to listen port 80 for incoming http requests

    3. location /
        - Define root path ("/") and tell nginx to forward requests
          to the upstream group of servers (tomcat app)

vproapp_file_analysis

# Create vprofile app configuration file:
sudo cat <<EOT > vproapp
upstream vproapp {

    server app01:8080;

}

server {

    listen 80;

location / {

    proxy_pass http://vproapp;

}

}

EOT

# Store vproapp configuration as an available site for nginx
sudo mv vproapp /etc/nginx/sites-available/vproapp

# ~ Delete default site and activate vproapp (available site), with a link 
# ~ to its configuration file
sudo rm -rf /etc/nginx/sites-enabled/default
sudo ln -s /etc/nginx/sites-available/vproapp /etc/nginx/sites-enabled/vproapp

# Start/Restart and enable (on-boot start) Nginx service
sudo systemctl restart nginx
sudo systemctl enable nginx


