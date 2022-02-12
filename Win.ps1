chcp 65001

#Menu
$Temp_menu = $true
$quant_menu = 0..4
$defrag = 1,2
$integridade1 = 1,3
$integridade2 = 1,4
$reiniciar = $true
while($Temp_menu)
{
	cls
	write-host "`n`n ---------------------- MENU ----------------------"
	write-host " /"
	write-host " / 0 - Sair"
	write-host " / 1 - All"
	write-host " / 2 - Desfragmentar"
	write-host " / 3 - Corrigir integridade da imagem do windows"
	write-host " / 4 - Corrigir integridade dos arquivos do Windows"
	write-host " /"
	write-host " --------------------------------------------------`n"


	$menu = Read-Host -Prompt '-> '
	
	if ($menu -in $quant_menu)
	{
		$Temp_menu = $false
	} else {
		$Temp_menu = $true
	}
}

Switch ($menu){

	#Sair (0)
	0 
	{ 
		exit 
	}

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
	write-host "`n`n`n O computador será reiniciado em 5 minutos, saia caso não queira reiniciar."
	timeout /t 300 /nobreak
	write-host " Shutdown -r -f -t 0 (não exucutado de proprósito)"
	timeout /t -1
}
