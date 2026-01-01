"""
Script de test des APIs pour l'application mobile Wassali
"""
import requests
import json
from datetime import datetime, timedelta

BASE_URL = "http://localhost:8000/api"
token = None
user_id = None
trip_id = None

def print_test(name, success, details=""):
    status = "✅" if success else "❌"
    print(f"{status} {name}")
    if details:
        print(f"   {details}")

def test_health():
    """Test si le serveur répond"""
    try:
        response = requests.get("http://localhost:8000")
        print_test("Backend accessible", response.status_code == 200)
        return response.status_code == 200
    except Exception as e:
        print_test("Backend accessible", False, str(e))
        return False

def test_register():
    """Test inscription client"""
    global token, user_id
    
    data = {
        "email": "client@wassali.tn",
        "password": "Client123!",
        "name": "Ahmed Client",
        "phone": "+216 98 123 456"
    }
    
    try:
        response = requests.post(f"{BASE_URL}/auth/register", json=data)
        if response.status_code == 200:
            result = response.json()
            token = result.get("access_token")
            user_id = result.get("user", {}).get("id")
            print_test("Inscription client", True, f"User ID: {user_id}")
            return True
        else:
            print_test("Inscription client", False, response.text)
            return False
    except Exception as e:
        print_test("Inscription client", False, str(e))
        return False

def test_register_transporter():
    """Test inscription transporteur"""
    data = {
        "email": "transporter@wassali.tn",
        "password": "Trans123!",
        "name": "Mohamed Transporteur",
        "phone": "+216 22 987 654",
        "vehicle_type": "Camionnette",
        "vehicle_info": "Peugeot Partner"
    }
    
    try:
        response = requests.post(f"{BASE_URL}/auth/register/transporter", json=data)
        success = response.status_code == 200
        print_test("Inscription transporteur", success)
        return success
    except Exception as e:
        print_test("Inscription transporteur", False, str(e))
        return False

def test_login():
    """Test connexion"""
    global token, user_id
    
    data = {
        "email": "client@wassali.tn",
        "password": "Client123!"
    }
    
    try:
        response = requests.post(f"{BASE_URL}/auth/login", json=data)
        if response.status_code == 200:
            result = response.json()
            token = result.get("access_token")
            user_id = result.get("user", {}).get("id")
            print_test("Connexion", True, f"Token: {token[:30]}...")
            return True
        else:
            print_test("Connexion", False, response.text)
            return False
    except Exception as e:
        print_test("Connexion", False, str(e))
        return False

def test_me():
    """Test récupération profil"""
    headers = {"Authorization": f"Bearer {token}"}
    
    try:
        response = requests.get(f"{BASE_URL}/auth/me", headers=headers)
        if response.status_code == 200:
            user = response.json()
            print_test("Profil utilisateur", True, f"Name: {user.get('name')}")
            return True
        else:
            print_test("Profil utilisateur", False, response.text)
            return False
    except Exception as e:
        print_test("Profil utilisateur", False, str(e))
        return False

def test_create_trip():
    """Test création de trajet"""
    global trip_id
    
    headers = {"Authorization": f"Bearer {token}"}
    
    departure = datetime.now() + timedelta(days=7)
    arrival = departure + timedelta(hours=2)
    
    data = {
        "origin_city": "Tunis",
        "origin_country": "Tunisie",
        "destination_city": "Sousse",
        "destination_country": "Tunisie",
        "departure_date": departure.isoformat(),
        "arrival_date": arrival.isoformat(),
        "available_weight": 50.0,
        "price_per_kg": 5.0,
        "vehicle_type": "Voiture",
        "vehicle_info": "Peugeot 308",
        "description": "Trajet direct Tunis-Sousse"
    }
    
    try:
        response = requests.post(f"{BASE_URL}/trips", json=data, headers=headers)
        if response.status_code == 200:
            trip = response.json()
            trip_id = trip.get("id")
            print_test("Création trajet", True, f"Trip ID: {trip_id}")
            return True
        else:
            print_test("Création trajet", False, response.text)
            return False
    except Exception as e:
        print_test("Création trajet", False, str(e))
        return False

def test_search_trips():
    """Test recherche de trajets"""
    headers = {"Authorization": f"Bearer {token}"}
    
    try:
        response = requests.get(
            f"{BASE_URL}/trips/search?origin_city=Tunis&destination_city=Sousse",
            headers=headers
        )
        if response.status_code == 200:
            trips = response.json()
            count = len(trips) if isinstance(trips, list) else 0
            print_test("Recherche trajets", True, f"{count} trajet(s) trouvé(s)")
            return True
        else:
            print_test("Recherche trajets", False, response.text)
            return False
    except Exception as e:
        print_test("Recherche trajets", False, str(e))
        return False

def test_my_trips():
    """Test mes trajets"""
    headers = {"Authorization": f"Bearer {token}"}
    
    try:
        response = requests.get(f"{BASE_URL}/trips/my-trips", headers=headers)
        if response.status_code == 200:
            trips = response.json()
            count = len(trips) if isinstance(trips, list) else 0
            print_test("Mes trajets", True, f"{count} trajet(s)")
            return True
        else:
            print_test("Mes trajets", False, response.text)
            return False
    except Exception as e:
        print_test("Mes trajets", False, str(e))
        return False

def test_create_booking():
    """Test création de réservation"""
    if not trip_id:
        print_test("Création réservation", False, "Pas de trajet disponible")
        return False
    
    headers = {"Authorization": f"Bearer {token}"}
    
    data = {
        "trip_id": trip_id,
        "package_description": "Colis fragile - Electronique",
        "weight": 5.0,
        "notes": "Manipuler avec précaution"
    }
    
    try:
        response = requests.post(f"{BASE_URL}/bookings", json=data, headers=headers)
        if response.status_code == 200:
            booking = response.json()
            print_test("Création réservation", True, f"Booking ID: {booking.get('id')}")
            return True
        else:
            print_test("Création réservation", False, response.text)
            return False
    except Exception as e:
        print_test("Création réservation", False, str(e))
        return False

def test_my_bookings():
    """Test mes réservations"""
    headers = {"Authorization": f"Bearer {token}"}
    
    try:
        response = requests.get(f"{BASE_URL}/bookings/my-bookings", headers=headers)
        if response.status_code == 200:
            bookings = response.json()
            count = len(bookings) if isinstance(bookings, list) else 0
            print_test("Mes réservations", True, f"{count} réservation(s)")
            return True
        else:
            print_test("Mes réservations", False, response.text)
            return False
    except Exception as e:
        print_test("Mes réservations", False, str(e))
        return False

def test_conversations():
    """Test liste des conversations"""
    headers = {"Authorization": f"Bearer {token}"}
    
    try:
        response = requests.get(f"{BASE_URL}/conversations", headers=headers)
        if response.status_code == 200:
            conversations = response.json()
            count = len(conversations) if isinstance(conversations, list) else 0
            print_test("Conversations", True, f"{count} conversation(s)")
            return True
        else:
            print_test("Conversations", False, response.text)
            return False
    except Exception as e:
        print_test("Conversations", False, str(e))
        return False

def run_all_tests():
    """Exécute tous les tests"""
    print("=" * 60)
    print("  🧪 TESTS DES APIs MOBILE WASSALI")
    print("=" * 60)
    print()
    
    # Test connexion backend
    print("📡 Test de connexion")
    print("-" * 60)
    if not test_health():
        print("\n❌ Le backend n'est pas accessible!")
        print("   Démarrez-le avec: python start.py")
        return
    print()
    
    # Tests d'authentification
    print("🔐 Tests d'authentification")
    print("-" * 60)
    test_register()
    test_register_transporter()
    test_login()
    test_me()
    print()
    
    # Tests des trajets
    print("🚚 Tests des trajets")
    print("-" * 60)
    test_create_trip()
    test_search_trips()
    test_my_trips()
    print()
    
    # Tests des réservations
    print("📦 Tests des réservations")
    print("-" * 60)
    test_create_booking()
    test_my_bookings()
    print()
    
    # Tests des messages
    print("💬 Tests de messagerie")
    print("-" * 60)
    test_conversations()
    print()
    
    print("=" * 60)
    print("  ✅ TESTS TERMINÉS")
    print("=" * 60)
    print()
    print("📖 Documentation complète: http://localhost:8000/docs")
    print()

if __name__ == "__main__":
    run_all_tests()
