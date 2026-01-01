"""
🧪 TEST FINAL DES APIs MOBILE WASSALI
Test UNIQUEMENT les endpoints documentés dans /docs
"""
import requests
from datetime import datetime

BASE = "http://localhost:8000"
API = f"{BASE}/api/v1"

print("=" * 80)
print("🔥 TEST DES APIs MOBILE WASSALI".center(80))
print("=" * 80)

# ============ 1. Santé Backend ============
print("\n1️⃣ Backend Health")
print("-" * 80)
try:
    r = requests.get(f"{BASE}/health")
    ok = r.status_code == 200
    print(f"{'✅' if ok else '❌'} Backend: {r.status_code}")
    if ok:
        print(f"   {r.json()}")
except Exception as e:
    print(f"❌ Erreur: {e}")
    exit(1)

# ============ 2. Inscription Client ============
print("\n2️⃣ Inscription Client")
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
        print(f"✅ Client créé: {client_email}")
        if token:
            print(f"   🔑 Token: {token[:50]}...")
    else:
        print(f"❌ Erreur: {r.text[:200]}")
except Exception as e:
    print(f"❌ Exception: {e}")

# ============ 3. Connexion ============
print("\n3️⃣ Connexion")
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
            print(f"✅ Connexion OK")
            print(f"   🔑 Token: {token[:50]}...")
        else:
            print(f"❌ Login failed: {r.text[:200]}")
    except Exception as e:
        print(f"❌ Exception: {e}")

# ============ 4. Mon Profil ============
if token:
    print("\n4️⃣ Mon Profil")
    print("-" * 80)
    headers = {"Authorization": f"Bearer {token}"}
    try:
        r = requests.get(f"{API}/users/me", headers=headers)
        print(f"Status: {r.status_code}")
        if r.status_code == 200:
            user = r.json()
            print(f"✅ Profil récupéré")
            print(f"   👤 Nom: {user.get('name', user.get('full_name'))}")
            print(f"   📧 Email: {user.get('email')}")
        else:
            print(f"❌ Erreur: {r.text[:200]}")
    except Exception as e:
        print(f"❌ Exception: {e}")

# ============ 5. Inscription Transporteur ============
print("\n5️⃣ Inscription Transporteur")
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
    # Vérifier si l'endpoint existe
    r = requests.post(f"{API}/auth/register/transporter", json=trans_data)
    print(f"Status: {r.status_code}")
    if r.status_code in [200, 201]:
        print(f"✅ Transporteur créé: {trans_email}")
    elif r.status_code == 404:
        print(f"⚠️ Endpoint non trouvé, essai avec /register")
        trans_data["role"] = "transporter"
        r = requests.post(f"{API}/auth/register", json=trans_data)
        if r.status_code in [200, 201]:
            print(f"✅ Transporteur créé via /register: {trans_email}")
        else:
            print(f"❌ Erreur: {r.text[:200]}")
    else:
        print(f"❌ Erreur: {r.text[:200]}")
except Exception as e:
    print(f"❌ Exception: {e}")

# ============ 6. Créer un Trip (si transporteur) ============
if token:
    print("\n6️⃣ Créer un Trip (voyage)")
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
            print(f"✅ Trip créé: {trip.get('id', 'N/A')}")
        else:
            print(f"⚠️ Erreur (normal si pas transporteur): {r.text[:200]}")
    except Exception as e:
        print(f"❌ Exception: {e}")

# ============ 7. Rechercher des Trips ============
print("\n7️⃣ Rechercher des Trips")
print("-" * 80)
try:
    r = requests.get(f"{API}/trips")
    print(f"Status: {r.status_code}")
    if r.status_code == 200:
        trips = r.json()
        count = len(trips) if isinstance(trips, list) else "?"
        print(f"✅ Trips trouvés: {count}")
    else:
        print(f"❌ Erreur: {r.text[:200]}")
except Exception as e:
    print(f"❌ Exception: {e}")

# ============ RÉSUMÉ ============
print("\n" + "=" * 80)
print("✅ TESTS TERMINÉS".center(80))
print("=" * 80)
print()
print("📱 CONFIGURATION POUR L'APP MOBILE:")
print(f"   • Base URL: {API}")
print(f"   • Émulateur Android: http://10.0.2.2:8000/api/v1")
print(f"   • Émulateur iOS: {API}")
print()
print("📖 Documentation complète: http://localhost:8000/api/v1/docs")
print()
