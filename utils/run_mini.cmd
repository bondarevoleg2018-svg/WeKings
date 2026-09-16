@echo off
chcp 65001 >nul
"C:\Program Files (x86)\1cv8t\8.3.27.1508\bin\1cv8t.exe" DESIGNER /F"C:\Bases\InfoBase2" /LoadExternalDataProcessorOrReportFromFiles "C:\Users\User\Documents\1c\WeKings\utils\МиниТест\МиниТест.xml" "C:\Bases\mini.epf" /Out "C:\Users\User\Documents\1c\WeKings\utils\build_mini_log.txt" /DisableStartupDialogs /DisableStartupMessages
"C:\Program Files (x86)\1cv8t\8.3.27.1508\bin\1cv8t.exe" ENTERPRISE /F"C:\Bases\InfoBase2" /DisableStartupDialogs /DisableStartupMessages /Execute "C:\Bases\mini.epf" /Out "C:\Users\User\Documents\1c\WeKings\utils\run_mini_log.txt"
echo EXITCODE=%ERRORLEVEL%
