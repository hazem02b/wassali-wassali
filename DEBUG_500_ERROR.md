# Guide de Debug - Erreur 500 sur /auth/register

## Problème
L'endpoint POST /api/v1/auth/register retourne une erreur 500 Internal Server Error.

## Corrections Appliquées
✅ Mise à jour de tous les schémas Pydantic de v1 vers v2:
- `class Config:` → `model_config = ConfigDict(from_attributes=True)`
- 6 schémas corrigés: UserResponse, TripResponse, BookingResponse, ReviewResponse, MessageResponse, NotificationResponse

## Étapes de Test

### 1. Vérifier que le serveur est actif
```powershell
Invoke-WebRequest -Uri "http://localhost:8000/api/v1/docs" -UseBasicParsing | Select-Object StatusCode
# Devrait retourner: 200
```

### 2. Tester l'inscription via Swagger UI (RECOMMANDÉ)
1. Ouvrez: http://localhost:8000/api/v1/docs
2. Trouvez POST /api/v1/auth/register
3. Cliquez "Try it out"
4. Utilisez ce JSON:
```json
{
  "email": "ahmed@transport.ma",
  "password": "Ahmed123!",
  "first_name": "Ahmed",
  "last_name": "Benali",
  "phone": "+212612345678",
  "role": "transporter"
}
```
5. Cliquez "Execute"
6. **Regardez la fenêtre PowerShell du serveur** pour voir les logs d'erreur détaillés

### 3. Vérifier les logs dans la fenêtre PowerShell séparée
La fenêtre PowerShell où tourne le serveur affichera:
- Les requêtes reçues
- Les erreurs Python avec stack trace
- Les problèmes de base de données

### 4. Solutions possibles

#### Si erreur de validation Pydantic:
- Vérifiez que tous les champs requis sont présents
- Vérifiez le format de l'email
- Vérifiez que le mot de passe a 8+ caractères

#### Si erreur de base de données:
```powershell
# Tester la connexion DB
cd c:\Wassaliparceldeliveryapp\backend
C:\Users\HAZEM\AppData\Local\Programs\Python\Python310\python.exe -c "from app.db.database import engine; from sqlalchemy import text; conn = engine.connect(); result = conn.execute(text('SELECT COUNT(*) FROM users')); print('Users count:', result.scalar()); conn.close()"
```

#### Si email déjà enregistré:
```powershell
# Supprimer l'utilisateur existant (depuis Python)
cd c:\Wassaliparceldeliveryapp\backend
C:\Users\HAZEM\AppData\Local\Programs\Python\Python310\python.exe -c "from app.db.database import SessionLocal; from app.models.models import User; db = SessionLocal(); user = db.query(User).filter(User.email == 'ahmed@transport.ma').first(); if user: db.delete(user); db.commit(); print('User deleted'); else: print('User not found'); db.close()"
```

## Serveur Backend

### Démarrer le serveur
```powershell
cd c:\Wassaliparceldeliveryapp\backend
C:\Users\HAZEM\AppData\Local\Programs\Python\Python310\python.exe -m uvicorn main:app --reload --host 127.0.0.1 --port 8000
```

### Redémarrer le serveur
```powershell
# Arrêter
Get-Process | Where-Object { $_.ProcessName -eq "python" -and $_.Path -like "*Python310*" } | Stop-Process -Force

# Démarrer dans une fenêtre séparée
Start-Process powershell -ArgumentList "-NoExit", "-Command", "cd c:\Wassaliparceldeliveryapp\backend; C:\Users\HAZEM\AppData\Local\Programs\Python\Python310\python.exe -m uvicorn main:app --reload --host 127.0.0.1 --port 8000"
```

## Prochaine Étape

**→ Testez via Swagger UI et regardez les logs dans la fenêtre PowerShell du serveur**

http://localhost:8000/api/v1/docs
