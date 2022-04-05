chcp 65001

#Declarando Variáveis
$Temp_menu = $true
$quant_menu = 0..7
$defrag = 1,2
$WinUpdate = 1,3
$integridade1 = 1,4
$integridade2 = 1,5
$WindowsDefender = 1,6
$chkdsk = 7
$PlanoDeEnergia = 8
$DrivesWeb = 9
$Sysinfo = 10
$Bluetooth = 11
$reiniciar = $false
$date = Get-Date

#Testando Privilégios Administrativos
if (!([bool](([System.Security.Principal.WindowsIdentity]::GetCurrent()).groups -match"S-1-5-32-544")))
{
	Clear-Host
	Write-host "`n-----------------------------------------------------------------------------"
	Write-Host "`n`nPrivilégios Insuficientes, execute como administrador"
	Write-Host "Nenhum tipo de otimização pode ser realizada sem privilégios administrativos"
	Write-host "`n`n-----------------------------------------------------------------------------"
	timeout /t -1
	exit
}

#Menu
while($Temp_menu)
{
	Clear-Host
	write-host $date
	write-host "`n`n -------------------------- MENU --------------------------"
	write-host " "
	write-host "  [00] - Sair`n"
	write-host "  [01] - All (2,3,4,5,6)"
	write-host "  [02] - Desfragmentar"
	write-host "  [03] - Limpar Cache Windows Update"
	write-host "  [04] - Corrigir integridade da imagem do windows"
	write-host "  [05] - Corrigir integridade dos arquivos do Windows"
	write-host "  [06] - Verificação de vírus"
	write-host ""
	write-host "  [07] - Verificar e corrigir defeitos de disco"
	write-host "  [08] - Adicionar Plano de Energia (Desempenho Maximo)"
	write-host "  [09] - Abrir páginas WEB para atualizar Drives"
	write-host "  [10] - Verificar informações do sistema"
	write-host "  [11] - Recarregar módulos bluetooth"
	write-host " "
	write-host " ----------------------------------------------------------`n"


	$menu = Read-Host -Prompt '-> '
	
	Switch ($menu)
	{

		0 #Sair
		{
			Clear-Host
			Exit
		}

		{$PSItem -eq $PlanoDeEnergia}
                {
                        Clear-Host
			write-host "`n"
                        powercfg -duplicatescheme e9a42b02-d5df-448d-aa00-03f14749eb61
                        timeout /t -1
                }

		{$PSItem -eq $DrivesWeb}
                {
                        Clear-Host
                        write-host "`nAbrindo Abas Web:"
			write-host "  - Drive Boost"
			write-host "  - Chaves para Drive Boost"
			write-host "  - Nvidia GeForce Experience"
			Start-Process "https://www.iobit.com/pt/driver-booster.php"
			Start-Process "https://www.gustavortech.com/2020/04/iobit-driver-booster.html"
			Start-Process "https://www.nvidia.com/pt-br/geforce/geforce-experience/"
			timeout /t -1
                }

		{$PSItem -eq $Sysinfo}
		{
			Clear-Host
			Systeminfo
			timeout /t -1
		}

		{$PSItem -eq $Bluetooth}
		{
			Restart-Service -Force bthserv
			Restart-Service -Force BTAGService
			Restart-Service -Force DevicesFlowUserSvc_a521d
			timeout /t 5 /nobreak
		}

		{($PSItem -in $defrag) -or ($PSItem -in $chkdsk)}
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
					$PSItem = ""
					$Temp_menu_defrag = $false
				}
			}
		}

		{$PSItem -in $WindowsDefender}
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
					$PSItem = ""
					$Temp_menu_defender = $false
				}
			}
		}
		
		{$PSItem -in $WinUpdate}
		{
			if (!(Get-Module -ListAvailable -Name PSWindowsUpdate))
			{	
				$temp_WinUp = $true
				while($temp_WinUp)
				{
					Clear-Host
					write-host "`n`nWindows Update no powershell não instalado."
					write-host "Para atualizar o windows é necessário obte-lo."
					write-host "Deseja instalar Windows Update no Powershell? (Y)Sim (N)não"
                        		$R_temp = Read-Host -Prompt '-> '
                        		if (($R_temp -eq 'Y') -or ($R_temp -eq 'y'))
                        		{
                                		Install-module -Force -AcceptLicense -name PSWindowsUpdate
                       	        		$temp_WinUp = $false
					}
					elseif (($R_temp -eq 'N') -or ($R_temp -eq 'n'))
					{
						$temp_WinUp = $false
                       	                	write-host "A atualização do Windows será pulada"
						timeout /t -1
					}
				}
			}
		}

		{!($PSItem -eq "")}
		{
			if ($PSItem -in $quant_menu)
			{
				$Temp_menu = $false
				Clear-Host
				write-host "`n`nDeseja reiniciar o computador no final da execução? (Y)Sim (N)não (D)Desligar"
				$R_temp = Read-Host -Prompt '-> '
				if (($R_temp -eq 'Y') -or ($R_temp -eq 'y'))
				{
					$reiniciar = $true
				}
				elseif (($R_temp -eq 'N') -or ($R_temp -eq 'n'))
				{
					$reiniciar = $false
				}
				elseif (($R_temp -eq 'd') -or ($R_temp -eq 'D'))
				{
					$reiniciar = "Desligar"
				}
			}
			else
			{	
				$Temp_menu = $true
			}
		}
		
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

		#Windows Update
		{$PSItem -in $WinUpdate}
		{
			SC config wuauserv type= share
			SC config bits type= share
			SC config cryptsvc type= share
			SC config trustedinstaller type= share

			SC config wuauserv start= auto
			SC config bits start= auto
			SC config cryptsvc start= auto
			SC config trustedinstaller start= auto

			Stop-Service -Force bits
			Stop-Service -Force wuauserv
			Stop-Service -Force msiserver
			Stop-Service -Force cryptsvc
			Stop-Service -Force appidsvc			
			
			if (Test-Path 'C:\Windows\SoftwareDistribution.old')
                        {
				Remove-item -Force -recurse 'C:\Windows\SoftwareDistribution.old'
			}
			if (Test-Path 'C:\Windows\System32\catroot2.old')
                        {
                                Remove-item -Force -recurse 'C:\Windows\System32\catroot2.old'
                        }
			if (Test-Path 'C:\$Windows.~BT')
			{
				Remove-item -Force -recurse 'C:\$Windows.~BT'
			}
			
			ren C:\Windows\SoftwareDistribution SoftwareDistribution.old
			ren C:\Windows\System32\catroot2 Catroot2.old
			Del "C:\ProgramData\Microsoft\Network\Downloader\qmgr*.dat"

			ipconfig /flushdns
			ipconfig /Release
			ipconfig /Renew
			netsh winsock reset
			netsh winsock reset proxy
			netsh winhttp reset proxy

			rundll32.exe advapi32.dll,ProcessIdleTasks
			rundll32.exe pnpclean.dll,RunDLL_PnpClean /DRIVERS /MAXCLEAN

			 CMD /C "sc.exe sdset bits D:(A;;CCLCSWRPWPDTLOCRRC;;;SY)(A;;CCDCLCSWRPWPDTLOCRSDRCWDWO;;;BA)(A;;CCLCSWLOCRRC;;;AU)(A;;CCLCSWRPWPDTLOCRRC;;;PU)"

			 CMD /C "sc.exe sdset wuauserv D:(A;;CCLCSWRPWPDTLOCRRC;;;SY)(A;;CCDCLCSWRPWPDTLOCRSDRCWDWO;;;BA)(A;;CCLCSWLOCRRC;;;AU)(A;;CCLCSWRPWPDTLOCRRC;;;PU)"

			regsvr32.exe /s /s atl.dll
			regsvr32.exe /s /s urlmon.dll
			regsvr32.exe /s /s mshtml.dll
			regsvr32.exe /s /s shdocvw.dll
			regsvr32.exe /s /s browseui.dll
			regsvr32.exe /s /s jscript.dll
			regsvr32.exe /s /s vbscript.dll
			regsvr32.exe /s scrrun.dll
			regsvr32.exe /s msxml.dll
			regsvr32.exe /s msxml3.dll
			regsvr32.exe /s msxml6.dll
			regsvr32.exe /s actxprxy.dll
			regsvr32.exe /s softpub.dll
			regsvr32.exe /s wintrust.dll
			regsvr32.exe /s dssenh.dll
			regsvr32.exe /s rsaenh.dll
			regsvr32.exe /s gpkcsp.dll
			regsvr32.exe /s sccbase.dll
			regsvr32.exe /s slbcsp.dll
			regsvr32.exe /s cryptdlg.dll
			regsvr32.exe /s oleaut32.dll
			regsvr32.exe /s ole32.dll
			regsvr32.exe /s shell32.dll
			regsvr32.exe /s initpki.dll
			regsvr32.exe /s wuapi.dll
			regsvr32.exe /s wuaueng.dll
			regsvr32.exe /s wuaueng1.dll
			regsvr32.exe /s wucltui.dll
			regsvr32.exe /s wups.dll
			regsvr32.exe /s wups2.dll
			regsvr32.exe /s wuweb.dll
			regsvr32.exe /s qmgr.dll
			regsvr32.exe /s qmgrprxy.dll
			regsvr32.exe /s wucltux.dll
			regsvr32.exe /s muweb.dll
			regsvr32.exe /s wuwebv.dll

			Start-Service bits
			Start-Service wuauserv
			Start-Service msiserver
			Start-Service cryptsvc
			Start-Service appidsvc
		
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
			DISM /Online /Cleanup-image /Restorehealth
			dism /Online /Cleanup-image /StartComponentCleanup
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
	if ($Reiniciar -eq $true)
	{
		Clear-Host
		write-host "`n`n`n O computador será reiniciado em 15 segundos, feche caso não queira reiniciar.`n"
		timeout /t 15 /nobreak
		Shutdown -r -f -t 0
	}
	elseif ($Reiniciar -eq "Desligar")
	{	      
		Clear-Host
	        write-host "`n`n`n O computador será reiniciado em 15 segundos, feche caso não queira reiniciar.`n"
        	timeout /t 15 /nobreak
        	Shutdown -s -f -t 0
	}
}
