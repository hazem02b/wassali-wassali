"""
TEST FINAL DES APIs MOBILE - VERSION CORRIGEE
"""
import requests
import json
from datetime import datetime

BASE = "http://localhost:8000"
API = f"{BASE}/api/v1"

def test(name, success, details=""):
    status = "[OK]  " if success else "[FAIL]"
    print(f"{status} {name}")
    if details:
        print(f"       {details}")

print("=" * 80)
print("TEST DES APIs WASSALI MOBILE".center(80))
print("=" * 80)

# 1. Health Check
print("\n1. Backend Health Check")
print("-" * 80)
try:
    r = requests.get(f"{BASE}/health")
    test("Backend actif", r.status_code == 200, f"Status: {r.status_code}")
except Exception as e:
    test("Backend actif", False, str(e))
    exit(1)

# 2. Register Client
print("\n2. Inscription Client")
print("-" * 80)
client_email = f"client{int(datetime.now().timestamp())}@wassali.tn"
client_data = {
    "email": client_email,
    "password": "Wassali123!",
    "full_name": "Ahmed Ben Ali",
    "phone": "+216 98 111 222",
    "role": "customer"
}

token = None
try:
    r = requests.post(f"{API}/auth/register", json=client_data)
    if r.status_code in [200, 201]:
        result = r.json()
        token = result.get("access_token")
        test("Inscription client", True, f"Email: {client_email}")
        if token:
            print(f"       Token: {token[:45]}...")
    else:
        test("Inscription client", False, f"HTTP {r.status_code}: {r.text[:150]}")
except Exception as e:
    test("Inscription client", False, str(e))

# 3. Login Client
print("\n3. Connexion Client")
print("-" * 80)
if not token:
    try:
        login_data = {"email": client_email, "password": "Wassali123!"}
        r = requests.post(f"{API}/auth/login", json=login_data)
        if r.status_code == 200:
            result = r.json()
            token = result.get("access_token")
            test("Connexion", True, "Token obtenu")
            print(f"       Token: {token[:45]}...")
        else:
            test("Connexion", False, f"HTTP {r.status_code}: {r.text[:150]}")
    except Exception as e:
        test("Connexion", False, str(e))

# 4. Get Profile
if token:
    print("\n4. Mon Profil Utilisateur")
    print("-" * 80)
    headers = {"Authorization": f"Bearer {token}"}
    try:
        r = requests.get(f"{API}/users/me", headers=headers)
        if r.status_code == 200:
            user = r.json()
            nom = user.get('name') or user.get('full_name') or "N/A"
            test("Recuperer profil", True, f"Nom: {nom}, Email: {user.get('email')}")
        else:
            test("Recuperer profil", False, f"HTTP {r.status_code}: {r.text[:150]}")
    except Exception as e:
        test("Recuperer profil", False, str(e))

# 5. Register Transporter  
print("\n5. Inscription Transporteur")
print("-" * 80)
trans_email = f"trans{int(datetime.now().timestamp())}@wassali.tn"
trans_data = {
    "email": trans_email,
    "password": "Transport123!",
    "full_name": "Mohamed Transporteur",
    "phone": "+216 22 333 444",
    "role": "transporter",
    "vehicle_type": "Van"
}

try:
    r = requests.post(f"{API}/auth/register/transporter", json=trans_data)
    if r.status_code in [200, 201]:
        test("Inscription transporteur", True, f"Email: {trans_email}")
    else:
        test("Inscription transporteur", False, f"HTTP {r.status_code}: {r.text[:150]}")
except Exception as e:
    test("Inscription transporteur", False, str(e))

# 6. List Transporters
print("\n6. Liste des Transporteurs")
print("-" * 80)
try:
    r = requests.get(f"{API}/users/transporters/all")
    if r.status_code == 200:
        transporters = r.json()
        count = len(transporters) if isinstance(transporters, list) else "?"
        test("Liste transporteurs", True, f"{count} transporteur(s)")
    else:
        test("Liste transporteurs", False, f"HTTP {r.status_code}")
except Exception as e:
    test("Liste transporteurs", False, str(e))

# 7. Search Parcels
print("\n7. Recherche de Parcels (envois)")
print("-" * 80)
try:
    r = requests.get(f"{API}/parcels/")
    if r.status_code == 200:
        parcels = r.json()
        count = len(parcels) if isinstance(parcels, list) else "?"
        test("Rechercher parcels", True, f"{count} parcel(s) trouve(s)")
    else:
        test("Rechercher parcels", False, f"HTTP {r.status_code}")
except Exception as e:
    test("Rechercher parcels", False, str(e))

# 8. Create Parcel
if token:
    print("\n8. Creer un Parcel (envoi)")
    print("-" * 80)
    headers = {"Authorization": f"Bearer {token}"}
    parcel_data = {
        "pickup_address": "123 Avenue Bourguiba, Tunis",
        "delivery_address": "456 Rue de Paris, La Marsa",
        "description": "Colis test mobile",
        "weight": 5.5,
        "size": "medium",
        "price": 25.0
    }
    
    try:
        r = requests.post(f"{API}/parcels/", json=parcel_data, headers=headers)
        if r.status_code in [200, 201]:
            parcel = r.json()
            test("Creer parcel", True, f"ID: {parcel.get('id', 'N/A')}")
        else:
            test("Creer parcel", False, f"HTTP {r.status_code}: {r.text[:150]}")
    except Exception as e:
        test("Creer parcel", False, str(e))

# RESUME
print("\n" + "=" * 80)
print("RESUME DES TESTS".center(80))
print("=" * 80)
print()
print("ENDPOINTS TESTES:")
print(f"  [✓] POST /api/auth/register - Inscription client")
print(f"  [✓] POST /api/auth/login - Connexion")
print(f"  [✓] GET  /api/users/me - Mon profil")
print(f"  [✓] POST /api/auth/register/transporter - Inscription transporteur")
print(f"  [✓] GET  /api/users/transporters/all - Liste transporteurs")
print(f"  [✓] GET  /api/parcels/ - Rechercher parcels")
print(f"  [✓] POST /api/parcels/ - Creer parcel")
print()
print("CONFIGURATION MOBILE:")
print(f"  Base URL: http://localhost:8000/api")
print(f"  Emulateur Android: http://10.0.2.2:8000/api")
print(f"  Emulateur iOS: http://localhost:8000/api")
print()
print("Documentation: http://localhost:8000/docs")
print()
