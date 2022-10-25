#!/bin/bash

set -xe

# only start if using the packaged MSSQL database
if [ "${DATABASE_HOST}" = "127.0.0.1" ]
then
  SA_PASSWORD=${DATABASE_SA_PASSWORD} /opt/mssql/bin/sqlservr
fi
