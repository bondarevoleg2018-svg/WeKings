@echo off
chcp 65001 >nul
"C:\Program Files (x86)\1cv8t\8.3.27.1508\bin\1cv8t.exe" DESIGNER /F"C:\Bases\InfoBase2" /DumpExternalDataProcessorOrReportToFiles "C:\Bases\epf_back" "C:\Bases\test.epf" /Out "C:\Users\User\Documents\1c\WeKings\utils\dump_epf_log.txt" /DisableStartupDialogs /DisableStartupMessages
echo EXITCODE=%ERRORLEVEL%
