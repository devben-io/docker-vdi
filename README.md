# Docker VDI (Virtual Desktop Instance)
Ubuntu Desktop 16.04 (xfce) Dockerfile with NoMachine remote access and firefox, libreoffice and tor-browser & more

# How to run
## Build

```
git clone https://git.dtpnk.tech/dtnpnk-labs/docker-vdi.git
cd docker-vdi
docker build -t=vdi:xfce .
```


## Enviroment vaiables
USER -> user for the nomachine login
PASSWORD -> password for the nomachine login

## Usage

```
docker run -d -p 4000:4000 -p 4080:4000 -p 4443:4443 --name vdi -e PASSWORD=password -e USER=user --cap-add=SYS_PTRACE vdi
```

## Connect to the container

Download the NoMachine client from: https://www.nomachine.com/download, install the client, create a new connection to your public ip, port 4000, NX protocol, use enviroment user and password for authentication (make sure to setup enviroment variables for that)
