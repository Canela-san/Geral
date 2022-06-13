$Module = $PSScriptRoot + '\Modules'
(Get-ChildItem -Path $Module -Include *.psm1 -Recurse).Fullname | ForEach-Object { Import-Module $_ -DisableNameChecking -Force }
