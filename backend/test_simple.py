import requests

print("Test inscription...")
data = {
    "email": "test@wassali.tn",
    "password": "Test123!",
    "full_name": "Test User",
    "phone": "+216 98 111 222",
    "role": "customer"
}

r = requests.post("http://localhost:8000/api/v1/auth/register", json=data)
print(f"Status: {r.status_code}")
print(f"Response: {r.text}")
