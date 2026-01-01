"""
TEST FINAL DES APIs MOBILE WASSALI
Test UNIQUEMENT les endpoints documentes dans /docs
"""
import requests
from datetime import datetime

BASE = "http://localhost:8000"
API = f"{BASE}/api"

print("=" * 80)
print("TEST DES APIs MOBILE WASSALI".center(80))
print("=" * 80)

# ============ 1. Sante Backend ============
print("\n[1] Backend Health")
print("-" * 80)
try:
    r = requests.get(f"{BASE}/health")
    ok = r.status_code == 200
    print(f"{'[OK]' if ok else '[FAIL]'} Backend: {r.status_code}")
    if ok:
        print(f"   {r.json()}")
except Exception as e:
    print(f"[FAIL] Erreur: {e}")
    exit(1)

# ============ 2. Inscription Client ============
print("\n[2] Inscription Client")
print("-" * 80)
client_email = f"client{int(datetime.now().timestamp())}@test.tn"
client_data = {
    "email": client_email,
    "password": "Pass123!",
    "full_name": "Ahmed Test",
    "phone": "+216 98 123 456",
    "role": "customer"
}

token = None
try:
    r = requests.post(f"{API}/auth/register", json=client_data)
    print(f"Status: {r.status_code}")
    if r.status_code in [200, 201]:
        result = r.json()
        token = result.get("access_token")
        print(f"[OK] Client cree: {client_email}")
        if token:
            print(f"   [TOKEN] {token[:50]}...")
    else:
        print(f"[FAIL] Erreur: {r.text[:200]}")
except Exception as e:
    print(f"[FAIL] Exception: {e}")

# ============ 3. Connexion ============
print("\n[3] Connexion")
print("-" * 80)
if not token:
    try:
        # Essayer avec form-data (OAuth2)
        r = requests.post(
            f"{API}/auth/login",
            data={"username": client_email, "password": "Pass123!"}
        )
        print(f"Status: {r.status_code}")
        if r.status_code == 200:
            token = r.json().get("access_token")
            print(f"[OK] Connexion reussie")
            print(f"   [TOKEN] {token[:50]}...")
        else:
            print(f"[FAIL] Login failed: {r.text[:200]}")
    except Exception as e:
        print(f"[FAIL] Exception: {e}")

# ============ 4. Mon Profil ============
if token:
    print("\n[4] Mon Profil")
    print("-" * 80)
    headers = {"Authorization": f"Bearer {token}"}
    try:
        r = requests.get(f"{API}/users/me", headers=headers)
        print(f"Status: {r.status_code}")
        if r.status_code == 200:
            user = r.json()
            print(f"[OK] Profil recupere")
            print(f"   Nom: {user.get('name', user.get('full_name'))}")
            print(f"   Email: {user.get('email')}")
        else:
            print(f"[FAIL] Erreur: {r.text[:200]}")
    except Exception as e:
        print(f"[FAIL] Exception: {e}")

# ============ 5. Inscription Transporteur ============
print("\n[5] Inscription Transporteur")
print("-" * 80)
trans_email = f"trans{int(datetime.now().timestamp())}@test.tn"
trans_data = {
    "email": trans_email,
    "password": "Trans123!",
    "full_name": "Mohamed Transport",
    "phone": "+216 22 654 321",
    "role": "transporter",
    "vehicle_type": "Van"
}

try:
    # Verifier si l'endpoint existe
    r = requests.post(f"{API}/auth/register/transporter", json=trans_data)
    print(f"Status: {r.status_code}")
    if r.status_code in [200, 201]:
        print(f"[OK] Transporteur cree: {trans_email}")
    elif r.status_code == 404:
        print(f"[INFO] Endpoint non trouve, essai avec /register")
        trans_data["role"] = "transporter"
        r = requests.post(f"{API}/auth/register", json=trans_data)
        if r.status_code in [200, 201]:
            print(f"[OK] Transporteur cree via /register: {trans_email}")
        else:
            print(f"[FAIL] Erreur: {r.text[:200]}")
    else:
        print(f"[FAIL] Erreur: {r.text[:200]}")
except Exception as e:
    print(f"[FAIL] Exception: {e}")

# ============ 6. Creer un Trip (si transporteur) ============
if token:
    print("\n[6] Creer un Trip (voyage)")
    print("-" * 80)
    trip_data = {
        "departure_city": "Tunis",
        "destination_city": "Paris",
        "departure_date": "2025-02-15T10:00:00",
        "arrival_date": "2025-02-16T14:00:00",
        "available_weight": 50.0,
        "price_per_kg": 5.0
    }
    
    try:
        r = requests.post(f"{API}/trips", json=trip_data, headers=headers)
        print(f"Status: {r.status_code}")
        if r.status_code in [200, 201]:
            trip = r.json()
            print(f"[OK] Trip cree: {trip.get('id', 'N/A')}")
        else:
            print(f"[INFO] Erreur (normal si pas transporteur): {r.text[:200]}")
    except Exception as e:
        print(f"[FAIL] Exception: {e}")

# ============ 7. Rechercher des Trips ============
print("\n[7] Rechercher des Trips")
print("-" * 80)
try:
    r = requests.get(f"{API}/trips")
    print(f"Status: {r.status_code}")
    if r.status_code == 200:
        trips = r.json()
        count = len(trips) if isinstance(trips, list) else "?"
        print(f"[OK] Trips trouves: {count}")
    else:
        print(f"[FAIL] Erreur: {r.text[:200]}")
except Exception as e:
    print(f"[FAIL] Exception: {e}")

# ============ RESUME ============
print("\n" + "=" * 80)
print("TESTS TERMINES".center(80))
print("=" * 80)
print()
print("CONFIGURATION POUR L'APP MOBILE:")
print(f"   - Base URL: {API}")
print(f"   - Emulateur Android: http://10.0.2.2:8000/api/v1")
print(f"   - Emulateur iOS: {API}")
print()
print("Documentation complete: http://localhost:8000/api/v1/docs")
print()
