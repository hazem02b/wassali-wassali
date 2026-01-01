#!/bin/bash

echo "========================================"
echo " TEST RAPIDE - ANDROID EMULATOR"
echo "========================================"
echo ""

# Vérifier que le backend tourne
echo "[1] Vérification du backend..."
response=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:8000/health 2>/dev/null)

if [ "$response" != "200" ]; then
    echo "❌ ERREUR: Backend non accessible sur http://localhost:8000"
    echo ""
    echo "Démarrez le backend:"
    echo "  cd backend"
    echo "  python start.py"
    echo ""
    exit 1
fi

echo "✅ Backend accessible"
echo ""

# Aller dans le dossier mobile
cd wassali_mobile_app

# Vérifier Flutter
echo "[2] Vérification Flutter..."
if ! command -v flutter &> /dev/null; then
    echo "❌ Flutter n'est pas installé"
    exit 1
fi

echo "✅ Flutter OK"
echo ""

# Installer les dépendances
echo "[3] Installation des dépendances..."
flutter pub get

# Vérifier les devices
echo ""
echo "[4] Devices disponibles:"
flutter devices

# Lancer l'app
echo ""
echo "[5] Lancement de l'application..."
echo ""
echo "📱 Configuration actuelle:"
echo "   - Base URL: http://10.0.2.2:8000/api/v1"
echo "   - Backend: http://localhost:8000"
echo ""

flutter run
