FROM ubuntu:16.04

ENV DEBIAN_FRONTEND=noninteractive

# Configure timezone and locale to spanish and America/Bogota timezone. Change locale and timezone to whatever you want
ENV LANG="de_DE.UTF-8"
ENV LANGUAGE=de_DE

RUN apt-get clean && apt-get update && apt-get install -y locales && \
	locale-gen de_DE.UTF-8 && locale-gen de_DE && \
	echo "Europe/Berlin" > /etc/timezone && \
    apt-get install -y locales && \
    sed -i -e "s/# $LANG.*/$LANG.UTF-8 UTF-8/" /etc/locale.gen && \
    dpkg-reconfigure --frontend=noninteractive locales && \
    update-locale LANG=$LANG && \
	apt-get update -y && apt-get install -y software-properties-common python-software-properties python3-software-properties sudo && \
	add-apt-repository universe && \
	apt-get update -y && apt-get install -y vim xterm pulseaudio cups curl libgconf2-4 iputils-ping libnss3-1d libxss1 wget xdg-utils libpango1.0-0 fonts-liberation




# Goto https://www.nomachine.com/download/download&id=10 and change for the latest NOMACHINE_PACKAGE_NAME and MD5 shown in that link to get the latest version.
ENV NOMACHINE_PACKAGE_NAME nomachine_6.2.4_1_amd64.deb
ENV NOMACHINE_MD5 210bc249ec9940721a1413392eee06fe

# Install the mate-desktop-enviroment version you would like to have
RUN apt-get update -y && \
    apt-get install -y mate-desktop-environment-extras

# download tor, firefox, libreoffice and git
RUN add-apt-repository ppa:webupd8team/tor-browser && \
	apt-get update -y && apt-get install -y tor firefox libreoffice htop nano git vim tor-browser

# Install nomachine, change password and username to whatever you want here
RUN curl -fSL "http://download.nomachine.com/download/6.2/Linux/${NOMACHINE_PACKAGE_NAME}" -o nomachine.deb \
&& echo "${NOMACHINE_MD5} *nomachine.deb" | md5sum -c - \
&& dpkg -i nomachine.deb

ADD nxserver.sh /

ENTRYPOINT ["/nxserver.sh"]
