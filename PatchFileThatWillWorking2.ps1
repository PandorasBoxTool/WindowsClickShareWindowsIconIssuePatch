#Kill explorer
Stop-Process -Name explorer

# Script to download and extract file from URL

# Define URL and destination for the file
$url = "https://www.barco.com/services/website/en/KnowledgeBaseArticle/DownloadAttachment?articleNumber=6077&attachmentFileName=FixUserShellFolderPermissions2.zip"
$destination = "C:\Users\$env:username\Desktop\FixUserShellFolderPermissions2.zip"

# Download the file
Invoke-WebRequest -Uri $url -OutFile $destination

# Extract the file
Expand-Archive -Path $destination -DestinationPath "C:\Users\$env:username\Desktop"

# Confirm the file has been extracted and placed on the desktop
Write-Host "File has been extracted and placed on the desktop."

# - Fix (if needed) your current user profile:
.\FixUserShellFolderPermissions.ps1
# - Force the registration main Shell packages:
.\FixUserShellFolderPermissions.ps1 -register
# - Force the registration of every packages (might take long time):
.\FixUserShellFolderPermissions.ps1 -force
# - [Run As Admin] Attempt to recover every profiles, but won't register packages
.\FixUserShellFolderPermissions.ps1 -allprofiles
# - To accept the EULA and run the tool silently:
.\FixUserShellFolderPermissions.ps1 -accepteula

Write-Host "Script has finished running successfully. Made by Pandoras Box Tool ;-)"
Start-Sleep -Seconds 10
Restart-Computer
Registry 