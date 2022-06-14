Set-Alias GeralUp Update-GeralGit
$projectName = 'Geral'
Function Update-GeralGit {
    $currentPath = (Get-Location).path
    $projectPath = $PSScriptRoot.Substring(0,$PSScriptRoot.LastIndexOf($projectName)+$projectName.Length)
    Set-Location $projectPath
    write-host " ------ Atualizando Repositorio Github ------ `n`n"
    write-host " - git add . `n"
    git add .
    write-host "`n - git commit -m 'Sem descrição' `n"
    git commit -m "Sem descrição"
    write-host "`n - git push -u origin main `n"
    git push -u origin main
    write-host ""
    Set-Location $currentPath
    Get-Location
    pause
}
