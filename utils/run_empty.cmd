@echo off
chcp 65001 >nul
"C:\Program Files (x86)\1cv8t\8.3.27.1508\bin\1cv8t.exe" CREATEINFOBASE File="C:\Bases\TestEmpty" /Out "C:\Users\User\Documents\1c\WeKings\utils\create_empty_log.txt" /DisableStartupDialogs /DisableStartupMessages
echo CREATE_EXITCODE=%ERRORLEVEL%
"C:\Program Files (x86)\1cv8t\8.3.27.1508\bin\1cv8t.exe" ENTERPRISE /F"C:\Bases\TestEmpty" /DisableStartupDialogs /DisableStartupMessages /Out "C:\Users\User\Documents\1c\WeKings\utils\run_empty_log.txt"
echo ENT_EXITCODE=%ERRORLEVEL%
