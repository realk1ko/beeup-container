#!/bin/bash

set -xe

cat << EOF
============================================================
Uninstalling Bee-Up...
============================================================
EOF

sudo docker stop beeup
sudo docker rm beeup
sudo docker rmi ghcr.io/realk1ko/beeup-docker:latest

if [ "$(uname -m)" = 'arm64' ]; then
  sudo docker stop beeup-db
  sudo docker rm beeup-db
  sudo docker rmi mcr.microsoft.com/azure-sql-edge:latest
fi

sudo docker volume rm beeup-db-adoxx
sudo docker volume rm beeup-db-mssql

cat << EOF
============================================================
Done. You can now remove the repository folder.
============================================================
EOF
