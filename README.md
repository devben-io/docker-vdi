# Docker VDI (Virtual Desktop Instance)
Ubuntu Desktop 16.04 (xfce) Dockerfile with NoMachine remote access and firefox, libreoffice and tor-browser & more

# How to run
## with docker-nocompose
build & run:
```
docker-compose up -d
```

(re)-build
```
docker-compose build --no-cache
```

## manually
### Build

```
git clone https://git.dtpnk.tech/dtnpnk-labs/docker-vdi.git
cd docker-vdi
docker build -t=vdi:xfce .
```


### Enviroment vaiables
* `USER` -> user for the nomachine login
* `PASSWORD` -> password for the nomachine login

### Usage

```
docker run -d --rm -p 4000:4000 -p 4080:4080 -p 4443:4443 --name vdi -e PASSWORD=password -e USER=user --cap-add=SYS_PTRACE vdi:xfce
```


# Connect to the container
## with the Client
Download the NoMachine client from: https://www.nomachine.com/download, install the client, create a new connection to your public ip, port 4000, NX protocol, use enviroment user and password for authentication (make sure to setup enviroment variables for that)

## via Webbrowser
open URL: `https://127.0.0.1:4443`
