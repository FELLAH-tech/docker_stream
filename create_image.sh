#! /bin/bash


Yellow='\033[0;33m';
RED='\033[0;31m';
NC='\033[0m';
Green='\033[0;32m';


sudo docker build -f Dockerfile_end_user.dockerfile -t stream .
sudo docker stop desktopuser4;
sudo pkill docker;
#sudo docker run -it stream;
sudo docker run -it --rm --name=desktopuser4 -p 8081:8081 stream;

