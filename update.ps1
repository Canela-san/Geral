cls
echo ------- Atualizando a pasta .config -------
echo.
$SourcePath = 'C:\Users\Canela\.config'
$DestinationPath = 'C:\Users\Canela\Geral\.config'
robocopy $SourcePath $DestinationPath /E
echo.
echo Atualizado com sucesso
echo.
echo.
echo ------ Atualizando Repositorio Github ------
echo.
echo.
echo - git add .
echo.
git add .
echo.
echo - git commit -m "Sem descrição"
echo.
git commit -m "Sem descrição"
echo.
echo - git push -u origin main
echo.
git push -u origin main
echo.
pause
