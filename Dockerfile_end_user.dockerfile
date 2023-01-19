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

 # Getting code from GitHub & Compiling

EXPOSE 8081



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
cd ~; \
git clone https://github.com/medahalli/WebRTC.git; \
cd WebRTC; \
#launching the app
npm install; \
npm install express; \
npm install pug; \
npm install express-session; \
npm install connect-sqlite3; \
npm install sqlite3 sqlite; \
npm install bcrypt; \
node install.js; \
node db.js; \
node db_debug.js; \
npm start; \
# terminal [Optional]
bash