"""
Script de démarrage du backend Wassali
"""
import os
import sys

# Changer le répertoire de travail vers le dossier backend
backend_dir = os.path.dirname(os.path.abspath(__file__))
os.chdir(backend_dir)
sys.path.insert(0, backend_dir)

print("=" * 60)
print("  🚀 DÉMARRAGE DU BACKEND WASSALI")
print("=" * 60)
print()
print(f"📁 Répertoire: {backend_dir}")
print()

# Vérifier les dépendances
try:
    import fastapi
    import uvicorn
    import sqlalchemy
    import psycopg2
    from jose import jwt
    import passlib
    print("✅ Toutes les dépendances sont installées")
except ImportError as e:
    print(f"❌ Dépendance manquante: {e}")
    print()
    print("Installez les dépendances avec:")
    print("   pip install fastapi uvicorn sqlalchemy psycopg2 python-jose passlib email-validator bcrypt")
    sys.exit(1)

# Vérifier le fichier .env
env_file = os.path.join(backend_dir, '.env')
if os.path.exists(env_file):
    print(f"✅ Fichier .env trouvé")
else:
    print(f"⚠️  Fichier .env non trouvé (optionnel)")

print()
print("=" * 60)
print("  📚 DOCUMENTATION API")
print("=" * 60)
print()
print("  🌐 Serveur:       http://localhost:8000")
print("  📖 Documentation: http://localhost:8000/docs")
print("  🔄 ReDoc:         http://localhost:8000/redoc")
print()
print("=" * 60)
print()
print("Appuyez sur Ctrl+C pour arrêter le serveur")
print()

# Importer et démarrer l'application
if __name__ == "__main__":
    import uvicorn
    
    uvicorn.run(
        "main:app",
        host="0.0.0.0",
        port=8000,
        reload=True,
        log_level="info"
    )
