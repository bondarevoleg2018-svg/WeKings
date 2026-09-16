@echo off
chcp 65001 >nul
REM Обратная выгрузка для проверки. Аргумент %1 - целевая папка (например C:\Bases\WeKings_check_v1)
"C:\Program Files (x86)\1cv8t\8.3.27.1508\bin\1cv8t.exe" DESIGNER /F"C:\Bases\InfoBase2" /DumpConfigToFiles "%~1" -format Hierarchical /DisableStartupDialogs /DisableStartupMessages /Out "C:\Bases\check_dump_log.txt"
echo EXITCODE=%ERRORLEVEL%
