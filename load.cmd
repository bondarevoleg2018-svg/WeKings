@echo off
chcp 65001 >nul
"C:\Program Files (x86)\1cv8t\8.3.27.1508\bin\1cv8t.exe" DESIGNER /F"C:\Bases\InfoBase2" /LoadConfigFromFiles "C:\Users\User\Documents\1c\WeKings" -format Hierarchical /UpdateDBCfg /Out "C:\Users\User\Documents\1c\WeKings\log.txt" /DisableStartupDialogs /DisableStartupMessages
echo EXITCODE=%ERRORLEVEL%
