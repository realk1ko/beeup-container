#!/bin/bash

sudo docker build . --platform linux/amd64 -t beeup:latest
sudo docker run --name beeup \
  --platform linux/amd64 \
  --restart unless-stopped \
  -d \
  -p 8080:8080 \
  -e 'ACCEPT_EULA=Y' \
  -e 'SA_PASSWORD=12+*ADOxx*+34' \
  beeup:latest

echo "============================================================"
echo "You have to finish the installation manually:"
echo "1) Open http://localhost:8080/vnc.html in your favorite"
echo "   browser and click 'Connect'."
echo "2) Then click through the installation process and wait."
echo "3) Wait some more."
echo "4) When asked to change a password, simply enter 'password'"
echo "   as the old password. Make sure to remember the new"
echo "   password as you'll need it if the container restarts."
echo
echo "That should be it, you're good to go."
echo "============================================================"
