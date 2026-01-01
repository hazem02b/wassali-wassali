@echo off
echo ========================================
echo   WASSALI - CREATION BASE DE DONNEES
echo ========================================
echo.

REM Vérifier si psql est dans le PATH
where psql >nul 2>&1
if %errorlevel% neq 0 (
    echo PostgreSQL psql n'est pas dans le PATH.
    echo Tentative avec le chemin par defaut...
    set PSQL_PATH="C:\Program Files\PostgreSQL\18\bin\psql.exe"
) else (
    set PSQL_PATH=psql
)

echo Veuillez entrer le mot de passe PostgreSQL (par defaut: postgres):
set /p PG_PASSWORD=Mot de passe PostgreSQL: 

echo.
echo Creation de la base de donnees wassali_db...
echo.

REM Créer la base de données
echo CREATE DATABASE wassali_db ENCODING 'UTF8'; | %PSQL_PATH% -U postgres -h localhost

if %errorlevel% equ 0 (
    echo.
    echo ✅ Base de donnees 'wassali_db' creee avec succes!
    echo.
) else (
    echo.
    echo ⚠️  La base existe peut-etre deja ou erreur de connexion
    echo.
)

echo ========================================
echo   VERIFICATION
echo ========================================
echo Liste des bases de donnees:
echo.
echo \l | %PSQL_PATH% -U postgres -h localhost wassali_db

echo.
echo Appuyez sur une touche pour continuer...
pause >nul
