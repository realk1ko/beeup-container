Write-Host "============================================================"
Write-Host "Uninstalling Bee-Up..."
Write-Host "============================================================"

docker stop beeup
docker rm beeup
docker rmi ghcr.io/realk1ko/beeup:latest

docker volume rm beeup

Write-Host "============================================================"
Write-Host "Done. You can now remove the repository folder."
Write-Host "============================================================"

Read-Host -Prompt "Press ENTER to continue..."
