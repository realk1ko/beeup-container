New-Item ./pdfs -ItemType Directory -ea 0

Write-Host "============================================================"
Write-Host "Running generic installation procedure..."
Write-Host "============================================================"

docker run --name beeup `
    --restart unless-stopped `
    -d `
    -p 8080:8080 `
    -v beeup-db-adoxx:/opt/mssql/adoxx_data `
    -v beeup-db-mssql:/var/opt/mssql `
    -v ${PWD}\pdfs:/home/app/PDF `
    -e DATABASE_HOST=127.0.0.1 `
    -e DATABASE_PASSWORD='12+*ADOxx*+34' `
    -e DATABASE_NAME=beeup16_64 `
    -e DATABASE_ACCEPT_EULA=y `
    -e ADOXX_LICENSE_KEY=zAd-nvkz-Ynrtvrht9IAL2pZ `
    ghcr.io/realk1ko/beeup:latest

Write-Host "============================================================"
Write-Host "You have to finish the installation manually:"
Write-Host "1) Open http://localhost:8080/vnc.html in your favorite"
Write-Host "   browser and click 'Connect'. The password to connect is"
Write-Host "   'beeup'."
Write-Host "2) Then click through the installation process and wait."
Write-Host "3) Wait some more."
Write-Host
Write-Host "That should be it, you're good to go."
Write-Host "============================================================"

Read-Host -Prompt "Press any key to continue"
