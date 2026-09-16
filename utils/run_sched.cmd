@echo off
chcp 65001 >nul
start "" powershell -NoProfile -ExecutionPolicy Bypass -File "C:\Users\User\Documents\1c\WeKings\utils\click4.ps1" > "C:\Users\User\Documents\1c\WeKings\utils\click4_log.txt" 2>&1
"C:\Program Files (x86)\1cv8t\8.3.27.1508\bin\1cv8t.exe" ENTERPRISE /F"C:\Bases\InfoBase2" /DisableStartupDialogs /DisableStartupMessages /Execute "C:\Bases\mini.epf" /Out "C:\Users\User\Documents\1c\WeKings\utils\run_mini_log.txt"
echo EXITCODE=%ERRORLEVEL%
