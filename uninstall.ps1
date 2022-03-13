# For Windows PowerShell (tested 5.1.19041.1320)
# and PowerShell (tested 7.1.4)

docker stop beeup
docker rm beeup
docker volume rm beeup_db1
docker volume rm beeup_db2
docker rmi beeup:latest

Write-Host "============================================================"
Write-Host "Done. You can remove the cloned repository too. I hope you"
Write-Host "passed MOD."
Write-Host "============================================================"
# Pause in case the PowerShell script is executed from context menu
Read-Host -Prompt "Press any key to continue"
