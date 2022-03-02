#!/bin/bash

sudo docker stop beeup
sudo docker rm beeup
sudo docker rmi beeup:latest

echo "============================================================"
echo "Done. You can remove the cloned repository too. I hope you"
echo "passed MOD."
echo "============================================================"
