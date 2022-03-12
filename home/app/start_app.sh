#!/bin/bash

set -xe

wineboot

if [ ! -f "${HOME}/data/initialized_db" ]
then
  # Initialize database
  /opt/mssql-tools/bin/sqlcmd -S ${DATABASE_HOST} -U SA -P ${SA_PASSWORD} -i "${HOME}/createUser.sql"
  /opt/mssql-tools/bin/sqlcmd -S ${DATABASE_HOST} -U SA -P ${SA_PASSWORD} -i "${HOME}/createDB.sql"

  # Remember that the DB was initialized
  touch "${HOME}/data/initialized_db"
fi

if [ ! -f "${HOME}/initialized_app" ]
then
  # Finish installation of Bee-Up
  cat <<EOF > "${HOME}/odbc.ini"
[beeup16_64]
Driver=ODBC Driver 17 for SQL Server
Server=${DATABASE_HOST}
Database=beeup16_64
AutoTranslate=no
EOF
  odbcinst -i -s ${DATABASE} -f "${HOME}/odbc.ini"
  wine "C:/Program Files/BOC/${TOOLFOLDER}/adbinst.exe" -d${DATABASE} -l${LICENSE_KEY} -sSQLServer -iNO_SSO -lang2057

  # Disables the required password change
  /opt/mssql-tools/bin/sqlcmd -S ${DATABASE_HOST} -U SA -P ${SA_PASSWORD} -i "${HOME}/postprocess.sql"

  # Remember that Bee-Up was intialized
  touch "${HOME}/initialized_app"
fi

wine "${WINEPREFIX}"/drive_c/Program\ Files/BOC/BEEUP16_ADOxx_SA/areena.exe -uAdmin -ppassword -d${DATABASE}
