import requests
from datetime import datetime

print("=" * 70)
print("TEST FINAL - APIs Mobile Wassali")
print("=" * 70)

# Test 1: Inscription CLIENT
print("\n[1] Test inscription CLIENT")
email = f"client{int(datetime.now().timestamp())}@wassali.tn"
data = {
    "email": email,
    "password": "Test123!",
    "name": "Ahmed Client",
    "phone": "+216 98 111 222",
    "role": "client"
}

r = requests.post("http://localhost:8000/api/v1/auth/register", json=data)
print(f"    Status: {r.status_code}")

if r.status_code in [200, 201]:
    result = r.json()
    print(f"    [OK] Inscription reussie!")
    print(f"    Email: {email}")
    token = result.get('access_token')
    
    # Test 2: Connexion
    print("\n[2] Test connexion")
    login_data = {"email": email, "password": "Test123!", "role": "client"}
    r = requests.post("http://localhost:8000/api/v1/auth/login", json=login_data)
    print(f"    Status: {r.status_code}")
    
    if r.status_code == 200:
        print(f"    [OK] Connexion reussie!")
        token = r.json().get('access_token')
        print(f"    Token: {token[:40]}...")
        
        # Test 3: Profil
        print("\n[3] Test mon profil")
        headers = {"Authorization": f"Bearer {token}"}
        r = requests.get("http://localhost:8000/api/v1/users/me", headers=headers)
        print(f"    Status: {r.status_code}")
        
        if r.status_code == 200:
            user = r.json()
            print(f"    [OK] Profil recupere!")
            print(f"    Nom: {user.get('name')}")
            print(f"    Email: {user.get('email')}")
            print(f"    Role: {user.get('role')}")
            
            # Test 4: Liste transporteurs
            print("\n[4] Test liste transporteurs")
            r = requests.get("http://localhost:8000/api/v1/users/transporters/all")
            print(f"    Status: {r.status_code}")
            if r.status_code == 200:
                transporters = r.json()
                print(f"    [OK] {len(transporters)} transporteur(s)")
            else:
                print(f"    [FAIL] Erreur: {r.status_code}")
                
            # Test 5: Créer un parcel
            print("\n[5] Test creation parcel")
            parcel_data = {
                "pickup_address": "Tunis, Tunisie",
                "delivery_address": "Paris, France",
                "description": "Colis test",
                "weight": 5.0,
                "size": "medium",
                "price": 25.0
            }
            r = requests.post("http://localhost:8000/api/v1/parcels/", json=parcel_data, headers=headers)
            print(f"    Status: {r.status_code}")
            if r.status_code in [200, 201]:
                parcel = r.json()
                print(f"    [OK] Parcel cree! ID: {parcel.get('id')}")
            else:
                print(f"    [FAIL] {r.text[:150]}")
                
        else:
            print(f"    [FAIL] Profil: {r.text[:150]}")
    else:
        print(f"    [FAIL] Connexion: {r.text[:150]}")
else:
    print(f"    [FAIL] Inscription: {r.text[:200]}")

print("\n" + "=" * 70)
print("CONFIGURATION MOBILE:")
print("  Base URL: http://localhost:8000/api/v1")
print("  Android Emulator: http://10.0.2.2:8000/api/v1")
print("  Champs requis: name (pas full_name), role: client|transporter|admin")
print("=" * 70)
