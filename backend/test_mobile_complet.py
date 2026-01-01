"""
🧪 TEST COMPLET DES APIs MOBILE WASSALI
Teste tous les endpoints essentiels pour l'application mobile
"""
import requests
import json
from datetime import datetime

BASE_URL = "http://localhost:8000/api"
token_client = None
token_trans = None
client_id = None
trans_id = None

def print_test(emoji, name, success, details=""):
    status = "✅" if success else "❌"
    print(f"{emoji} {status} {name}")
    if details:
        print(f"   → {details}")

print("=" * 80)
print("🧪 TESTS DES APIs MOBILE WASSALI".center(80))
print("=" * 80)
print()

# ============= 1. SANTÉ DU BACKEND =============
print("🔌 1. SANTÉ DU BACKEND")
print("-" * 80)
try:
    r = requests.get("http://localhost:8000/health", timeout=5)
    print_test("💚", "Backend actif", r.status_code == 200, f"Status: {r.status_code}")
except Exception as e:
    print_test("💚", "Backend actif", False, str(e))
    exit(1)

# ============= 2. INSCRIPTION CLIENT =============
print("\n👤 2. INSCRIPTION CLIENT")
print("-" * 80)
client_email = f"client{int(datetime.now().timestamp())}@wassali.tn"
client_data = {
    "email": client_email,
    "password": "Password123!",
    "full_name": "Ahmed Ben Ali",
    "phone": "+216 98 123 456",
    "role": "customer"
}

try:
    r = requests.post(f"{BASE_URL}/auth/register", json=client_data)
    if r.status_code == 200:
        result = r.json()
        token_client = result.get("access_token")
        client_id = result.get("user", {}).get("id")
        print_test("✍️", "Inscription client", True, f"Email: {client_email}")
        print(f"   🔑 Token: {token_client[:50]}..." if token_client else "   ⚠️ Pas de token")
    else:
        print_test("✍️", "Inscription client", False, f"Status {r.status_code}: {r.text[:150]}")
except Exception as e:
    print_test("✍️", "Inscription client", False, str(e))

# ============= 3. CONNEXION CLIENT =============
print("\n🔐 3. CONNEXION CLIENT")
print("-" * 80)

# Test avec form-data (OAuth2)
try:
    login_form = {
        "username": client_email,
        "password": "Password123!"
    }
    r = requests.post(f"{BASE_URL}/auth/login", data=login_form)
    if r.status_code == 200:
        result = r.json()
        token_client = result.get("access_token")
        print_test("🔓", "Connexion client (form)", True, "Token obtenu")
        print(f"   🔑 Token: {token_client[:50]}..." if token_client else "")
    else:
        # Essayer en JSON
        r = requests.post(f"{BASE_URL}/auth/login", json={"email": client_email, "password": "Password123!"})
        if r.status_code == 200:
            result = r.json()
            token_client = result.get("access_token")
            print_test("🔓", "Connexion client (json)", True, "Token obtenu")
        else:
            print_test("🔓", "Connexion client", False, f"Status {r.status_code}: {r.text[:150]}")
except Exception as e:
    print_test("🔓", "Connexion client", False, str(e))

# ============= 4. PROFIL CLIENT =============
if token_client:
    print("\n📋 4. PROFIL UTILISATEUR")
    print("-" * 80)
    headers = {"Authorization": f"Bearer {token_client}"}
    
    try:
        r = requests.get(f"{BASE_URL}/users/me", headers=headers)
        if r.status_code == 200:
            user = r.json()
            print_test("👤", "Récupérer mon profil", True, 
                      f"Nom: {user.get('full_name')}, Email: {user.get('email')}")
        else:
            print_test("👤", "Récupérer mon profil", False, f"Status {r.status_code}")
    except Exception as e:
        print_test("👤", "Récupérer mon profil", False, str(e))

# ============= 5. INSCRIPTION TRANSPORTEUR =============
print("\n🚚 5. INSCRIPTION TRANSPORTEUR")
print("-" * 80)
trans_email = f"trans{int(datetime.now().timestamp())}@wassali.tn"
trans_data = {
    "email": trans_email,
    "password": "Trans123!",
    "full_name": "Mohamed Transport",
    "phone": "+216 22 654 321",
    "role": "transporter",
    "vehicle_type": "Van",
    "driver_license": "TN123456"
}

try:
    r = requests.post(f"{BASE_URL}/auth/register/transporter", json=trans_data)
    if r.status_code == 200:
        result = r.json()
        token_trans = result.get("access_token")
        trans_id = result.get("user", {}).get("id")
        print_test("🚛", "Inscription transporteur", True, f"Email: {trans_email}")
    else:
        print_test("🚛", "Inscription transporteur", False, f"Status {r.status_code}: {r.text[:150]}")
except Exception as e:
    print_test("🚛", "Inscription transporteur", False, str(e))

# ============= 6. LISTE TRANSPORTEURS =============
print("\n👥 6. LISTE DES TRANSPORTEURS")
print("-" * 80)

try:
    r = requests.get(f"{BASE_URL}/users/transporters/all")
    if r.status_code == 200:
        transporters = r.json()
        count = len(transporters) if isinstance(transporters, list) else "?"
        print_test("📋", "Tous les transporteurs", True, f"{count} transporteur(s)")
    else:
        print_test("📋", "Tous les transporteurs", False, f"Status {r.status_code}")
except Exception as e:
    print_test("📋", "Tous les transporteurs", False, str(e))

try:
    r = requests.get(f"{BASE_URL}/users/transporters/available")
    if r.status_code == 200:
        print_test("📋", "Transporteurs disponibles", True, "OK")
    else:
        print_test("📋", "Transporteurs disponibles", False, f"Status {r.status_code}")
except Exception as e:
    print_test("📋", "Transporteurs disponibles", False, str(e))

# ============= 7. PARCELS (ENVOIS) =============
print("\n📦 7. GESTION DES ENVOIS")
print("-" * 80)

if token_client:
    headers = {"Authorization": f"Bearer {token_client}"}
    parcel_data = {
        "pickup_address": "Avenue Bourguiba, Tunis",
        "delivery_address": "Route de La Marsa, Tunis",
        "description": "Colis test mobile",
        "weight": 2.5,
        "size": "medium",
        "price": 15.0
    }
    
    try:
        r = requests.post(f"{BASE_URL}/parcels/", json=parcel_data, headers=headers)
        if r.status_code in [200, 201]:
            parcel = r.json()
            print_test("📤", "Créer un envoi", True, f"ID: {parcel.get('id', 'N/A')}")
        else:
            print_test("📤", "Créer un envoi", False, f"Status {r.status_code}: {r.text[:150]}")
    except Exception as e:
        print_test("📤", "Créer un envoi", False, str(e))
    
    try:
        r = requests.get(f"{BASE_URL}/parcels/", headers=headers)
        if r.status_code == 200:
            parcels = r.json()
            count = len(parcels) if isinstance(parcels, list) else "?"
            print_test("📋", "Mes envois", True, f"{count} envoi(s)")
        else:
            print_test("📋", "Mes envois", False, f"Status {r.status_code}")
    except Exception as e:
        print_test("📋", "Mes envois", False, str(e))

# ============= RÉSUMÉ =============
print("\n" + "=" * 80)
print("✅ TESTS TERMINÉS".center(80))
print("=" * 80)
print()
print("📊 RÉSUMÉ:")
print(f"   • Client créé: {client_email if token_client else '❌'}")
print(f"   • Transporteur créé: {trans_email if token_trans else '❌'}")
print()
print("🔗 ENDPOINTS DISPONIBLES:")
print("   • POST /api/auth/register - Inscription")
print("   • POST /api/auth/register/transporter - Inscription transporteur")
print("   • POST /api/auth/login - Connexion")
print("   • GET /api/users/me - Mon profil")
print("   • GET /api/users/transporters/all - Liste transporteurs")
print("   • POST /api/parcels/ - Créer envoi")
print("   • GET /api/parcels/ - Mes envois")
print()
print("📱 CONFIGURATION MOBILE:")
print("   • Base URL: http://localhost:8000/api")
print("   • Émulateur Android: http://10.0.2.2:8000/api")
print("   • Émulateur iOS: http://localhost:8000/api")
print()
print("📖 Documentation: http://localhost:8000/docs")
print()
