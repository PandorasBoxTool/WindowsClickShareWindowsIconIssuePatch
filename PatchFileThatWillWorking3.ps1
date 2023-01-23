#Kill explorer
Stop-Process -Name explorer

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

Get-AppXPackage -AllUsers | Foreach {Add-AppxPackage -DisableDevelopmentMode -Register "$($_.InstallLocation)\AppXManifest.xml"}

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

#Fix the Effectet Regedit
Get-AppXPackage | Foreach {Add-AppxPackage -DisableDevelopmentMode -Register "C:\Windows\SystemApps\Microsoft.Windows.Search_cw5n1h2txyewy\AppXManifest.xml"}
Get-AppxPackage | Foreach {Add-AppxPackage -DisableDevelopmentMode -Register "C:\Windows\SystemApps\ShellExperienceHost_cw5n1h2txyewy\AppXManifest.xml"}
Get-AppXPackage | Foreach {Add-AppxPackage -DisableDevelopmentMode -Register "C:\Windows\SystemApps\MicrosoftWindows.Client.CBS_cw5n1h2txyewy\AppXManifest.xml"}
if (-not (Get-AppxPackage Microsoft.AAD.BrokerPlugin)) { Add-AppxPackage -Register "$env:windir\SystemApps\Microsoft.AAD.BrokerPlugin_cw5n1h2txyewy\Appxmanifest.xml" -DisableDevelopmentMode -ForceApplicationShutdown } Get-AppxPackage Microsoft.AAD.BrokerPlugin
if (-not (Get-AppxPackage Microsoft.Windows.CloudExperienceHost)) { Add-AppxPackage -Register "$env:windir\SystemApps\Microsoft.Windows.CloudExperienceHost_cw5n1h2txyewy\Appxmanifest.xml" -DisableDevelopmentMode -ForceApplicationShutdown } Get-AppxPackage Microsoft.Windows.CloudExperienceHost
Start-Process explorer.exe

Start-Process "ResetWindowsSearchBox.ps1" 

taskbar/explorer 
start/search/o365 auth/registration
Write-Host "Script has finished running successfully. Made by Pandoras Box Tool ;-)"
Start-Sleep -Seconds 10
#Restart-Computer
