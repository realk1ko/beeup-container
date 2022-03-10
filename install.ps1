# For Windows PowerShell (tested 5.1.19041.1320)
# and PowerShell (tested 7.1.4)

Write-Host "============================================================"
$download_beeup = Read-Host "Download Bee-up 1.6? (y|n) "
Write-Host "============================================================"

if ($download_beeup -eq 'y') {
  Invoke-WebRequest -OutFile ".\home\app\beeup.zip" `
    -Uri "https://bee-up.omilab.org/files/tool-installer/Bee-Up_1.6_64-bit_macOS-prototype.zip"
  Expand-Archive ".\home\app\beeup.zip" `
    -DestinationPath ".\home\app"
  Remove-Item ".\home\app\beeup.zip"
} else {
  Write-Host "============================================================"
  Write-Host "Installer expects that you've downloaded Bee-up by yourself"
  Write-Host "and unzipped it to .\home\app\bee-up-master-TOOL"
  Write-Host "============================================================"
  if (-Not (Test-Path -Path ".\home\app\bee-up-master-TOOL")) {
    Write-Host ".\home\app\bee-up-master-TOOL not found."
    Write-Host "Aborting installation."
    Write-Host "============================================================"
    Exit
  }
}


docker version 2>&1 | Out-Null
$docker_running = $?
if (-Not $docker_running) {
  Write-Host "============================================================"
  Write-Host "It appears that docker is not running. Please start docker"
  Write-Host "and run this script again. To install docker, see:"
  Write-Host "https://docs.docker.com/get-docker/"
  Write-Host "============================================================"
  Exit
}


Write-Host "============================================================"
Write-Host "Running generic installation procedure..."
Write-Host "============================================================"

docker build . -t beeup:latest

docker run --name beeup `
  --restart unless-stopped `
  -d `
  -p 8080:8080 `
  -v beeup:/home/app/data `
  beeup:latest


Write-Host "============================================================"
Write-Host "You have to finish the installation manually:"
Write-Host "1) Open http://localhost:8080/vnc.html in your favorite"
Write-Host "   browser and click 'Connect'. The password to connect is"
Write-Host "   'password'."
Write-Host "2) Then click through the installation process and wait."
Write-Host "3) Wait some more."
Write-Host
Write-Host "That should be it, you're good to go."
Write-Host "============================================================"
# Pause in case the PowerShell script is executed from context menu
Read-Host -Prompt "Press any key to continue"