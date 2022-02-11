chcp 65001

:Menu
cls
echo.
echo.
echo ---------------------- MENU ----------------------
echo /
echo / 0 - Sair
echo / 1 - All
echo / 2 - Desfragmentar
echo / 3 - Corrigir integridade da imagem do windows
echo / 4 - Corrigir integridade dos arquivos do Windows
echo /
echo --------------------------------------------------
echo.
set /p "menu=>"
IF %menu%==0 exit
IF %menu%==1 goto Defrag
IF %menu%==2 goto Defrag
IF %menu%==3 goto Integridade1
IF %menu%==4 goto Integridade2
goto menu

:Defrag
cls
echo.
echo.
echo.
echo - - - - Desfragmentação do Disco C: - - - -
echo.
echo processando...
echo.
defrag C: -W -F
echo.
echo Desfragmentação concluida!
timeout /t 5 /nobreak
IF %menu%==1 goto Integridade1
IF %menu%==2 goto Reiniciar

:Integridade1
cls
echo.
echo.
echo.
echo - - - - Verificação de integridade do windows - - - -
echo.
echo.
echo Iniciando Reparação de integridade da ISO do Windows (Passo 1)
echo processando...
DISM.exe /Online /Cleanup-image /Restorehealth
echo .............
echo.
echo (Passo 1) - finalizado
timeout /t 5 /nobreak
IF %menu%==1 goto Integridade2
IF %menu%==3 goto Reiniciar

:Integridade2
cls
echo.
echo.
echo.
echo Iniciando Verificação de Integridade dos Arquivos do Sistema (Passo 2)
echo processando...
SFC /SCANNOW
echo .............
echo.
echo (Passo 2) - finalizado
timeout /t 5 /nobreak
IF %menu%==1 goto Reiniciar
IF %menu%==4 goto Reiniciar

:Reiniciar
cls
echo.
echo.
echo.
echo O computador será reiniciado em 5 minutos, saia caso não queira reiniciar.
timeout /t 300 /nobreak
echo Shutdown -r -f -t 0 (não exucutado de proprósito)
timeout /t -1

