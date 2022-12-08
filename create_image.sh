#! /bin/bash


Yellow='\033[0;33m';
RED='\033[0;31m';
NC='\033[0m';
Green='\033[0;32m';

sudo 

sudo docker build -f Dockerfile_end_user.dockerfile -t stream .
sudo docker stop desktopuser4;
sudo pkill docker;
sudo lsof -i:3389 | tail -n +2 | cut -d " " -f 2 > pids;
sudo kill -9 $(<pids);
sudo pkill xrdp
sudo docker run -it -d --rm --cap-add=NET_ADMIN --name=desktopuser4 -p 3389:3389 --device /dev/net/tun  stream;
sleep 5;
sudo remmina -c group_rdp_connexion-rapide_127-0-0-1.remmina &
sleep 11;
sudo docker exec desktopuser4 /bin/sh -c "cp /usr/share/lxpanel/profile/Lubuntu/panels/panel ~/.config/lxpanel/Lubuntu/panels; lxpanelctl restart"
sudo docker exec desktopuser4 /bin/sh -c "cp /usr/share/applications/firefox.desktop ~/Desktop/; apt install gvfs-backends;dbus-launch gio set ~/Desktop/firefox.desktop metadata::trusted true; chmod a+x ~/Desktop/firefox.desktop"
sudo docker exec desktopuser4 /bin/sh -c "cp /usr/share/applications/qterminal.desktop ~/Desktop/; apt install gvfs-backends;dbus-launch gio set ~/Desktop/qterminal.desktop metadata::trusted true; chmod a+x ~/Desktop/qterminal.desktop"
