# run your own vpn server

this is a self hosted openvpn vpn server for debian/ubuntu based systems (or anybody with apt)

## step 0 / download this repo to your ubuntu server

```bash
git clone https://github.com/softwareshinobi/run-your-own-vpn-server/
```

## step 1 /  go into new directory

now `cd` into the directory

```bash
cd run-your-own-vpn-server
```

## step 2 / run provision script

* will install docker.
* will reconfigure the dockernetwork interface

run this command
```
sudo bash provision.bash
```

### note:

you will need to create a password to use across the installation. this password will never be used again. and can be automatically generated from a site like: 

```
https://www.lastpass.com/features/password-generator
```

## step 3 / start the  vpn server

after the provision, then we need to start the vpn server.

```bash
sudo bash vpnserver.bash
```

you will only need to do this once, as long as you aren't fooling around with images and containers in the future.

but when in doubt you can always run this command and it will stop and restart (but not reconfigure) the vpn server.



## step 4 / verify the openvpn containers are up

after running the previous command, verify the containers are running

```bash
docker ps | grep vpn
```

you should get output like this:

```bash
658b430879b1   nginx                                      "/docker-entrypoint.…"   2 minutes ago   Up 2 minutes   10.28.1.1:1180->80/tcp, 127.0.0.1:1180->80/tcp   private-openvpn-iam
0660ce10cf74   kylemanna/openvpn                          "ovpn_run"               2 minutes ago   Up 2 minutes   0.0.0.0:1194->1194/udp, [::]:1194->1194/udp      public-openvpn-server
cd3fea365237   softwareshinobi/vpn-server-key-publisher   "/docker-entrypoint.…"   2 minutes ago   Up 2 minutes   10.28.1.1:80->80/tcp, 127.0.0.1:80->80/tcp       private-network-website
e2ba72d40d09   softwareshinobi/embanet-intranet-docs      "/bin/busybox httpd …"   2 minutes ago   Up 2 minutes   0.0.0.0:1188->80/tcp, [::]:1188->80/tcp          private-openvpn-docs
```

## Read The Setup Guide

Installation is pretty straight forward. You can find the documentation in the `docs/` folder in additi

### configure the cloud server

[Configuring Cloud VPS Server w/ VPN + Intranet (Intruction Guide)](/docs/docs/Server-Side/index.md)

### configure your local ubuntu workstation

[Configuring Local Ubuntu Workstation w/ VPN Client (Instruction Guide)](/docs/docs/Client-Side/index.md)
