chcp 65001

#Declarando Variáveis
$Temp_menu = $true
$quant_menu = 0..4
$defrag = 1,2
$integridade1 = 1,3
$integridade2 = 1,4
$reiniciar = $true
$date     = Get-Date

#Menu
while($Temp_menu)
{
	cls
	write-host $date
	write-host "`n`n ---------------------- MENU ----------------------"
	write-host " /                               "
	write-host " / 0 - Sair"
	write-host " / 1 - All [2,3,4]"
	write-host " / 2 - Desfragmentar"
	write-host " / 3 - Corrigir integridade da imagem do windows"
	write-host " / 4 - Corrigir integridade dos arquivos do Windows"
	write-host " / 5 - Verificação de vírus (em manutenção)"
	write-host " /"
	write-host " --------------------------------------------------`n"


	$menu = Read-Host -Prompt '-> '
	
	#Sair
	if ($menu -eq 0)
	{
		Exit
	}
	elseif (!($menu -eq ""))
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
        	} else {
                	$Temp_menu = $true
        	}
	}
}

Switch ($menu){
	
	#Desfragmentação (1, 2)
	{$PSItem -in $defrag}
	{
		cls
		write-host "`n`n`n - - - - Desfragmentação do Disco C: - - - -`n"
		write-host " processando...`n"
		defrag C: -W -F
		write-host "`n Desfragmentação concluida!"
		timeout /t 5 /nobreak
	}

	#Integridade1
	{$PSItem -in $integridade1}
	{
		cls
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
		cls
		write-host "`n`n`n Iniciando Verificação de Integridade dos Arquivos do Sistema (Passo 2)"
		write-host " processando..."
		SFC /SCANNOW
		write-host " .............`n"
		write-host " (Passo 2) - finalizado"
		timeout /t 5 /nobreak
	}
}

#Reiniciar
if ($Reiniciar)
{
	cls
	write-host "`n`n`n O computador será reiniciado em 15 segundos, feche caso não queira reiniciar.`n"
	timeout /t 15 /nobreak
	Shutdown -r -f -t 0
}
