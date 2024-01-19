#!/bin/bash

<<description

Bash script for application deployment service - Tomcat setup provisioning.
With #!/bin/bash (1st line) we provide the absolute path of the selected
interprenter, in order to execute the script using "bash".

description

# Tomcat service url
TOMURL="https://archive.apache.org/dist/tomcat/tomcat-9/v9.0.75/bin/apache-tomcat-9.0.75.tar.gz"

# Install java dependencies for tomcatm git, maven and wget packages
dnf -y install java-11-openjdk java-11-openjdk-devel
dnf install git maven wget -y

# Download tomcat tarball on temporary directory
cd /tmp/
wget $TOMURL -O tomcatbin.tar.gz

# Extract the tar.gz file and save it's contents in a variable
EXTOUT=$(tar xzvf tomcatbin.tar.gz)

# Select the first field of the EXTOUT path, using delimiter "/" and save it in a variable
TOMDIR=$(echo "$EXTOUT" | cut -d '/' -f1)

# Add a user with non-interactive shell access
useradd --shell /sbin/nologin tomcat

# ~ Copy the TOMDIR content to the given path, ensuring that only the differences will be
# ~ transferred (rsync), and make user tomcat the owner of this directory (chown)
rsync -avzh /tmp/$TOMDIR/ /usr/local/tomcat/
chown -R tomcat.tomcat /usr/local/tomcat

# ~ Replace tomcat service system file, with the following one. With this file, we set the
# ~ systemctl behavior of tomcat service.
rm -rf /etc/systemd/system/tomcat.service
cat <<EOT>> /etc/systemd/system/tomcat.service
[Unit]
Description=Tomcat
After=network.target

[Service]

User=tomcat     # ~ The user we have already created
Group=tomcat    # ~ alongside with his group

WorkingDirectory=/usr/local/tomcat      # The directory we created with rsync

Environment=JAVA_HOME=/usr/lib/jvm/jre  # Specify the location of Java Runtime Environment (JRE) 

Environment=CATALINA_PID=/var/tomcat/%i/run/tomcat.pid  # Location of the tomcat process id (PID)
Environment=CATALINA_HOME=/usr/local/tomcat             # Home directory of tomcat
Environment=CATALINA_BASE=/usr/local/tomcat             # Base directory of running a specific onstance of Tomcat

ExecStart=/usr/local/tomcat/bin/catalina.sh run         # ~ Given scripts for systemctl
ExecStop=/usr/local/tomcat/bin/shutdown.sh              # ~ start and stop tomcat service


RestartSec=10       # ~ Setting sleeptime of restarting to 10 seconds and handle any
Restart=always      # ~ unexpected exit with 'restart' (always)

[Install]
WantedBy=multi-user.target      # Start the service when the system reaches the multi-user mode

EOT

# Reload systemd manager and start + enable tomcat service
systemctl daemon-reload
systemctl start tomcat
systemctl enable tomcat

# ~ On temporary directory (line 18), clone vprofile repo and change directory inside the repo, where
# ~ the Project Object Model (pom.xml) is placed.
git clone -b main https://github.com/hkhcoder/vprofile-project.git
cd vprofile-project

# ~ Read pom.xml file, which is determining the project structure. This command builds the project,
# ~ installs its artifacts and checks for possible dependencies, packed in a Web Application Archive
# ~ (<dirname>.war)
mvn install

# ~ We restart tomcat service with a 20sec interval, in order to replace the ROOT.war (Web Application 
# ~ Archive) with the one we just created.
systemctl stop tomcat
sleep 20
rm -rf /usr/local/tomcat/webapps/ROOT*
cp target/vprofile-v2.war /usr/local/tomcat/webapps/ROOT.war
systemctl start tomcat
sleep 20

# We disable firewall and finally, restart tomcat service
systemctl stop firewalld
systemctl disable firewalld
systemctl restart tomcat
