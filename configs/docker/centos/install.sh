#!/usr/bin/bash

docker ps

if [[ $? -eq 0 ]]; then
    exit
fi

sudo yum install -y wget
wget -b --tries=5 http://kiloalpha.s3.amazonaws.com/rancher/centos/daemon.json
curl https://releases.rancher.com/install-docker/17.03.sh | sudo sh
sudo mv $HOME/daemon.json /etc/docker/daemon.json || echo '********You will have to move daemon.json to /etc/docker and restart docker********'
sudo systemctl enable docker && sudo systemctl start docker
sudo usermod -aG docker ${user}
sudo yum install -y ntp
sudo systemctl enable ntpd && sudo systemctl start ntpd
