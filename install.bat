@echo off
setlocal
title Whisper Transcriber - Installatie
cd /d "%~dp0"

echo ============================================================
echo   Whisper Transcriber wordt geinstalleerd
echo   Dit hoef je maar EENMALIG te doen.
echo ============================================================
echo.

where python >nul 2>nul
if errorlevel 1 (
    echo Python is niet gevonden op deze computer.
    echo.
    echo Er wordt geprobeerd Python automatisch te installeren via Windows...
    winget install -e --id Python.Python.3.12 --accept-source-agreements --accept-package-agreements
    if errorlevel 1 (
        echo.
        echo Automatische installatie is niet gelukt.
        echo Download en installeer Python handmatig via https://www.python.org/downloads/
        echo Vink tijdens de installatie "Add Python to PATH" aan.
        echo Start dit bestand daarna opnieuw.
        pause
        exit /b 1
    )
    echo.
    echo Python is geinstalleerd. Sluit dit venster en start install.bat opnieuw
    echo zodat Windows de installatie herkent.
    pause
    exit /b 0
)

echo [1/3] Virtuele omgeving aanmaken...
python -m venv venv

echo [2/3] Benodigde onderdelen installeren (dit kan enkele minuten duren)...
call venv\Scripts\python.exe -m pip install --upgrade pip >nul
call venv\Scripts\pip.exe install -r requirements.txt
if errorlevel 1 (
    echo.
    echo Er ging iets mis bij het installeren. Controleer je internetverbinding
    echo en start install.bat opnieuw.
    pause
    exit /b 1
)

echo [3/3] Snelkoppeling op het bureaublad maken...
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0make_shortcut.ps1"

echo.
echo ============================================================
echo   Installatie voltooid!
echo   Er staat nu een snelkoppeling "Whisper Transcriber" op je
echo   bureaublad. Dubbelklik daarop om de app te starten.
echo.
echo   Tip: sleep die snelkoppeling naar je taakbalk om hem daar
echo   vast te pinnen.
echo ============================================================
pause
