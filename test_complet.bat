@echo off
echo ========================================
echo    TEST COMPLET WASSALI ANDROID
echo ========================================
echo.

REM Verifier que le backend tourne
echo [1] Verification du backend...
curl -s http://localhost:8000/health > nul 2>&1
if errorlevel 1 (
    echo.
    echo ATTENTION: Le backend ne semble pas tourner
    echo.
    echo Voulez-vous le demarrer maintenant? (O/N)
    set /p choice=
    if /i "%choice%"=="O" (
        echo Demarrage du backend...
        start "Wassali Backend" cmd /k "cd /d %~dp0backend && python start.py"
        echo Attente de 10 secondes pour le demarrage du backend...
        timeout /t 10 /nobreak > nul
    ) else (
        echo.
        echo ERREUR: Le backend doit tourner pour tester l'app
        echo Demarrez-le manuellement:
        echo   cd backend
        echo   python start.py
        echo.
        pause
        exit /b 1
    )
)

echo Backend OK
echo.

REM Aller dans le dossier mobile
cd /d "%~dp0wassali_mobile_app"

echo [2] Installation des dependances Flutter...
flutter pub get
echo.

echo [3] Lancement de l'emulateur Android...
echo Demarrage de Medium_Phone_API_36.1...
start "Android Emulator" flutter emulators --launch Medium_Phone_API_36.1

echo Attente du demarrage de l'emulateur (30 secondes)...
timeout /t 30 /nobreak

echo.
echo [4] Lancement de l'application Wassali...
echo.
echo ========================================
echo  CONFIGURATION ACTIVE
echo ========================================
echo  Backend:  http://localhost:8000
echo  Mobile:   http://10.0.2.2:8000/api/v1
echo  Device:   Medium_Phone_API_36.1
echo ========================================
echo.

flutter run -d Medium_Phone_API_36.1

pause
