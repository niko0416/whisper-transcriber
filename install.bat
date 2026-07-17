@echo off
setlocal enabledelayedexpansion
title Whisper Transcriber - Installatie
cd /d "%~dp0"

echo ============================================================
echo   Whisper Transcriber wordt geinstalleerd
echo   Dit hoef je maar EENMALIG te doen.
echo ============================================================
echo.

set "PYTHON_EXE="

rem De Python launcher (py.exe) wordt door de officiele installer meegeleverd
rem en heeft, in tegenstelling tot "python", geen nep-alias van de Microsoft
rem Store. Probeer die als eerste.
py -3 -c "import sys" >nul 2>nul
if not errorlevel 1 set "PYTHON_EXE=py -3"

rem Val terug op "python", maar controleer dat het ook echt werkt: als er
rem geen Python geinstalleerd is, staat er standaard een nep-python.exe van
rem de Microsoft Store in PATH die alleen de Store opent en niets doet.
if not defined PYTHON_EXE (
    python -c "import sys" >nul 2>nul
    if not errorlevel 1 set "PYTHON_EXE=python"
)

if not defined PYTHON_EXE (
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

    rem PATH is in dit venster nog niet ververst na de installatie, dus we
    rem zoeken de zojuist geinstalleerde python.exe op de standaardlocatie.
    set "PYTHON_EXE="
    if exist "%LocalAppData%\Programs\Python\Python312\python.exe" (
        set "PYTHON_EXE=%LocalAppData%\Programs\Python\Python312\python.exe"
    )
    if not defined PYTHON_EXE (
        echo.
        echo Python is geinstalleerd, maar dit venster moet opnieuw gestart worden
        echo om dit te herkennen. Sluit dit venster en dubbelklik nogmaals op
        echo install.bat.
        pause
        exit /b 0
    )
)

echo Python gevonden: !PYTHON_EXE!
echo.

echo [1/3] Virtuele omgeving aanmaken...
!PYTHON_EXE! -m venv venv
if not exist "venv\Scripts\python.exe" (
    echo.
    echo Het aanmaken van de virtuele omgeving is mislukt.
    pause
    exit /b 1
)

echo [2/3] Benodigde onderdelen installeren (dit kan enkele minuten duren)...
call venv\Scripts\python.exe -m pip install --upgrade pip >nul

rem Antivirussoftware scant nieuw geschreven bestanden soms even, waardoor
rem pip ze kortstondig niet kan wegschrijven. Probeer daarom een paar keer.
set "INSTALL_OK="
for /l %%i in (1,1,3) do (
    if not defined INSTALL_OK (
        call venv\Scripts\pip.exe install -r requirements.txt
        if not errorlevel 1 set "INSTALL_OK=1"
    )
)
if not defined INSTALL_OK (
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
