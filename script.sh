docker run -d \
  --name pihole \
  -p 53:53/tcp -p 53:53/udp \
  -p 80:80 -p 443:443 \
  -e TZ="Kazakhstan/Almaty" \
  -e VIRTUAL_HOST="pi.hole" \
  -e PROXY_LOCATION="pi.hole" \
  -e ServerIP="127.0.0.1" \
  -e WEBPASSWORD="hellopihole" \
  -v "$(pwd)/etc-dnsmasq.d:/etc/dnsmasq.d" \
  -v "$(pwd)/etc-pihole:/etc/pihole" \
  --dns=127.0.0.1 --dns=1.1.1.1 \
  --hostname pi.hole \
  --restart=unless-stopped \
  pihole/pihole
