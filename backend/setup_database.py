import psycopg2
from psycopg2.extensions import ISOLATION_LEVEL_AUTOCOMMIT
import sys

def create_database():
    """Crée la base de données wassali_db"""
    
    # Paramètres de connexion
    params = {
        'host': 'localhost',
        'port': 5432,
        'user': 'postgres',
        'password': 'postgres',
        'database': 'postgres'
    }
    
    print("=" * 50)
    print("  CREATION BASE DE DONNEES WASSALI")
    print("=" * 50)
    print()
    
    try:
        # Connexion au serveur PostgreSQL
        print("📡 Connexion à PostgreSQL...")
        conn = psycopg2.connect(**params)
        conn.set_isolation_level(ISOLATION_LEVEL_AUTOCOMMIT)
        cur = conn.cursor()
        
        # Vérifier si la base existe déjà
        print("🔍 Vérification de l'existence de la base...")
        cur.execute("SELECT 1 FROM pg_database WHERE datname='wassali_db'")
        exists = cur.fetchone()
        
        if exists:
            print("ℹ️  La base de données 'wassali_db' existe déjà")
            print()
            
            # Afficher les informations
            cur.execute("""
                SELECT 
                    pg_database.datname,
                    pg_size_pretty(pg_database_size(pg_database.datname)) AS size,
                    pg_encoding_to_char(encoding) AS encoding
                FROM pg_database
                WHERE datname = 'wassali_db'
            """)
            info = cur.fetchone()
            if info:
                print(f"   Nom: {info[0]}")
                print(f"   Taille: {info[1]}")
                print(f"   Encodage: {info[2]}")
        else:
            # Créer la base de données
            print("🔨 Création de la base de données 'wassali_db'...")
            cur.execute("""
                CREATE DATABASE wassali_db
                WITH 
                OWNER = postgres
                ENCODING = 'UTF8'
                LC_COLLATE = 'C'
                LC_CTYPE = 'C'
                TEMPLATE = template0
                CONNECTION LIMIT = -1
            """)
            print()
            print("✅ Base de données 'wassali_db' créée avec succès!")
        
        # Vérifier les tables
        cur.close()
        conn.close()
        
        # Se connecter à la nouvelle base
        params['database'] = 'wassali_db'
        conn = psycopg2.connect(**params)
        cur = conn.cursor()
        
        # Lister les tables
        cur.execute("""
            SELECT tablename 
            FROM pg_tables 
            WHERE schemaname = 'public'
            ORDER BY tablename
        """)
        tables = cur.fetchall()
        
        print()
        print("📊 Tables dans wassali_db:")
        if tables:
            for table in tables:
                print(f"   - {table[0]}")
        else:
            print("   (Aucune table - seront créées au démarrage du backend)")
        
        cur.close()
        conn.close()
        
        print()
        print("=" * 50)
        print("✅ CONFIGURATION TERMINÉE")
        print("=" * 50)
        print()
        print("🚀 Prochaine étape: Démarrer le backend")
        print("   Commande: python -m uvicorn main:app --reload --port 8000")
        print()
        
        return True
        
    except psycopg2.OperationalError as e:
        print()
        print("❌ ERREUR DE CONNEXION")
        print()
        print("Le serveur PostgreSQL est peut-être:")
        print("  1. Non démarré")
        print("  2. Utilise un mot de passe différent")
        print()
        print(f"Détails: {e}")
        print()
        print("Solution:")
        print("  - Vérifiez que PostgreSQL est démarré")
        print("  - Modifiez le mot de passe dans ce script si nécessaire")
        print()
        return False
        
    except Exception as e:
        print()
        print(f"❌ ERREUR: {e}")
        print()
        return False

if __name__ == "__main__":
    success = create_database()
    sys.exit(0 if success else 1)
