chcp 65001

#Declarando Variáveis
$Temp_menu = $true
$quant_menu = 0..5
$defrag = 1,2
$integridade1 = 1,3
$integridade2 = 1,4
$WindowsDefender = 5
$reiniciar = $true
$date = Get-Date

#Menu
while($Temp_menu)
{
	Clear-Host
	write-host $date
	write-host "`n`n ---------------------- MENU ----------------------"
	write-host " "
	write-host "  [0] - Sair"
	write-host "  [1] - All {2,3,4}"
	write-host "  [2] - Desfragmentar"
	write-host "  [3] - Corrigir integridade da imagem do windows"
	write-host "  [4] - Corrigir integridade dos arquivos do Windows"
	write-host "  [5] - Verificação de vírus (em manutenção)"
	write-host " "
	write-host " --------------------------------------------------`n"


	$menu = Read-Host -Prompt '-> '
	
	#Sair
	if ($menu -eq 0)
	{
		Exit
	}
	if ($menu -eq 5)
    {
    	$Temp_menu_defender = $true
		while($Temp_menu_defender)
		{
			Clear-Host
			write-host "`nQue tipo de verificação você deseja?"
			write-host " [1] Verificação Rápida"
			write-host " [2] Verificação Completa`n"
			write-host " [0] Cancelar"
            $TypeDefender = Read-Host -Prompt '-> '
            if ($TypeDefender -in 1,2)
        	{
				$Temp_menu_defender = $false
			}
			elseif ($TypeDefender -eq 0)
			{
				$menu = ""
				$Temp_menu_defender = $false
			}
		}
	}
	if (!($menu -eq ""))
	{
		if ($menu -in $quant_menu)
		{
			$Temp_menu = $false
			write-host "`nDeseja reiniciar o computador no final da execução? (Y) ou (N)"
            $R_temp = Read-Host -Prompt '-> '
			if (($R_temp -eq 'Y') -or ($R_temp -eq 'y'))
            {
				$reiniciar = $true
            }
			elseif (($R_temp -eq 'N') -or ($R_temp -eq 'n'))
			{
				$reiniciar = $false
			}
		}
		else
		{
            $Temp_menu = $true
        }
	}
}

Switch ($menu){
	
	#Desfragmentação (1, 2)
	{$PSItem -in $defrag}
	{
		Clear-Host
		write-host "`n`n`n - - - - Desfragmentação do Disco C: - - - -`n"
		write-host " processando...`n"
		defrag C: -W -F
		write-host "`n Desfragmentação concluida!"
		timeout /t 5 /nobreak
	}

	#Integridade1
	{$PSItem -in $integridade1}
	{
		Clear-Host
		write-host "`n`n`n - - - - Verificação de integridade do windows - - - -`n`n"
		write-host " Iniciando Reparação de integridade da ISO do Windows (Passo 1)"
		write-host " processando..."
		DISM.exe /Online /Cleanup-image /Restorehealth
		write-host " .............`n"
		write-host " (Passo 1) - finalizado"
		timeout /t 5 /nobreak
	}

	#Integridade2
	{$PSItem -in $integridade2}
	{
		Clear-Host
		write-host "`n`n`n Iniciando Verificação de Integridade dos Arquivos do Sistema (Passo 2)"
		write-host " processando..."
		SFC /SCANNOW
		write-host " .............`n"
		write-host " (Passo 2) - finalizado"
		timeout /t 5 /nobreak
	}

	#WindowsDefender
	{$PSItem -in $WindowsDefender}
	{
		Clear-Host
		$CurrentPath = pwd
		Set-Location "C:\Program Files\Windows Defender"
		Get-ChildItem
		Clear-Host
		write-host "`nScan Type: "$TypeDefender"`n"
		.\mpcmdrun.exe -SignatureUpdate
		.\mpcmdrun.exe -Scan -ScanType $TypeDefender
		Set-Location $CurrentPath
	}
}

#Reiniciar
if ($Reiniciar)
{
	Clear-Host
	write-host "`n`n`n O computador será reiniciado em 15 segundos, feche caso não queira reiniciar.`n"
	timeout /t 15 /nobreak
	Shutdown -r -f -t 0
}
