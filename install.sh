#! /bin/bash


Yellow='\033[0;33m';
RED='\033[0;31m';
NC='\033[0m';
Green='\033[0;32m';

sudo apt-get update;

# dpocker install
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-compose-plugin;
sudo docker run hello-world;
systemctl start docker;

# remmina install
sudo apt-add-repository ppa:remmina-ppa-team/remmina-next;
sudo apt update;
sudo apt install remmina remmina-plugin-rdp remmina-plugin-secret;

sudo killall remmina;