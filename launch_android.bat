@echo off
echo ========================================
echo  LANCEMENT WASSALI SUR ANDROID STUDIO
echo ========================================
echo.

REM Aller dans le dossier mobile
cd /d "%~dp0wassali_mobile_app"

echo [1/4] Verification de Flutter...
flutter --version
if errorlevel 1 (
    echo ERREUR: Flutter n'est pas installe ou configure
    pause
    exit /b 1
)

echo.
echo [2/4] Installation des dependances...
flutter pub get
if errorlevel 1 (
    echo ERREUR: Echec de l'installation des dependances
    pause
    exit /b 1
)

echo.
echo [3/4] Verification des devices...
flutter devices

echo.
echo [4/4] Lancement de l'application...
echo.
echo IMPORTANT:
echo - Pour emulateur Android: URL = http://10.0.2.2:8000/api/v1
echo - Pour device physique: Modifiez api_config.dart avec votre IP locale
echo - Backend doit tourner sur http://localhost:8000
echo.
echo Appuyez sur une touche pour lancer l'app...
pause > nul

flutter run

pause
