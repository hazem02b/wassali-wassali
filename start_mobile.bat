@echo off
echo ========================================
echo   WASSALI - DEMARRAGE APPLICATION MOBILE
echo ========================================
echo.

cd /d %~dp0wassali_mobile_app

echo Verification de Flutter...
flutter --version
if %errorlevel% neq 0 (
    echo ❌ Flutter n'est pas installe ou pas dans le PATH
    pause
    exit /b 1
)

echo.
echo Installation des dependances...
call flutter pub get

echo.
echo ========================================
echo   CHOIX DU PERIPHERIQUE
echo ========================================
echo.
call flutter devices

echo.
echo.
echo Options:
echo 1. Lancer sur Android
echo 2. Lancer sur Chrome (Web)
echo 3. Lancer sur Windows
echo.

set /p choice=Votre choix (1-3): 

if "%choice%"=="1" (
    echo.
    echo 🚀 Lancement sur Android...
    flutter run -d android
)

if "%choice%"=="2" (
    echo.
    echo 🚀 Lancement sur Chrome...
    flutter run -d chrome --web-port=5000
)

if "%choice%"=="3" (
    echo.
    echo 🚀 Lancement sur Windows...
    flutter run -d windows
)

pause
