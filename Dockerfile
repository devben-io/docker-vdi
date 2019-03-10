FROM ubuntu:18.04 as vdi_base

ENV DEBIAN_FRONTEND=noninteractive

# Configure timezone and locale to spanish and America/Bogota timezone. Change locale and timezone to whatever you want
ENV LANG="de_DE.UTF-8"
ENV LANGUAGE=de_DE
ENV KEYMAP="de"
ENV TIMEZONE="Europe/Berlin"
#ENV DESKTOP="mate-desktop-environment-extras"
ENV DESKTOP="xfce4"


##################################################################################
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
	apt-get install -y software-properties-common python3-software-properties sudo && \
	add-apt-repository universe && apt-get update -y && \
	apt-get install -y vim xterm pulseaudio cups curl libgconf2-4 iputils-ping libxss1 wget xdg-utils libpango1.0-0 fonts-liberation && \
	# Install the desktop-enviroment version you would like to have
    apt-get install -y "${DESKTOP}" && \
    # Cleanup    
    apt-get autoremove -y && \
    apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
    
    
#######################################
# additional softeware: download tor, firefox, libreoffice and git, etc
# RUN add-apt-repository ppa:webupd8team/tor-browser && apt-get update -y && \
	# apt-get install -y aptitude tor firefox libreoffice htop nano git vim tor-browser iftop chromium-browser keepassx sshfs encfs terminator nmap tig mtr && \

RUN	apt-get update && apt-get install -y chromium-browser firefox torbrowser-launcher && \
	# Clean up APT when done.
	apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*







##################################################################################
# nomachine installation

FROM vdi_base as vdi


#######################################
# ONLINE install
# Goto https://www.nomachine.com/download/download&id=10 and change for the latest NOMACHINE_PACKAGE_NAME and MD5 shown in that link to get the latest version.
# Free - OLD
#ENV NOMACHINE_PACKAGE_NAME nomachine_5.2.11_1_amd64.deb
#ENV NOMACHINE_MD5 d697e5a565507d522380c94d2f295d0

# Free - lastest
ENV NOMACHINE_PACKAGE_NAME nomachine_6.5.6_9_amd64.deb
# ENV NOMACHINE_MD5 8fc4b0a467eff56f662f348c7e03c6ec

# Enterprise
# ENV NOMACHINE_PACKAGE_NAME nomachine-enterprise-desktop-evaluation_6.5.6_10_amd64.deb
# ENV NOMACHINE_MD5 306a8554a6ffc9aec6f8a2b7e6e61e46

# Install nomachine, change password and username to whatever you want here
#RUN	# curl -fSL "http://download.nomachine.com/download/5.2/Linux/${NOMACHINE_PACKAGE_NAME}" -o nomachine.deb \
#	curl -fSL "http://download.nomachine.com/download/6.5/Linux/${NOMACHINE_PACKAGE_NAME}" -o nomachine.deb \
#	echo "${NOMACHINE_MD5} *nomachine.deb" | md5sum -c - && \
#	# Clean up APT when done.
#	apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*


#######################################
# OFFLINE install
ADD ./install/${NOMACHINE_PACKAGE_NAME} /nomachine.deb
RUN	dpkg -i /nomachine.deb && \
    # Cleanup
    rm -f /nomachine.deb


#######################################
# add Configs
ADD ./configs/server.cfg /usr/NX/etc/server.cfg
ADD ./configs/node.cfg /usr/NX/etc/node.cfg
## keyboard-layout
ADD ./configs/bash_profile /home/user/.bash_profile
## Desktop config
ADD ./configs/xfce4 /home/user/.config/xfce4


ADD nxserver.sh /

ENTRYPOINT ["/nxserver.sh"]
