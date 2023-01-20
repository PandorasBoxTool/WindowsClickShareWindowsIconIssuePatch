#Kill explorer
Stop-Process -Name explorer

# Script to download and extract file from URL

# Define URL and destination for the file
$url = "https://www.barco.com/services/website/nl/KnowledgeBaseArticle/DownloadAttachment?articleNumber=6077&attachmentFileName=FixUserShellFolderPermissions.zip"
$destination = "C:\Users\$env:username\Desktop\FixUserShellFolderPermissions.zip"

# Download the file
Invoke-WebRequest -Uri $url -OutFile $destination

# Extract the file
Expand-Archive -Path $destination -DestinationPath "C:\Users\$env:username\Desktop"

# Confirm the file has been extracted and placed on the desktop
Write-Host "File has been extracted and placed on the desktop."

#Then we need to addet the Uninstaller
Start-Process msiexec.exe -ArgumentList '/uninstall "C:\Program Files\Barco\ClickShare\ClickShare.msi" /quiet' -Wait
Start-Process "C:\Program Files (x86)\Barco\ClickShare Native\unins000.exe" -ArgumentList '/SILENT' -Wait
Remove-ItemProperty -Path "HKEY_LOCAL_MACHINE\SOFTWARE\Barco\ClickShare" -Recurse -Force

$programName = "calendarreader32.exe"
$possiblePaths = "C:\", "D:\", "E:\"

foreach ($path in $possiblePaths) {
    $fullPath = Join-Path -Path $path -ChildPath $programName
    if (Test-Path $fullPath) {
        Remove-Item -Path $fullPath -Recurse -Force
        Write-Host "Deleted $fullPath"
        break
    }
}

$key = 'HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\calendarreader32'
Remove-ItemProperty -Path $key -Recurse -Force

$programName = "calendarreader64.exe"
$possiblePaths = "C:\", "D:\", "E:\"

foreach ($path in $possiblePaths) {
    $fullPath = Join-Path -Path $path -ChildPath $programName
    if (Test-Path $fullPath) {
        Remove-Item -Path $fullPath -Recurse -Force
        Write-Host "Deleted $fullPath"
        break
    }
}

$key = 'HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\calendarreader64'
Remove-ItemProperty -Path $key -Recurse -Force

#  1) To fix permissions if needed, and then register required packages if permissions were modified:
Push-Location "C:\Users\$env:username\Desktop"
.\FixUserShellFolderPermissions.ps1
Pop-Location

#  2) To fix permissions if needed, and then always register only required or missing packages:
Push-Location "C:\Users\$env:username\Desktop"
.\FixUserShellFolderPermissions.ps1 -register
Pop-Location

#  3) To fix permissions if needed, and then force registering every packages (might take long time):
Push-Location "C:\Users\$env:username\Desktop"
.\FixUserShellFolderPermissions.ps1 -force
Pop-Location

#Fix the Effectet Regedit
Get-AppXPackage | Foreach {Add-AppxPackage -DisableDevelopmentMode -Register "C:\Windows\SystemApps\Microsoft.Windows.Search_cw5n1h2txyewy\AppXManifest.xml"}
Get-AppxPackage | Foreach {Add-AppxPackage -DisableDevelopmentMode -Register "C:\Windows\SystemApps\ShellExperienceHost_cw5n1h2txyewy\AppXManifest.xml"}
Get-AppXPackage | Foreach {Add-AppxPackage -DisableDevelopmentMode -Register "C:\Windows\SystemApps\MicrosoftWindows.Client.CBS_cw5n1h2txyewy\AppXManifest.xml"}
if (-not (Get-AppxPackage Microsoft.AAD.BrokerPlugin)) { Add-AppxPackage -Register "$env:windir\SystemApps\Microsoft.AAD.BrokerPlugin_cw5n1h2txyewy\Appxmanifest.xml" -DisableDevelopmentMode -ForceApplicationShutdown } Get-AppxPackage Microsoft.AAD.BrokerPlugin
if (-not (Get-AppxPackage Microsoft.Windows.CloudExperienceHost)) { Add-AppxPackage -Register "$env:windir\SystemApps\Microsoft.Windows.CloudExperienceHost_cw5n1h2txyewy\Appxmanifest.xml" -DisableDevelopmentMode -ForceApplicationShutdown } Get-AppxPackage Microsoft.Windows.CloudExperienceHost
Start-Process explorer.exe

taskbar/explorer 
start/search/o365 auth/registration

Write-Host "Script has finished running successfully. Made by Pandoras Box Tool ;-)"
Start-Sleep -Seconds 10
Restart-Computer