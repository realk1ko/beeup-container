#!/bin/bash

set -xe

# only start if using the packaged MSSQL database
if [ "${DATABASE_HOST}" = "127.0.0.1" ]
then
  /opt/mssql/bin/sqlservr
fi
