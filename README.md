# WindowsClickShareWindowsIconIssuePatch
Windows ClickShare Windows Icon Issue Patch

Please execute this shell file on the PC in Powershell 
with .\PatchFileThatWillWorking.ps1
If PatchFileThatWillWorking does not work try PatchFileThatWillWorking2
.\PatchFileThatWillWorking2.ps1

The script fixes the following error pattern:
Taskbar without function, 
Windows icon without function, 
Windows calendar without function in the taskbar, 
Right click on icons in the taskbar without function 

The error comes from ClickShare because in the registry important keys are deleted because of Windows Defender Deep Scan win32k.exe

The second version is for when the first one didn't work because the second version reinstalls shell folder permissions for all users.

More information and origin of the main script can be found in the following link:

https://www.barco.com/en/support/knowledge-base/6077-unresponsive-windows-taskbar-with-clickshare-app
