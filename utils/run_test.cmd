@echo off
chcp 65001 >nul
"C:\Program Files (x86)\1cv8t\8.3.27.1508\bin\1cv8t.exe" ENTERPRISE /F"C:\Bases\InfoBase2" /DisableStartupDialogs /DisableStartupMessages /DisableUnsafeOperationProtection /Execute "C:\Bases\ТестовыеДанные.epf" /Out "C:\Users\User\Documents\1c\WeKings\utils\run_test_log.txt"
echo EXITCODE=%ERRORLEVEL%
