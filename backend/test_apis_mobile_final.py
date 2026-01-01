"""
Script de test COMPLET des APIs Wassali Mobile
Teste les endpoints réellement disponibles dans le backend
"""
import requests
import json
from datetime import datetime, timedelta

BASE_URL = "http://localhost:8000/api"
token = None
user_id = None

def print_result(emoji, name, success, details=""):
    status = "✅" if success else "❌"
    print(f"{emoji} {status} {name}")
    if details:
        print(f"     {details}")
    print()

# ========== TESTS ==========

print("=" * 70)
print("  🧪 TESTS DES APIs MOBILE WASSALI".center(70))
print("=" * 70)
print()

# 1. Test Backend
print("📡 Test de connexion backend")
print("-" * 70)
try:
    response = requests.get("http://localhost:8000/health")
    print_result("🔌", "Backend Health Check", response.status_code == 200, 
                f"Status: {response.status_code}")
except Exception as e:
    print_result("🔌", "Backend Health Check", False, str(e))
    exit(1)

# 2. Inscription Client
print("🔐 AUTHENTIFICATION - Inscription Client")
print("-" * 70)
data = {
    "email": f"client{datetime.now().timestamp()}@wassali.tn",
    "password": "Test123!",
    "name": "Ahmed Client Mobile",
    "phone": "+216 98 123 456",
    "role": "client"
}

try:
    response = requests.post(f"{BASE_URL}/auth/register", json=data)
    if response.status_code == 200:
        result = response.json()
        token = result.get("access_token") or result.get("token")
        user_id = result.get("user", {}).get("id") if "user" in result else result.get("id")
        print_result("👤", "Inscription Client", True, 
                    f"User créé - Email: {data['email']}")
        if token:
            print(f"     🔑 Token: {token[:40]}...")
    else:
        print_result("👤", "Inscription Client", False, 
                    f"Status {response.status_code}: {response.text[:100]}")
except Exception as e:
    print_result("👤", "Inscription Client", False, str(e))

# 3. Connexion
print("🔐 AUTHENTIFICATION - Connexion")
print("-" * 70)
login_data = {
    "email": data["email"],
    "password": data["password"]
}

try:
    response = requests.post(f"{BASE_URL}/auth/login", json=login_data)
    if response.status_code == 200:
        result = response.json()
        token = result.get("access_token") or result.get("token")
        print_result("🔑", "Connexion", True, f"Token obtenu")
    else:
        print_result("🔑", "Connexion", False, 
                    f"Status {response.status_code}: {response.text[:100]}")
except Exception as e:
    print_result("🔑", "Connexion", False, str(e))

# 4. Profil utilisateur
if token:
    print("👤 PROFIL - Récupération des informations")
    print("-" * 70)
    headers = {"Authorization": f"Bearer {token}"}
    
    try:
        response = requests.get(f"{BASE_URL}/users/me", headers=headers)
        if response.status_code == 200:
            user = response.json()
            print_result("📋", "Mon Profil", True, 
                        f"Nom: {user.get('name')}, Email: {user.get('email')}")
        else:
            print_result("📋", "Mon Profil", False, 
                        f"Status {response.status_code}: {response.text[:100]}")
    except Exception as e:
        print_result("📋", "Mon Profil", False, str(e))

# 5. Inscription Transporteur (nouveau compte)
print("🚚 AUTHENTIFICATION - Inscription Transporteur")
print("-" * 70)
trans_data = {
    "email": f"trans{datetime.now().timestamp()}@wassali.tn",
    "password": "Trans123!",
    "name": "Mohamed Transporteur",
    "phone": "+216 22 987 654",
    "role": "transporter"
}

try:
    response = requests.post(f"{BASE_URL}/auth/register/transporter", json=trans_data)
    success = response.status_code == 200
    details = f"Transporteur créé" if success else f"Status {response.status_code}"
    print_result("🚛", "Inscription Transporteur", success, details)
except Exception as e:
    print_result("🚛", "Inscription Transporteur", False, str(e))

# 6. Test des endpoints disponibles
print("📊 VÉRIFICATION - Endpoints disponibles")
print("-" * 70)

endpoints_to_test = [
    ("/api/auth/login", "POST", "Login"),
    ("/api/auth/register", "POST", "Register"),
    ("/api/users/me", "GET", "User Profile"),
    ("/health", "GET", "Health Check"),
]

for endpoint, method, name in endpoints_to_test:
    try:
        if method == "GET":
            resp = requests.get(f"http://localhost:8000{endpoint}", 
                              headers={"Authorization": f"Bearer {token}"} if token else {})
        else:
            resp = requests.options(f"http://localhost:8000{endpoint}")
        
        available = resp.status_code != 404
        print_result("🔗", name, available, f"{method} {endpoint} - Status: {resp.status_code}")
    except:
        print_result("🔗", name, False, f"{method} {endpoint}")

# Résumé
print("=" * 70)
print("  ✅ TESTS TERMINÉS".center(70))
print("=" * 70)
print()
print("📖 Documentation interactive: http://localhost:8000/docs")
print("🔄 Alternative ReDoc: http://localhost:8000/redoc")
print()
print("💡 POUR L'APPLICATION MOBILE:")
print("   - URL Backend: http://localhost:8000")
print("   - URL API: http://localhost:8000/api")
print("   - Pour émulateur Android: http://10.0.2.2:8000")
print()
