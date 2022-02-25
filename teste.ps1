if (Get-Module -ListAvailable -Name PSWindowsUpdate)
{
	Write-Host "Module exists"
}
else
{
	write-host "Windows Update no powershell não instalado, proceguindo com instalação"
	Install-module -Force -AcceptLicense -name PSWindowsUpdate
}
