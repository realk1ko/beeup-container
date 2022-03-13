#!/bin/bash

sudo docker stop beeup
sudo docker rm beeup
sudo docker rmi beeup:latest

if [ "$(uname -m)" = 'arm64' ]; then
  sudo docker stop beeup_db
  sudo docker rm beeup_db
  sudo docker rmi mcr.microsoft.com/azure-sql-edge:latest
fi

sudo docker volume rm beeup_db1
sudo docker volume rm beeup_db2

echo "============================================================"
echo "Done. You can remove the cloned repository too. I hope you"
echo "passed MOD."
echo "============================================================"
