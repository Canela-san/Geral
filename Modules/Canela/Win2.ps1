
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
        $Log = $false
    )

    begin {

        #Declarando Variáveis
        $Temp_menu = $true
        $quant_menu = 0..7
        $defrag = 1, 2
        $WinUpdate = 3
        $integridade1 = 1, 4
        $integridade2 = 1, 5
        $WindowsDefender = 1, 6
        $chkdsk = 7
        $Disk = 99
        $PlanoDeEnergia = 8
        $DrivesWeb = 9
        $Sysinfo = 10
        $Bluetooth = 11
        $reiniciar = $false
        $date = Get-Date

        # Verificando se houve entradas em type
        if (!$type) {
            $type = $FALSE
        }

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
                exit
            }
        }
        catch {
            Write-Error "Não foi possível verificar os acessos administrativos, resultando do seguinte erro:"
            $_
            timeout /t -1
            exit
        }

        # Invocando o menu se não houveram entradas no parametro $type
        
        if (!$type) {
            #Menu
            while ($Temp_menu) {
                Clear-Host
                write-host $date
                write-host "`n"
                write-host " -------------------------- MENU --------------------------"
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

                $type = Read-Host -Prompt '-> '
                
                if ($type -in $quant_menu) { $Temp_menu = $false }
            }
            # $log = $true para salvar na area de trabalho 
        }
        else { $Temp_menu = $false }
    
    }
    
    process {
        $Log_ = $true

        # Executaveis 
        Switch ($type) {

            # Caso o item seja 0, a função terminará 
            { !$PSItem } {
                Write-Host "O programa será encerrado por escolha do usuário"
                break
            }
            { $PSItem -eq $Disk } {
                Get-PSDrive | Select-String “FileSystem”
                pause
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

    }
}