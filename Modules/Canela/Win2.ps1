
<#
.SYNOPSIS
    Do optimisation on the computer. there's several actions to be chosen.
.DESCRIPTION
    Console-oriented configurantions and repair of windows 10.
.EXAMPLE
    Win
    Invoke the main menu.
.EXAMPLE
    Win 1
    Begin the desfragmentation process without showing the menu.
.EXAMPLE
    Get-Weather -City 'London' -Units Metric -Language 'en'
    Returns full weather information for the city of London in Metric units with UK language.
.EXAMPLE
    Get-Weather -City 'San Antonio' -Units USCS -Short
    Returns basic weather information for the city of San Antonio in United State customary units.
.PARAMETER City
    The city you would like to get the weather from. If not specified the city of your IP is used.
.PARAMETER Units
    Units to display Metric vs United States customary units
.PARAMETER Language
    Language to display results in
.PARAMETER Short
    Will return only basic weather information
.NOTES
    https://github.com/chubin/wttr.in
    https://wttr.in/:help
#>
function JAO {
    [CmdletBinding()]
    param (
        [Parameter(
            position = 0,    
            valueFromPipeline = $true,
            Mandatory = $false
        )]
        [int[]]
        $type,

        [Parameter(
            position = 1,    
            valueFromPipeline = $false,
            Mandatory = $false
        )]
        [switch]
        $Log = $false,
        
        [Parameter(
            position = 2,    
            valueFromPipeline = $false,
            Mandatory = $false
        )]
        [switch]
        $r = $false, #Reiniciar
    
        [Parameter(
            position = 3,    
            valueFromPipeline = $false,
            Mandatory = $false
        )]
        [switch]
        $s = $false, #Desligar
    
        [Parameter(
            position = 4,    
            valueFromPipeline = $false,
            Mandatory = $false    
        )]
        [ValidateSet(0, 1, 2)]
        [int]
        $TypeDefrag = 0, #Tipo de hardware, 1 - HD, 2 - SSD, 0 - cancelar
        
        [Parameter(
            position = 5,    
            valueFromPipeline = $false,
            Mandatory = $false    
        )]
        [ValidateSet(0, 1, 2)]
        [int]
        $TypeDefender = 0, #Tipo de verificação anti-virus, 1 - Rápida, 2 - Completa, 0 - Não verificar
        
        [Parameter(
            position = 6,    
            valueFromPipeline = $false,
            Mandatory = $false
        )]
        [int]
        $t = 0 #Tempo de espera antes de inciar as operações
    )

    begin {

        #Declarando Variáveis
        $defrag = @(1, 2)
        $WinUpdate = 3
        $integridade1 = @(1, 4)
        $integridade2 = @(1, 5)
        $WindowsDefender = @(1, 6)
        $chkdsk = 7
        $Disk = 99
        $PlanoDeEnergia = 8
        $DrivesWeb = 9
        $Sysinfo = 10
        $Bluetooth = 11

        # Configurando acentos e caracteres especiais.
        chcp 65001
        Clear-Host
        Write-Verbose "Executando em modo verbose. `n"
       
        # Verificando acesso adimistrativo 
        try {
            if (!([bool](([System.Security.Principal.WindowsIdentity]::GetCurrent()).groups -match "S-1-5-32-544"))) {
                Write-Warning "`n-----------------------------------------------------------------------------"
                Write-Warning "`n`nPrivilégios Insuficientes, execute como administrador"
                Write-Warning "Nenhum tipo de otimização pode ser realizada sem privilégios administrativos"
                Write-Warning "`n`n-----------------------------------------------------------------------------"
                timeout /t -1
                return;
            }
        }
        catch {
            Write-Error "Não foi possível verificar os acessos administrativos, resultando no seguinte erro:"
            $_
            timeout /t -1
            exit
        }

        # Invocando o menu se não houveram entradas no parametro $type
        if (!$type) {
            #Menu
            $Temp_menu = $true
            while ($Temp_menu) {
                Clear-Host
                write-host ""
                Get-Date
                write-host "`n"
                write-host " -------------------------- MENU --------------------------"
                write-host " "
                write-host "  [-1] - Sair`n"
                write-host "  [01] - All (2,3,4,5,6)"
                write-host "  [02] - Desfragmentar"
                Write-Host "  [03] - Limpar Cache Windows Update"
                Write-Host "  [04] - Corrigir integridade da imagem do windows"
                Write-Host "  [05] - Corrigir integridade dos arquivos do Windows"
                Write-Host "  [06] - Verificação de vírus"
                Write-Host ""
                Write-Host "  [07] - Verificar e corrigir defeitos de disco"
                Write-Host "  [08] - Adicionar Plano de Energia (Desempenho Maximo)"
                write-host "  [09] - Abrir páginas WEB para atualizar Drives"
                write-host "  [10] - Verificar informações do sistema"
                write-host "  [11] - Recarregar módulos bluetooth"
                write-host " "
                write-host " ----------------------------------------------------------`n"

                $type = Read-Host -Prompt '-> '
                switch ($type) {
                    0 { break }
                    { $PSItem -eq -1 } { return }
                    { $PSItem -in @(1..11) } { $Temp_menu = $false }
                }
            } 

            # Coletandos dados necessários
            switch ($type) {
                # Caso o valor escolhido seja 0, o programa terminará.
                { $PSItem -eq -1 } { return }
                
                # Verificar se dispositivo é HD ou SSD 
                { (!$TypeDefrag) -AND ($PSItem -in $defrag + $chkdsk) } {
                    $Temp_menu = $true
                    while ($temp_menu) {
                        Clear-Host
                        write-host "`n`nO diretório C: é um HD ou SSD?"
                        write-host " [1] HD (Hard Disk)"
                        write-host " [2] SSD`n"
                        write-host " [-1] Não desfragmentar"
                        $temp = Read-Host -Prompt '-> '
                        Switch ($temp) { 
                            { $temp -in @(-1, 1, 2) } {
                                $TypeDefender = $temp
                                $Temp_menu = $false
                            }
                        }
                    }
                }
                # Selecionar o tipo de varificação anti-virus
                { (!$TypeDefender) -AND ($PSItem -in $WindowsDefender) } {
                    $Temp_menu = $true
                    while ($Temp_menu) {
                        Clear-Host
                        write-host "`n`nQue tipo de verificação contra vírus você deseja?"
                        write-host " [1] Verificação Rápida"
                        write-host " [2] Verificação Completa`n"
                        write-host "`n [-1] Não verificar"
                        $temp = Read-Host -Prompt '-> '
                        Switch ($temp) { 
                            { $temp -in @(-1, 1, 2) } {
                                $TypeDefender = $temp
                                $Temp_menu = $false
                            }
                        }
                    }
                }
                

                # $log = $true para salvar na area de trabalho 
                { $true } {
                    
                }

                { $true } {
                    
                }

                Default {}
            }
        }
        else { $Temp_menu = $false }
    
    }
    
    process {
        if ($t) { timeout /t $t /nobreak }
        if ($log) { $log = 123 }
        # Executaveis 
        Switch ($type) {

            # Caso o item seja 0, a função terminará 
            0 { return }
            { $PSItem -eq -1 } { return }
            { $PSItem -eq $Disk } { Get-PSDrive | Select-String “FileSystem” ; timeout /t -1 }
            { $PSItem -eq $Sysinfo } { Clear-Host ; Systeminfo ; timeout /t -1 }
            { $PSItem -eq $PlanoDeEnergia } { Clear-Host ; write-host "`n" ; powercfg -duplicatescheme e9a42b02-d5df-448d-aa00-03f14749eb61 ; timeout /t -1 }
            { $PSItem -eq $DrivesWeb } {
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
            
            { $TRUE } {
                Write-Host '123'
            }
            { $TRUE } {
                Write-Host '123'
            }
            { $TRUE } {
                Write-Host '123'
            }
            Default {
                Write-Warning "A opção selecionada é inválida."
                Write-Warning "O programa será encerrado"
            }
        }
        
    }

    end {
        Clear-Host
        Write-Host 'O processamento foi finalizado'
        Write-Host 'Log de execução:'
        $log_
    }
}

jao