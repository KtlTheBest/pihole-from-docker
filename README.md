# pihole-from-docker
Hello and welcome to my repository. The idea is to provide easy setup of pihole on your PC using docker.

## Why pihole?
When you run pihole on your computer, you'll start to block every add... at least that's the plan. But isn't it cool?!

## How to do it?
Run from the terminal the commands:
```
git clone https://github.com/KtlTheBest/pihole-from-docker.git
cd pihole-from-docker
./script.sh
```

This command will run script which will in turn pull pihole docker image from Docker hub and start a container with specified parameters.

## Any gotcha's?
The idea is that everything will be automatic, as soon as you start the command. But at the moment it is not, so you have to do a little setup.

1. First of all, you need a docker. Please google to install docker on your OS, the instructions are too different and too big to put them all here.
2. You need to change your `/etc/resolv.conf` file which contains a list of DNS servers to query. To do so, run from terminal:
```
sudo nano /etc/resolv.conf
```
If your `/etc/resolv.conf` looks like this:
```
nameserver 192.168.1.1
```
then you need to change it like this:
```
nameserver 127.0.0.1
nameserver 192.168.1.1
```
> Note: if you are using Ubuntu, it will say in the `/etc/resolf.conf` file to not to change it by hand. For that you need to stop `systemd-resolved` (don't know what it is):
> 
> ```
> sudo systemctl stop systemd-resolved
> sudo systemctl disable systemd-resolved
> ```
> and only then you can manually edit the `/etc/resolv.conf`.
> 
> If you want to put everything back the way it was before, just run:
> ```
> sudo systemctl enable systemd-resolved
> sudo systemctl start systemd-resovled
> ```

Hopefully, after that you start to see that ads are getting blocked (:D)

## TODO
- Add automatic Linux distro detection
- Add automatic docker install and setup
- Add options and argument parsing
- Extend the script to Fedora and resolve the problem with dnsmasq
