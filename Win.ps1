chcp 65001

#Declarando Variáveis
$Temp_menu = $true
$quant_menu = 0..6
$defrag = 1,2
$integridade1 = 1,3
$integridade2 = 1,4
$WindowsDefender = 1,5
$chkdsk = 6
$Sysinfo = 7
$reiniciar = $true
$date = Get-Date

#Menu
while($Temp_menu)
{
	Clear-Host
	write-host $date
	write-host "`n`n ---------------------- MENU ----------------------"
	write-host " "
	write-host "  [0] - Sair`n"
	write-host "  [1] - All (2,3,4,5)"
	write-host "  [2] - Desfragmentar"
	write-host "  [3] - Corrigir integridade da imagem do windows"
	write-host "  [4] - Corrigir integridade dos arquivos do Windows"
	write-host "  [5] - Verificação de vírus (em manutenção)"
	write-host "  [6] - Verificar e corrigir defeitos de disco"
	write-host "`n  [7] - Verificar informações do sistema"
	write-host " "
	write-host " --------------------------------------------------`n"


	$menu = Read-Host -Prompt '-> '
	
	#Sair
	if ($menu -eq 0)
	{
		Exit
	}
	if ($menu -eq $Sysinfo)
	{
		Clear-Host
		Systeminfo
		timeout /t -1
	}

	if (($menu -in $defrag) -or ($menu -in $chkdsk))
	{
		$temp_menu_defrag = $true
		while($temp_menu_defrag)
		{
			Clear-Host
        		write-host "`n`nO diretório C: é um HD ou SSD?"
			write-host " [1] HD (Hard Disk)"
			write-host " [2] SSD`n"
			write-host " [0] Cancelar"
			
			$TypeDefrag = Read-Host -Prompt '-> '
                        
			if ($TypeDefrag -in 1,2)
                        {
                                $Temp_menu_defrag = $false
                        }
                        elseif ($TypeDefrag -eq 0)
                        {
                                $menu = ""
                                $Temp_menu_defrag = $false
                        }
		}
	}

	if ($menu -in $WindowsDefender)
   	{
    		$Temp_menu_defender = $true
		while($Temp_menu_defender)
		{
			Clear-Host
			write-host "`n`nQue tipo de verificação contra vírus você deseja?"
			write-host " [1] Verificação Rápida"
			write-host " [2] Verificação Completa`n"
			write-host " [3] Não verificar"
			write-host " [0] Cancelar"
            		$TypeDefender = Read-Host -Prompt '-> '
            		if ($TypeDefender -in 1,2,3)
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
			Clear-Host
			write-host "`n`nDeseja reiniciar o computador no final da execução? (Y) ou (N)"
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
		if ($TypeDefrag -eq 1)
		{
			Clear-Host
			write-host "`n`n`n - - - - Desfragmentação do Disco C: - - - -`n"
			write-host " processando...`n"
			defrag C: -W -F
			write-host "`n Desfragmentação concluida!"
		}
		else
		{
			Clear-Host
			write-host "`n`n`nDesfragmentação não será executada pois C: é um SSD."
			write-host "É contra indicativo desfragmentar SSDs, é inutil e degrada a vida útil da peça."
			write-host "Desfragmentar é indicado apenas em HDs (Hard Disks)."
			write-host "`nA desfragmentação será pulada da execução."
		}
		timeout /t 5 /nobreak
	}

	#Integridade1
	{$PSItem -in $integridade1}
	{
		Clear-Host
		write-host "`n`n`n - - - - Verificação de integridade do windows - - - -`n`n"
		write-host " Iniciando Reparação de integridade da ISO do Windows (Passo 1)"
		write-host " processando..."
		DISM /Online /Cleanup-Image /CheckHealth
		DISM /Online /Cleanup-Image /ScanHealth
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
		if (!($TypeDefender -eq 3)){
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

	#chkdsk checagem de disco
	{$PSItem -in $chkdsk}
	{
		if ($TypeDefrag -eq 1)
		{
			Clear-Host
			write-host "`n`n---- Leia as instruções a baixo ----`n"
			write-host "--A Checagem de disco é demorada e necessita reiniciar."
			write-host "--O computador não poderá ser utilizado enquando a manutenção é realizada"
			write-host "--O computador não pode ser desligado durante a manutenção"
			write-host "--Caso seja desligado, o disco pode sofrer corrupções, e será necessário começar a verificação do zero"
			write-host "--O tempo estimado é 4 horas a cada 500 GBs corrigidos."
			write-host "--Caso deseje cancelar, Digite 'N' para a pergunta a seguir:`n`n"
			chkdsk C: /f /r
		}
		else
		{
			clear-host
			write-host "A checagem não será realizada em SSDs."
		}
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
