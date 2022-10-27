#!/usr/bin/env bash

set -euo pipefail

if [[ "$(uname -m)" = 'arm64' ]]; then
  cat << EOF
============================================================
Running ARM installation procedure...
============================================================
EOF

  sudo docker run --name beeup-db \
    --restart unless-stopped \
    -d \
    --cap-add SYS_PTRACE \
    -p 1433:1433 \
    -v beeup-db-adoxx:/opt/mssql/adoxx_data \
    -v beeup-db-mssql:/var/opt/mssql \
    -e ACCEPT_EULA=y \
    -e MSSQL_SA_PASSWORD='12+*ADOxx*+34' \
    mcr.microsoft.com/azure-sql-edge:latest

  sudo docker run --platform linux/amd64 \
    --restart unless-stopped \
    -d \
    --add-host=host.docker.internal:host-gateway \
    -p 8080:8080 \
    -v "$(pwd)/pdfs":/home/app/PDF \
    -e DATABASE_HOST=host.docker.internal \
    -e DATABASE_PASSWORD='12+*ADOxx*+34' \
    -e DATABASE_NAME=beeup16_64 \
    -e DATABASE_ACCEPT_EULA=y \
    -e ADOXX_LICENSE_KEY=zAd-nvkz-Ynrtvrht9IAL2pZ \
    ghcr.io/realk1ko/beeup-docker:latest-arm64-emulation
else
  cat << EOF
============================================================
Running generic installation procedure...
============================================================
EOF
  sudo docker run --name beeup \
    --restart unless-stopped \
    -d \
    -p 8080:8080 \
    -v beeup-db-adoxx:/opt/mssql/adoxx_data \
    -v beeup-db-mssql:/var/opt/mssql \
    -v "$(pwd)/pdfs":/home/app/PDF \
    -e DATABASE_HOST=127.0.0.1 \
    -e DATABASE_PASSWORD='12+*ADOxx*+34' \
    -e DATABASE_NAME=beeup16_64 \
    -e DATABASE_ACCEPT_EULA=y \
    -e ADOXX_LICENSE_KEY=zAd-nvkz-Ynrtvrht9IAL2pZ \
    ghcr.io/realk1ko/beeup-docker:latest
fi

cat << EOF
============================================================
You have to finish the installation manually:
1) Open http://localhost:8080/vnc.html in your favorite
   browser and click 'Connect'. The password to connect is
   'beeup'.
2) Then click through the installation process and wait.
3) Wait some more.

That should be it, you're good to go.
============================================================
EOF
