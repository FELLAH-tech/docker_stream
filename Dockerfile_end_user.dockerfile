# Dockfile documentation
# https://docs.docker.com/engine/reference/builder/

# Build command : sudo docker build -f Dockerfile_end_user.dockerfile -t enduser .
# Run command : sudo docker run -it --rm --cap-add=NET_ADMIN --name=desktopuser3 -p 3389:3389 --device /dev/net/tun  enduser

# It must be the first command (except for ARG)
FROM ubuntu:20.04

# environment
ENV TZ=Europe/Paris
ENV DEBIAN_FRONTEND=noninteractive
ENV CLIENT_ID=1
#ENV COOKIE='pl947-pro/unix:0  MIT-MAGIC-COOKIE-1  f808c0886320e1d37256e096764f866f'

# setting root password
RUN \
    echo "deep*/L" > password; \
    echo "deep*/L" >> password; \
    passwd root < password;


# Installing
# --- update & upgrade
RUN apt update && DEBIAN_FRONTEND=noninteractive apt install -y lubuntu-desktop

RUN rm /run/reboot-required*

# creating user
RUN useradd -m deeptrust -p $(openssl passwd deep)
RUN usermod -aG sudo deeptrust

# xrdp
RUN apt install -y xrdp
RUN adduser xrdp ssl-cert

RUN sed -i '3 a echo "\
export GNOME_SHELL_SESSION_MODE=lubuntu\\n\
export XDG_SESSION_TYPE=x11\\n\
export XDG_CURRENT_DESKTOP=LXQt\\n\
export XDG_CONFIG_DIRS=/etc/xdg/xdg-Lubuntu:/etc/xdg\\n\
" > ~/.xsessionrc' /etc/xrdp/startwm.sh

RUN apt-get update > /dev/null; apt-get upgrade -y > /dev/null;

# --- basic tools
RUN apt-get install -y build-essential cmake python3 curl grep net-tools iputils-ping zip git lsof nmap gnupg wget systemctl > /dev/null;

# --- pip
RUN \
apt-get install -y python3-pip;

# --- ssh server
RUN apt-get install -y openssh-server > /dev/null;


# --- ssh-client
RUN apt-get install -y ssh-client sshpass;

# --- sudo
RUN  apt-get -y install sudo;

# --- openvpn
RUN  apt-get -y install network-manager-openvpn network-manager-openvpn-gnome openvpn;

# --- nodejs and npm
ENV NODE_VERSION=16.13.0
RUN apt install -y curl > /dev/null;
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash > /dev/null;
ENV NVM_DIR=/root/.nvm
RUN . "$NVM_DIR/nvm.sh" && nvm install ${NODE_VERSION} > /dev/null;
RUN . "$NVM_DIR/nvm.sh" && nvm use v${NODE_VERSION} > /dev/null;
RUN . "$NVM_DIR/nvm.sh" && nvm alias default v${NODE_VERSION} > /dev/null;
ENV PATH="/root/.nvm/versions/node/v${NODE_VERSION}/bin/:${PATH}"
RUN node --version
RUN npm --version

# --- aws-cli
RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip";
RUN unzip awscliv2.zip;
RUN ./aws/install;

# --- aws-cdk
RUN npm install -g aws-cdk;
RUN cdk --version;

# --- time
RUN apt-get install -y time;


# upgrading
RUN \
    python3 -m ensurepip --upgrade; \
    python3 -m pip install --upgrade pip; \
    python3 -m pip install --upgrade virtualenv;

# upgrading
RUN \
    apt-get update ;\
    apt-get -y install firefox; \ 
    apt-get -y install xauth; \
    apt-get -y install ffmpeg; 

EXPOSE 8887
EXPOSE 3389

    
RUN apt-get -y install xterm
RUN apt-get -y install gvfs-backends
RUN apt-get -y install lxqt-panel



RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

USER root

# CMD is the default command that is going to be executed in the startup of every exection.
# Only the last one is considered. So use it once.
CMD \
# start xrdp
service xrdp start ; \
# starting ssh server
/etc/init.d/ssh start; \
lxqt-panel; \
# starting ssh server
/etc/init.d/ssh start; \
# Getting code from GitHub & Compiling
echo "Compiling / Downloading dependancies"; \
cd ~; \
wget https://www.sample-videos.com/video123/mp4/720/big_buck_bunny_720p_30mb.mp4; \
git clone https://github.com/FELLAH-tech/stream.git; \
git clone https://github.com/Dash-Industry-Forum/dash.js.git; \
cp -r dash.js stream/streaming/views; \
cd stream/streaming; \
#launching the app
npm install; \
node server.js \
# terminal [Optional]
bash