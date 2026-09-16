@echo off
chcp 65001 >nul
"C:\Program Files (x86)\1cv8t\8.3.27.1508\bin\1cv8t.exe" DESIGNER /F"C:\Bases\InfoBase2" /LoadExternalDataProcessorOrReportFromFiles "C:\Users\User\Documents\1c\WeKings\utils\ТестовыеДанные\ТестовыеДанные.xml" "C:\Bases\ТестовыеДанные.epf" /Out "C:\Users\User\Documents\1c\WeKings\utils\build_epf_log.txt" /DisableStartupDialogs /DisableStartupMessages
echo EXITCODE=%ERRORLEVEL%
