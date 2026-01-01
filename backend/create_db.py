import psycopg2
from psycopg2 import sql

try:
    # Connect to postgres database
    conn = psycopg2.connect(
        host='localhost',
        port=5432,
        user='postgres',
        password='postgres',
        database='postgres',
        options='-c client_encoding=UTF8'
    )
    conn.autocommit = True
    cur = conn.cursor()
    
    # Check if database exists
    cur.execute("SELECT 1 FROM pg_database WHERE datname='wassali_db'")
    exists = cur.fetchone()
    
    if not exists:
        cur.execute(sql.SQL("CREATE DATABASE {}").format(sql.Identifier('wassali_db')))
        print("✅ Database 'wassali_db' created successfully!")
    else:
        print("ℹ️  Database 'wassali_db' already exists")
    
    cur.close()
    conn.close()
    
except Exception as e:
    print(f"❌ Error: {e}")
