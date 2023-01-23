#Kill explorer
Stop-Process -Name explorer


$objSID = New-Object System.Security.Principal.SecurityIdentifier ("S-1-15-2-1")
$objUser = $objSID.Translate( [System.Security.Principal.NTAccount])
$user = $objUser.Value
$Packages = $user.Split("\") 
$packages = $packages[1]


$key = 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\ProfileList\S-1-12-1-*'
$profiles = (Get-Item $key)

New-PSDrive -PSProvider Registry -Name HKU -Root HKEY_USERS

Foreach ($profile in $profiles) {
$sids = $profile
$sids = Split-path -path $sids -leaf
$user = "HKU:\$sids\"
$test = test-path $user

if ($test -eq $true){ 
$Folder = "HKU:\$sids\Software\Microsoft\windows\currentversion\explorer\"
$Acl = Get-ACL $folder
$AccessRule= New-Object System.Security.AccessControl.RegistryAccessRule($Packages,"Readkey","ContainerInherit","None","Allow")
$Acl.SetAccessRule($AccessRule)
Set-Acl $folder $Acl

$Folder = "HKU:\$sids\Software\Microsoft\windows\currentversion\explorer\user shell folders"
$Acl = Get-ACL $folder
$AccessRule= New-Object System.Security.AccessControl.RegistryAccessRule($Packages,"Readkey","ContainerInherit","None","Allow")
$Acl.SetAccessRule($AccessRule)
Set-Acl $folder $Acl
}     
}

Get-AppXPackage *Microsoft.Windows.Search* |
ForEach-Object {
Add-AppxPackage -DisableDevelopmentMode -ForceApplicationShutdown -Register "$($_.InstallLocation)\AppXManifest.xml"
}
Get-AppXPackage *MicrosoftWindows.Client.CBS* |
ForEach-Object {
Add-AppxPackage -DisableDevelopmentMode -ForceApplicationShutdown -Register "$($_.InstallLocation)\AppXManifest.xml"
}
Get-AppXPackage *Microsoft.Windows.ShellExperienceHost* |
ForEach-Object {
Add-AppxPackage -DisableDevelopmentMode -ForceApplicationShutdown -Register "$($_.InstallLocation)\AppXManifest.xml"
}
Get-AppXPackage *Microsoft.AAD.BrokerPlugin* |
ForEach-Object {
Add-AppxPackage -DisableDevelopmentMode -ForceApplicationShutdown -Register "$($_.InstallLocation)\AppXManifest.xml"
}
Get-AppXPackage *Microsoft.AccountsControl* |
ForEach-Object {
Add-AppxPackage -DisableDevelopmentMode -ForceApplicationShutdown -Register "$($_.InstallLocation)\AppXManifest.xml"
}

Get-AppXPackage *Microsoft.Windows.CloudExperienceHost* |
ForEach-Object {
Add-AppxPackage -DisableDevelopmentMode -ForceApplicationShutdown -Register "$($_.InstallLocation)\AppXManifest.xml"
}


Get-AppXPackage -AllUsers | Foreach {Add-AppxPackage -DisableDevelopmentMode -Register "$($_.InstallLocation)\AppXManifest.xml"}



$url = "https://www.barco.com/services/website/en/TdeFiles/Download?FileNumber=R3306183&TdeType=3&MajorVersion=04&MinorVersion=27&PatchVersion=02&BuildVersion=004&ShowDownloadPage=False"
$destination = "C:\Users\$env:username\Desktop\WindowsClickShareWindowsIconIssuePatch-main"

# Download the file
Invoke-WebRequest -Uri $url -OutFile $destination

# Extract the file
Expand-Archive -Path $destination -DestinationPath "C:\Users\$env:username\Desktop"

# Confirm the file has been extracted and placed on the desktop
Write-Host "File has been extracted and placed on the desktop."

Write-Host "Script has finished running successfully. Made by Pandoras Box Tool ;-)"
Start-Sleep -Seconds 10
Restart-Computer
