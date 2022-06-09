Set-Alias setup 'C:\Users\Canela\Geral\Setup.ps1'
$Module = $PSScriptRoot + '\Modules'
(Get-ChildItem -Path $Module -Include *.psm1 -Recurse).Fullname | % { Import-Module $_ -DisableNameChecking -Force }

