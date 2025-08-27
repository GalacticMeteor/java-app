#!/bin/bash

set -e

if [[ $EUID -eq 0 ]]; then
    echo "Do not run as root. Run as user with sudo privileges."
    exit 1
fi

# Update system
sudo apt update && sudo apt upgrade -y
sudo apt install -y wget curl gnupg2 software-properties-common apt-transport-https ca-certificates unzip

# Install Java 11
sudo apt install -y openjdk-11-jdk
JAVA_PATH=$(readlink -f $(which java) | sed "s:bin/java::")
echo "export JAVA_HOME=$JAVA_PATH" | sudo tee -a /etc/environment
export JAVA_HOME=$JAVA_PATH

# Install PostgreSQL for SonarQube
sudo apt install -y postgresql postgresql-contrib
sudo systemctl start postgresql
sudo systemctl enable postgresql

# Configure PostgreSQL for SonarQube
SONAR_DB_PASSWORD="SonarQube2024!"
sudo -u postgres psql <<EOF
CREATE USER sonar WITH ENCRYPTED PASSWORD '$SONAR_DB_PASSWORD';
CREATE DATABASE sonarqube OWNER sonar;
GRANT ALL PRIVILEGES ON DATABASE sonarqube TO sonar;
\q
EOF

# Install Jenkins
curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key | sudo tee /usr/share/keyrings/jenkins-keyring.asc > /dev/null
echo "deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] https://pkg.jenkins.io/debian-stable binary/" | sudo tee /etc/apt/sources.list.d/jenkins.list > /dev/null
sudo apt update
sudo apt install -y jenkins
sudo systemctl start jenkins
sudo systemctl enable jenkins

# Install Maven
MAVEN_VERSION="3.9.5"
cd /tmp
wget https://archive.apache.org/dist/maven/maven-3/$MAVEN_VERSION/binaries/apache-maven-$MAVEN_VERSION-bin.tar.gz
sudo tar xzf apache-maven-$MAVEN_VERSION-bin.tar.gz -C /opt
sudo ln -sf /opt/apache-maven-$MAVEN_VERSION /opt/maven

sudo tee /etc/profile.d/maven.sh > /dev/null <<EOF
export MAVEN_HOME=/opt/maven
export M2_HOME=/opt/maven
export PATH=\$PATH:\$MAVEN_HOME/bin
EOF

source /etc/profile.d/maven.sh

# Install SonarQube
sudo useradd -r -s /bin/false sonarqube || true
SONAR_VERSION="10.3.0.82913"
cd /tmp
wget https://binaries.sonarsource.com/Distribution/sonarqube/sonarqube-$SONAR_VERSION.zip
sudo unzip -q sonarqube-$SONAR_VERSION.zip -d /opt
sudo mv /opt/sonarqube-$SONAR_VERSION /opt/sonarqube
sudo chown -R sonarqube:sonarqube /opt/sonarqube

# Configure SonarQube database connection
sudo tee /opt/sonarqube/conf/sonar.properties > /dev/null <<EOF
sonar.jdbc.username=sonar
sonar.jdbc.password=$SONAR_DB_PASSWORD
sonar.jdbc.url=jdbc:postgresql://localhost/sonarqube
sonar.web.host=0.0.0.0
sonar.web.port=9000
EOF

sudo chown sonarqube:sonarqube /opt/sonarqube/conf/sonar.properties

sudo tee /etc/systemd/system/sonarqube.service > /dev/null <<EOF
[Unit]
Description=SonarQube service
After=syslog.target network.target postgresql.service

[Service]
Type=forking
ExecStart=/opt/sonarqube/bin/linux-x86-64/sonar.sh start
ExecStop=/opt/sonarqube/bin/linux-x86-64/sonar.sh stop
User=sonarqube
Group=sonarqube
Restart=always
LimitNOFILE=65536
LimitNPROC=4096

[Install]
WantedBy=multi-user.target
EOF

echo "sonarqube   -   nofile   65536" | sudo tee -a /etc/security/limits.conf
echo "sonarqube   -   nproc    4096" | sudo tee -a /etc/security/limits.conf
echo "vm.max_map_count=524288" | sudo tee -a /etc/sysctl.conf
echo "fs.file-max=131072" | sudo tee -a /etc/sysctl.conf
sudo sysctl -p

sudo systemctl daemon-reload
sudo systemctl start sonarqube
sudo systemctl enable sonarqube

# Install Trivy
wget -qO - https://aquasecurity.github.io/trivy-repo/deb/public.key | sudo apt-key add -
echo "deb https://aquasecurity.github.io/trivy-repo/deb $(lsb_release -sc) main" | sudo tee -a /etc/apt/sources.list.d/trivy.list
sudo apt update
sudo apt install -y trivy

# Configure firewall
sudo ufw allow 8080/tcp
sudo ufw allow 9000/tcp

echo "Installation complete"
echo "Jenkins: http://localhost:8080"
echo "SonarQube: http://localhost:9000"
echo "Database password: $SONAR_DB_PASSWORD"
sleep 10
if [ -f /var/lib/jenkins/secrets/initialAdminPassword ]; then
    echo "Jenkins password: $(sudo cat /var/lib/jenkins/secrets/initialAdminPassword)"
fi