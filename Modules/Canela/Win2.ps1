
function JAO {
    [CmdletBinding()]
    param (
        [Parameter(
            position = 0,    
            valueFromPipeline = $true,
            Mandatory = $false
        )]
        [int[]]
        $menu
    )
    
    begin {
        # Verificando se houve entradas em menu
        if (!$menu) {
            $menu = $FALSE
        }
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

        # Invocando o menu se não houveram entradas no parametro $menu
        
        if (!$menu) {
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

                $menu = Read-Host -Prompt '-> '
            }

        }
    }
    
    process {
        Executaveis 
        Switch ($menu) {
            # 
            { !$PSItem } {
                Write-Host '123'
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
            Default {}
        }
        
    }

    end {

    }
}