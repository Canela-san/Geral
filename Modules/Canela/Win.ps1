
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
function Win {
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
        [switch]
        $a = $false, # Não Desligar nem reiniciar
    
        [Parameter(
            position = 5,    
            valueFromPipeline = $false,
            Mandatory = $false    
        )]
        [ValidateSet(-1, 1, 2)]
        [int]
        $HD, #Tipo de hardware, 1 - HD, 2 - SSD, -1 - cancelar
        
        [Parameter(
            position = 6,    
            valueFromPipeline = $false,
            Mandatory = $false    
        )]
        [ValidateSet(-1, 1, 2)]
        [int]
        $Verification = $false, #Tipo de verificação anti-virus, 1 - Rápida, 2 - Completa, 0 - Não verificar
        
        [Parameter(
            position = 7,    
            valueFromPipeline = $false,
            Mandatory = $false
        )]
        [int]
        $t = 0 #Tempo de espera antes de inciar as operações
    )

    begin {

        #Declarando Variáveis
        $defrag = @(1, 2)
        # $WinUpdate = 3
        $integridade1 = @(1, 4)
        $integridade2 = @(1, 5)
        $WindowsDefender = @(1, 6)
        $chkdsk = 7
        $Disk = 99
        $PlanoDeEnergia = 8
        $DrivesWeb = 9
        $Sysinfo = 10
        $Bluetooth = 11
        $adm = $true
        $log_ = ""
        # Configurando acentos e caracteres especiais.
        chcp 65001
        Clear-Host
        Write-Verbose "Executando em modo verbose. `n"
       
        # Verificando acesso adimistrativo 
        try {
            if (!([bool](([System.Security.Principal.WindowsIdentity]::GetCurrent()).groups -match "S-1-5-32-544"))) {
                Write-Host ""
                Write-Warning "-----------------------------------------------------------------------------`n`n"
                Write-Warning "Privilégios Insuficientes, execute como administrador"
                Write-Warning "Nenhum tipo de otimização pode ser realizada sem privilégios administrativos`n`n"
                Write-Warning "-----------------------------------------------------------------------------"
                $log_ = "* Privilégios Insuficientes, execute como administrador"
                $adm = $false
                timeout /t -1
                return
            }
        }
        catch {
            Write-Error "Não foi possível verificar os acessos administrativos, resultando no seguinte erro:"
            $_
            timeout /t -1
            return
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
        }
        # Coletandos dados necessários
        switch ($type) {
            # Caso o valor escolhido seja 0, o programa terminará.
            { $PSItem -eq -1 } { return }
            
            # Verificar se dispositivo é HD ou SSD 
            { (!$HD) -AND ($PSItem -in $defrag + $chkdsk) } {
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
                            $HD = $temp
                            $Temp_menu = $false
                        }
                    }
                }
            }
            # Selecionar o tipo de varificação anti-virus
            { (!$Verification) -AND ($PSItem -in $WindowsDefender) } {
                $Temp_menu = $true
                while ($Temp_menu) {
                    Clear-Host
                    write-host "`n`nQue tipo de verificação contra vírus você deseja?"
                    write-host " [1] Verificação Rápida"
                    write-host " [2] Verificação Completa"
                    write-host "`n [-1] Não verificar"
                    $temp = Read-Host -Prompt '-> '
                    Switch ($temp) { 
                        { $temp -in @(-1, 1, 2) } {
                            $Verification = $temp
                            $Temp_menu = $false
                        }
                    }
                }
            }
        }
        # menu para verificar reinicialização após execução
        $Temp_menu = $true
        if (!($r -or $s -or $a)) {
            while ($Temp_menu) {
                Clear-Host
                write-host "`n`nDeseja que o computador seja desligado ou reiniciado após a execução?"
                write-host " [S] Desligar"
                write-host " [R] Reiniciar"
                write-host "`n [-1] Não desligar nem reiniciar"
                $temp = Read-Host -Prompt '-> '
                switch ($temp) {
                    { $PSItem -eq -1 } {
                        $r = $false
                        $s = $false
                        $a = $true
                        $Temp_menu = $false
                    }
                    { $PSItem -in @("S", "s") } {
                        $r = $false
                        $s = $true
                        $a = $false
                        $Temp_menu = $false
                    }
                    { $PSItem -in @("R", "r") } {
                        $r = $true
                        $s = $false
                        $a = $false
                        $Temp_menu = $false
                    }
                }
            }
        }
        $data_i = Get-Date
        $log_ = "Processando: $type`nTipo de HD: $HD`nVerificação antivírus: $Verification`nReinicialização r, s, a: $r, $s, $a`n"
    }
    
    process {
        if (!$adm){return}
        if ($t) { timeout /t $t /nobreak }
        # Executaveis 
        Switch ($type) {

            # Caso o item seja 0, a função terminará 
            0 { return }
            { $PSItem -eq -1 } { return }
            { $PSItem -eq $Disk } { Get-PSDrive | Select-String “FileSystem” ; timeout /t -1 }
            { $PSItem -eq $Sysinfo } { Clear-Host ; Systeminfo ; timeout /t -1 }
            { $PSItem -eq $PlanoDeEnergia } { Clear-Host ; write-host "`n" ; powercfg -duplicatescheme e9a42b02-d5df-448d-aa00-03f14749eb61 ; timeout /t -1 }
            { $PSItem -eq $Bluetooth } {
                Restart-Service -Force bthserv
                Restart-Service -Force BTAGService
                Restart-Service -Force DevicesFlowUserSvc_a521d
                timeout /t 5 /nobreak
            }
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
            # Desfragmentar
            { ($PSItem -in $defrag) -AND !($HD -eq -1) } {
                if ($HD -eq 1) {
                    Clear-Host
                    write-host "`n`n`n - - - - Desfragmentação do Disco C: - - - -`n"
                    write-host " processando...`n"
                    $temp_date = Get-Date
                    $log_ = $log_ + "Desfragmentação Iniciada......."
                    defrag C: -W -F
                    write-host "`n Desfragmentação concluida!"
                    $log_ = $log_ + "Finalizada - (" +[string]((Get-Date) - $temp_date)+ ")`n"
                }
                else {
                    Clear-Host
                    write-host "`n`n`nDesfragmentação não será executada pois C: é um SSD."
                    write-host "É contra indicativo desfragmentar SSDs, é inutil e degrada a vida útil da peça."
                    write-host "Desfragmentar é indicado apenas em HDs (Hard Disks)."
                    write-host "`nA desfragmentação será pulada da execução."
                }
                timeout /t 5 /nobreak
            }
            #Integridade1
            { $PSItem -in $integridade1 } {
                $temp_date = Get-Date
                $log_ = $log_ + "Integridade 1 Iniciada......."
                Clear-Host
                write-host "`n`n`n - - - - Verificação de integridade do windows - - - -`n`n"
                write-host " Iniciando Reparação de integridade da ISO do Windows (Passo 1)"
                write-host " processando..."
                DISM /Online /Cleanup-Image /CheckHealth
                DISM /Online /Cleanup-Image /ScanHealth
                DISM /Online /Cleanup-image /Restorehealth
                DISM /Online /Cleanup-image /StartComponentCleanup
                write-host " .............`n"
                write-host " (Passo 1) - finalizado"
                $log_ = $log_ + "Finalizada - (" +[string]((Get-Date) - $temp_date)+ ")`n"
                timeout /t 5 /nobreak
            }
            #Integridade2
            { $PSItem -in $integridade2 } {
                $temp_date = Get-Date
                $log_ = $log_ + "Integridade 2 Iniciada......."
                Clear-Host
                write-host "`n`n`n Iniciando Verificação de Integridade dos Arquivos do Sistema (Passo 2)"
                write-host " processando..."
                SFC /SCANNOW
                write-host " .............`n"
                write-host " (Passo 2) - finalizado"
                $log_ = $log_ + "Finalizada - (" +[string]((Get-Date) - $temp_date)+ ")`n"
                timeout /t 5 /nobreak
            }
            #WindowsDefender
            { $PSItem -in $WindowsDefender } {
                if ($Verification -ne -1) {
                    $temp_date = Get-Date
                    Clear-Host
                    $log_ = $log_ + "Selecionando versão mais recente do windows defender......."
                    $CurrentPath = Get-Location
                    Set-Location "C:\Program Files\Windows Defender"
                    Get-ChildItem
                    Clear-Host
                    $log_ = $log_ + "Finalizado - (" +[string]((Get-Date) - $temp_date)+ ")`n"
                    write-host "`nScan Type: "$Verification"`n"
                    $temp_date = Get-Date
                    $log_ = $log_ + "Atualização de assinatura iniciada......."
                    .\mpcmdrun.exe -SignatureUpdate
                    $log_ = $log_ + "Finalizada - (" +[string]((Get-Date) - $temp_date)+ ")`n"
                    $temp_date = Get-Date
                    $log_ = $log_ + "Verificação antivirus tipo $Verification iniciada......."
                    .\mpcmdrun.exe -Scan -ScanType $Verification
                    $log_ = $log_ + "Finalizada - (" +[string]((Get-Date) - $temp_date)+ ")`n"
                    Set-Location $CurrentPath
                }
            }
            #chkdsk checagem de disco
            { $PSItem -in $chkdsk } {
                if ($HD -eq 1) {
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
                else {
                    clear-host
                    write-host "A checagem não será realizada em SSDs."
                }
            }
            Default {
                Write-Warning "A opção selecionada é inválida."
                Write-Warning "O programa será encerrado"
            }
        } 
    }

    end {
        Clear-Host
        $log_ = $log_ + "`nValores atribuidos a variáveis seletoras:
        type = $type
        HD = $HD
        r = $r
        s = $s
        a = $a
        adm = $adm
        log = $log
        data_i = $data_i
        Verification = $Verification
        "
        $log_ = "O processamento foi finalizado`nLog de execução:`n`nTempo total de execução:`n" + [string]((Get-Date) - $data_i) + "`n`n" + $log_
        $log_
        if ($log) { $log_ > C:\Users\Canela\Desktop\LOG.txt }
        #Reiniciar
        if (!$adm){return}
        if ($a){return}
        if ($r) {
            Clear-Host
            write-host "`n`n`n O computador será reiniciado em 15 segundos, feche caso não queira reiniciar.`n"
            timeout /t 15 /nobreak
            Shutdown -r -f -t 0
        }
        elseif ($s) {	      
            Clear-Host
            write-host "`n`n`n O computador será desligado em 15 segundos, feche caso não queira desligar.`n"
            timeout /t 15 /nobreak
            Shutdown -s -f -t 0
        }
    }
}

