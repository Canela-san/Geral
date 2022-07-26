@echo off
echo.
echo Permitindo a execução de scripts powershell...
echo.
echo Configuração atual de permição para scripts:
Get-ExecutionPolicy
echo.
echo A regra será alterada para 'unrestricted'
Set-ExecutionPolicy unrestricted
echo.
echo finalizado.
exit