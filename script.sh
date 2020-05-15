#!/bin/bash

start_cmd="docker run -d
  --name pihole
  -p 53:53/tcp -p 53:53/udp
  -p 80:80 -p 443:443
  -e TZ=Kazakhstan/Almaty
  -e VIRTUAL_HOST=pi.hole
  -e PROXY_LOCATION=pi.hole
  -e ServerIP=127.0.0.1
  -e WEBPASSWORD=hellopihole
  -v $(pwd)/etc-dnsmasq.d:/etc/dnsmasq.d
  -v $(pwd)/etc-pihole:/etc/pihole
  --dns=127.0.0.1 --dns=1.1.1.1
  --hostname pi.hole
  --restart=unless-stopped
  pihole/pihole"

install_docker_ubuntu(){
  echo 'OS: Ubuntu'
  sudo apt-get remove -y docker docker-engine docker.io containerd runc
  sudo apt-get install -y docker.io
  sudo systemctl enable docker
  sudo usermod -aG docker $USER
}

install_docker(){
  echo 'Attempting to install docker...'
  install_docker_ubuntu
}

check_os(){
  :
}

check_docker(){
  if [[ ! docker ]] ; then
    install_docker
    echo 'Installed the docker, please reboot the OS and try running the script again'
    exit 0
  fi
}

setup_resolv(){
  sudo gawk -i inplace '/^nameserver / && !x {print "nameserver 127.0.0.1"; x=1} 1' /etc/resolv.conf
  echo "[o] Setup /etc/resolv.conf"
}

unsetup_resolv(){
  sudo sed -i '/nameserver 127.0.0.1/d' /etc/resolv.conf
}

start_pihole(){
  check_docker
  setup_resolv
  $start_cmd
  if [[ $? -ne 0 ]] ; then
    echo 'Something went wrong...'
    exit 1
  fi
}

stop_pihole(){
  output=$(docker ps | grep pihole)
  if [[ -n $output ]] ; then
    docker stop pihole
    docker rm pihole
  fi
  if [[ $? -ne 0 ]] ; then
    echo '[x] Something went wrong'
    echo
    docker ps
  fi
  unsetup_resolv
}

print_usage(){
  echo "Usage: $0 [start|stop]"
  echo "  start - install docker and start pihole container"
  echo "  stop  - stop pihole container"
}

if [[ $# -eq 0 ]] ; then
  print_usage
  exit 1
fi

case $1 in
  start) start_pihole ;;
  stop)  stop_pihole  ;;
  *)     echo "Unknown command!"; print_usage ; exit 1 ;;
esac
