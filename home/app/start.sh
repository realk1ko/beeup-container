#!/bin/bash

wineboot

# messy workaround since wineboot seems to finish without the Mono runtime installed
sleep 60

if [ ! -f "${HOME}/initialized" ]
then
  # Initialize database
  /opt/mssql-tools/bin/sqlcmd -S localhost -U SA -P '12+*ADOxx*+34' -i "${HOME}/createUser.sql"
  /opt/mssql-tools/bin/sqlcmd -S localhost -U SA -P '12+*ADOxx*+34' -i "${HOME}/createDB.sql"

  # Finish installation of Bee-Up
  odbcinst -i -s ${DATABASE} -f "${HOME}/odbctemplate.ini"
  wine "C:/Program Files/BOC/${TOOLFOLDER}/adbinst.exe" -d${DATABASE} -l${LICENSE_KEY} -sSQLServer -iNO_SSO -lang2057

  # Remember that Bee-Up was intialized
  touch "${HOME}/initialized"
fi

wine "${WINEPREFIX}"/drive_c/Program\ Files/BOC/BEEUP16_ADOxx_SA/areena.exe -uAdmin -ppassword -d${DATABASE}
