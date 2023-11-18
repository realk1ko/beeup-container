New-Item ./pdf -ItemType Directory -ea 0

Write-Host "============================================================"
Write-Host "Running generic installation procedure..."
Write-Host "============================================================"

docker run --name beeup `
    --restart unless-stopped `
    -d `
    -p 8080:8080 `
    -v beeup:/home/app/data `
    -v ${PWD}\pdf:/home/app/pdf `
    -e ADOXX_LICENSE_KEY=zAd-nvkz-YnrvwreuEKAL2pI `
    ghcr.io/realk1ko/beeup:latest

Write-Host "============================================================"
Write-Host "You have to finish the installation manually:"
Write-Host "1) Open http://localhost:8080/vnc.html in your favorite"
Write-Host "   browser and click 'Connect'.
Write-Host "2) Then click through the installation process and wait."
Write-Host "3) Wait some more."
Write-Host
Write-Host "That should be it, you're good to go."
Write-Host "============================================================"

Read-Host -Prompt "Press ENTER to continue..."
