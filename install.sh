#!/bin/bash

echo "============================================================"
echo -n "Download Bee-up 1.6? (y|n) "
read input
echo "============================================================"

if [ "$input" = 'y' ]; then
  echo "============================================================"
  echo "Bee-Up 1.6 is being downloaded..."
  echo "============================================================"

  curl -o home/app/beeup.zip https://bee-up.omilab.org/files/tool-installer/Bee-Up_1.6_64-bit_macOS-prototype.zip
  unzip home/app/beeup.zip home/app

  rm -f home/app/beeup.zip
else
  echo "============================================================"
  echo "Installer expects that you've downloaded Bee-up by yourself"
  echo "and unzipped it to home/app/bee-up-master-TOOL"
  echo "============================================================"
fi

if [ $(uname -m) = 'arm64' ]; then
  echo "============================================================"
  echo "Running ARM installation procedure..."
  echo "============================================================"

  sudo docker build --build-arg WINE_VERSION=7.0.0.0 --platform linux/amd64 . -t beeup:latest

  sudo docker run --name beeup_db \
    --restart unless-stopped \
    -d \
    --cap-add SYS_PTRACE \
    -p 1433:1433 \
    -e 'ACCEPT_EULA=1' \
    -e 'MSSQL_SA_PASSWORD=12+*ADOxx*+34' \
    mcr.microsoft.com/azure-sql-edge:latest

  sudo docker run --platform linux/amd64 \
    --name beeup \
    --restart unless-stopped \
    -d \
    --add-host=host.docker.internal:host-gateway \
    -p 8080:8080 \
    -v beeup:/home/app/data \
    -e DATABASE_HOST=host.docker.internal \
    beeup:latest
else 
  echo "============================================================"
  echo "Running generic installation procedure..."
  echo "============================================================"

  sudo docker build . -t beeup:latest

  sudo docker run --name beeup \
    --restart unless-stopped \
    -d \
    -p 8080:8080 \
    -v beeup:/home/app/data \
    beeup:latest
fi

echo "============================================================"
echo "You have to finish the installation manually:"
echo "1) Open http://localhost:8080/vnc.html in your favorite"
echo "   browser and click 'Connect'. The password to connect is"
echo "   'password'."
echo "2) Then click through the installation process and wait."
echo "3) Wait some more."
echo "4) When asked to for a password for the modelling toolkit,"
echo "   simply enter 'password'. Make sure to remember the new"
echo "   password as you'll need it if the container restarts."
echo
echo "That should be it, you're good to go."
echo "============================================================"
