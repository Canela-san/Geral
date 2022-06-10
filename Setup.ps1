$Module = $PSScriptRoot + '\Modules'
(Get-ChildItem -Path $Module -Include *.psm1 -Recurse).Fullname | % { Import-Module $_ -DisableNameChecking -Force }

