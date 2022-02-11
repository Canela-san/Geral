cls
write-host "------- Atualizando a pasta .config ------- `n"
$SourcePath = 'C:\Users\Canela\.config'
$DestinationPath = 'C:\Users\Canela\Geral\.config'
robocopy $SourcePath $DestinationPath /E
write-host "`n Atualizado com sucesso `n`n"
write-host " ------ Atualizando Repositorio Github ------ `n`n"
write-host " - git add . `n"
git add .
write-host ""
write-host " - git commit -m 'Sem descrição' "
write-host ""
git commit -m "Sem descrição"
write-host ""
write-host " - git push -u origin main "
write-host ""
git push -u origin main
write-host ""
pause
