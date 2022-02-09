@echo off
chcp 65001
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
echo.
echo.
echo.
echo. Iniciando Verificação de Integridade dos Arquivos do Sistema (Passo 2)
echo processando...
SFC /SCANNOW
echo .............
echo.
echo (Passo 2) - finalizado
timeout /t 5 /nobreak
echo.
echo.
echo.
echo O computador será reiniciado em 5 minutos, saia caso não queira reiniciar.
timeout /t 300 /nobreak
echo Shutdown -r -f -t 0 (não exucutado de proprósito)
timeout /t -1