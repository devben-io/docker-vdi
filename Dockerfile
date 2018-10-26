FROM ubuntu:16.04

ENV DEBIAN_FRONTEND=noninteractive

# Configure timezone and locale to spanish and America/Bogota timezone. Change locale and timezone to whatever you want
ENV LANG="de_DE.UTF-8"
ENV LANGUAGE=de_DE
ENV KEYMAP="de"
ENV TIMEZONE="Europe/Berlin"
#ENV DESKTOP="mate-desktop-environment-extras"
ENV DESKTOP="xfce4"

# Goto https://www.nomachine.com/download/download&id=10 and change for the latest NOMACHINE_PACKAGE_NAME and MD5 shown in that link to get the latest version.
# Free
ENV NOMACHINE_PACKAGE_NAME nomachine_6.3.6_1_amd64.deb
ENV NOMACHINE_MD5 6a30a4ee607848685941cf3b575eb0e9
# Enterprise
#ENV NOMACHINE_PACKAGE_NAME nomachine-enterprise-desktop-evaluation_6.2.4_4_amd64.deb
#ENV NOMACHINE_MD5 a066f66b07f9d9b4b189e82d46f4464e

########################

# Base System
RUN apt-get clean && apt-get update && apt-get install -y locales apt-utils && \
	#locales
	locale-gen ${LANG} && locale-gen ${LANGUAGE} && \
	echo "${TIMEZONE}" > /etc/timezone && \
    apt-get install -y locales && \
    sed -i -e "s/# $LANG.*/$LANG.UTF-8 UTF-8/" /etc/locale.gen && \
    dpkg-reconfigure --frontend="${DEBIAN_FRONTEND}" locales && \
    update-locale LANG=$LANG && \
	echo "XKBLAYOUT=\"${KEYMAP}\"" > /etc/default/keyboard && \
	# software
	apt-get install -y software-properties-common python-software-properties python3-software-properties sudo && \
	add-apt-repository universe && apt-get update -y && \
	apt-get install -y vim xterm pulseaudio cups curl libgconf2-4 iputils-ping libnss3-1d libxss1 wget xdg-utils libpango1.0-0 fonts-liberation && \
	# Install the desktop-enviroment version you would like to have
    apt-get install -y "${DESKTOP}" && \
	# Install nomachine, change password and username to whatever you want here
	curl -fSL "http://download.nomachine.com/download/6.3/Linux/${NOMACHINE_PACKAGE_NAME}" -o nomachine.deb && \
	echo "${NOMACHINE_MD5} *nomachine.deb" | md5sum -c - && \
	dpkg -i nomachine.deb && \
	# Clean up APT when done.
	apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# additional softeware: download tor, firefox, libreoffice and git, etc
RUN add-apt-repository ppa:webupd8team/tor-browser && apt-get update -y && \
	apt-get install -y aptitude tor firefox libreoffice htop nano git vim tor-browser iftop chromium-browser keepassx sshfs encfs terminator nmap tig mtr && \
	# Clean up APT when done.
	apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# add Configs
ADD ./configs/server.cfg /usr/NX/etc/server.cfg
ADD ./configs/node.cfg /usr/NX/etc/node.cfg
## keyboard-layout
ADD ./configs/bash_profile /home/user/.bash_profile
## Desktop config
ADD ./configs/xfce4 /home/user/.config/xfce4


ADD nxserver.sh /

ENTRYPOINT ["/nxserver.sh"]
