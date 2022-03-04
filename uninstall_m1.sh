#!/bin/bash

sudo docker stop beeup
sudo docker stop beeup_db
sudo docker rm beeup
sudo docker rm beeup_db
sudo docker volume rm beeup
sudo docker rmi beeup:latest
sudo docker rmi mcr.microsoft.com/azure-sql-edge:latest

echo "============================================================"
echo "Done. You can remove the cloned repository too. I hope you"
echo "passed MOD."
echo "============================================================"
