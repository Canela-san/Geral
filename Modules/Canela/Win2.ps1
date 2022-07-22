

function JAO {
    [CmdletBinding()]
    param (
        [Parameter(valueFromPipeline)]
        [int[]] $menu
    )
    if (!$menu) {
        $menu = $FALSE
    }
    chcp 65001
    Clear-Host
    Write-Verbose "Executando em modo verbose. `n"

    # Verificando privilégio administrativos
    if (!([bool](([System.Security.Principal.WindowsIdentity]::GetCurrent()).groups -match "S-1-5-32-544"))) {
        Clear-Host
        Write-Error "`n-----------------------------------------------------------------------------"
        Write-Error "`n`nPrivilégios Insuficientes, execute como administrador"
        Write-Error "Nenhum tipo de otimização pode ser realizada sem privilégios administrativos"
        Write-Error "`n`n-----------------------------------------------------------------------------"
        timeout /t -1
        exit
    }

    # Repetição global
    While (Menu>0) {
        # Menu
    
        #Executaveis 
        Switch ($menu) {
            # 
            { $PSItem -eq $Disk } {
                Get-PSDrive | Select-String “FileSystem”
				pause
            }
            { !$PSItem } {
                Write-Host '123'
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
}