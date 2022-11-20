Write-Host "============================================================"
Write-Host "Uninstalling Bee-Up..."
Write-Host "============================================================"

docker stop beeup
docker rm beeup
docker rmi ghcr.io/realk1ko/beeup:latest

docker volume rm beeup-db-adoxx
docker volume rm beeup-db-mssql

Write-Host "============================================================"
Write-Host "Done. You can now remove the repository folder."
Write-Host "============================================================"

Read-Host -Prompt "Press any key to continue"
