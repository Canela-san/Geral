Set-Alias update Git-Update
Function Git-Update {
cls
write-host "------- Atualizando a pasta .config ------- `n"
$SourcePath = 'C:\Users\Canela\.config'
$DestinationPath = 'C:\Users\Canela\Geral\.config'
robocopy $SourcePath $DestinationPath /E
write-host "`n Atualizado com sucesso `n`n"
write-host " ------ Atualizando Repositorio Github ------ `n`n"
write-host " - git add . `n"
git add .
write-host "`n - git commit -m 'Sem descrição' `n"
git commit -m "Sem descrição"
write-host "`n - git push -u origin main `n"
git push -u origin main
write-host ""
pause
}