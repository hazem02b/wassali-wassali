import requests

print("=" * 60)
print("TEST FINAL - APIs Mobile")
print("=" * 60)

# Test avec les bons champs
print("\n1. Test inscription CLIENT")
data = {
    "email": "client@wassali.tn",
    "password": "Test123!",
    "name": "Ahmed Client",           # "name" pas "full_name"
    "phone": "+216 98 111 222",
    "role": "client"                   # "client" pas "customer"
}

r = requests.post("http://localhost:8000/api/v1/auth/register", json=data)
print(f"Status: {r.status_code}")
if r.status_code == 200:
    result = r.json()
    print(f"✅ Inscription réussie!")
    print(f"   Email: {result.get('user', {}).get('email')}")
    token = result.get('access_token')
    
    # Test login
    print("\n2. Test connexion")
    login_data = {"email": "client@wassali.tn", "password": "Test123!"}
    r = requests.post("http://localhost:8000/api/v1/auth/login", json=login_data)
    print(f"Status: {r.status_code}")
    if r.status_code == 200:
        print(f"✅ Connexion réussie!")
        token = r.json().get('access_token')
        
        # Test profil
        print("\n3. Test profil")
        headers = {"Authorization": f"Bearer {token}"}
        r = requests.get("http://localhost:8000/api/v1/users/me", headers=headers)
        print(f"Status: {r.status_code}")
        if r.status_code == 200:
            user = r.json()
            print(f"✅ Profil récupéré!")
            print(f"   Nom: {user.get('name')}")
            print(f"   Email: {user.get('email')}")
    else:
        print(f"❌ Connexion échouée: {r.text[:200]}")
else:
    print(f"❌ Inscription échouée: {r.text[:300]}")

print("\n" + "=" * 60)
