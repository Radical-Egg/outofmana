---
title: "Creating Calibre Content Server"
date: 2024-12-24T19:25:02Z
draft: true
---

# Prerequisites

* linux (WSL probably works)
* docker + docker compose
* bindfs package (Can be installed with apt, dnf etc)

# Project Setup / Stuff

This project setup / initial configurations can be grabbed from [here](https://github.com/Radical-Egg/calibre-web-setup.git). 

* [Calibre](https://hub.docker.com/r/linuxserver/calibre)
  * A place to store my books in so that I can use different types of
    eReaders without having to worry about formats.
* [Filebrowser](https://hub.docker.com/r/filebrowser/filebrowser)
  * A way to easily upload books to the volumes mounted to the calibre docker container
* [Calibre-web](https://docs.linuxserver.io/images/docker-calibre-web/)
  * Book organization / OPDS server

# Quickstart

## Bindfs Detour

For whatever reason I could not seem to get the docker bind mounts to have ownership using my local UID/GID (there is probably another way to solve this or just chown it after you create the containers) so I used the `bindfs` package to mount all of the volumes with the permissions that the container is expecting to have.

```bash
[egg@grim ~]$ sudo dnf install bindfs
Package bindfs-1.17.4-1.el9.x86_64 is already installed.
Dependencies resolved.
Nothing to do.
Complete!
[egg@grim ~]$
```

bindfs is pretty cool, it will allow you to mount a directory to a different location using new ownership and permissions like this:

```bash
[egg@grim tmp]$ mkdir -p foo bar
[egg@grim tmp]$ ll
total 0
drwx------. 2 egg egg 6 Dec 25 16:37 bar
drwx------. 2 egg egg 6 Dec 25 16:38 foo
[egg@grim tmp]$ bindfs -u 911 -g 1001 foo/ bar/
[egg@grim tmp]$ echo "Hello bar" > foo/hello.txt
[egg@grim tmp]$ ll
total 0
drwx------. 2 911 1001 23 Dec 25 16:38 bar
drwx------. 2 egg egg  23 Dec 25 16:38 foo
[egg@grim tmp]$ sudo cat bar/hello.txt
Hello bar
[egg@grim tmp]$
```
We can use this utility to create mount points for the container while still allowing
us to make edits to configuration files without needing to use sudo frequently.

## Back to Quickstarting

1. Install bindfs, this could be different depending on your distro. The two most common package managers are probably apt and dnf. If you are using anything else then go on ahead with that

```bash
sudo dnf install bindfs
```

2. Clone [this repo](https://github.com/Radical-Egg/calibre-web-setup.git).
```bash
git clone https://github.com/Radical-Egg/calibre-web-setup.git
```
5. Create .env file
```bash
cd calibre-web-setup; echo "ThisIsATestPassword" > .env
```
4. Run start.sh
```bash
./start.sh
```

You will see something like this

```bash
[egg@grim calibre-web-setup]$ ./start.sh
Running: bindfs -u 911 -g 1001 /home/egg/tmp_test/calibre-web-setup/calibre-web-setup/filebrowser/configs /home/egg/tmp_test/calibre-web-setup/calibre-web-setup/remapped/filebrowser/configs
Running: bindfs -u 911 -g 1001 /home/egg/tmp_test/calibre-web-setup/calibre-web-setup/calibre-web/configs /home/egg/tmp_test/calibre-web-setup/calibre-web-setup/remapped/calibre-web/configs
Running: bindfs -u 911 -g 1001 /home/egg/tmp_test/calibre-web-setup/calibre-web-setup/calibre/data /home/egg/tmp_test/calibre-web-setup/calibre-web-setup/remapped/calibre/data
Running: bindfs -u 911 -g 1001 /home/egg/tmp_test/calibre-web-setup/calibre-web-setup/calibre/plugins /home/egg/tmp_test/calibre-web-setup/calibre-web-setup/remapped/calibre/plugins
[+] Running 4/4
 ✔ Network calibre-web-setup_default  Created                                                               0.2s
 ✔ Container filebrowser              Started                                                               0.3s
 ✔ Container calibre                  Started                                                               0.3s
 ✔ Container calibre-web              Started                                                               0.5s
[egg@grim calibre-web-setup]$
```

All set! Now you can access Calibre via port 8080, Calbre-Web on port 8083 and Filebrowser on 42069. The default docker compose file will mount ./calibre/library to that Calibre and Filebrowser containers. I set that as my library during the Calibre initial setup.
