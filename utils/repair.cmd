@echo off
chcp 65001 >nul
"C:\Program Files (x86)\1cv8t\8.3.27.1508\bin\1cv8t.exe" DESIGNER /F"C:\Bases\InfoBase2" /IBCheckAndRepair -Reindex -LogAndRefsIntegrity -RecalcTotals /Out "C:\Users\User\Documents\1c\WeKings\utils\repair_log.txt" /DisableStartupDialogs /DisableStartupMessages
echo EXITCODE=%ERRORLEVEL%
