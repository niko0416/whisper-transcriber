@echo off
title Whisper Transcriber
cd /d "%~dp0"

if not exist "venv\Scripts\python.exe" (
    echo De app is nog niet geinstalleerd.
    echo Dubbelklik eerst op install.bat en volg de instructies.
    pause
    exit /b 1
)

echo Whisper Transcriber wordt gestart...
echo Je browser opent zo automatisch.
echo.
echo LAAT DIT VENSTER OPENSTAAN zolang je de app gebruikt.
echo Sluit je dit venster, dan stopt de app.
echo.

start /min "" cmd /c "timeout /t 4 /nobreak >nul & start "" http://127.0.0.1:5000"

venv\Scripts\python.exe app.py

echo.
echo De app is gestopt.
pause
