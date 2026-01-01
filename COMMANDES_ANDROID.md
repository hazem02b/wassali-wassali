# 🚀 COMMANDES RAPIDES - TEST ANDROID

## Démarrer tout en une fois

### Windows (PowerShell)
```powershell
# Terminal 1: Backend
cd backend
python start.py

# Terminal 2: Mobile (Android Emulator)
cd wassali_mobile_app
flutter run
```

### Ou utiliser le script
```bash
# Double-cliquer sur:
launch_android.bat
```

## Configuration actuelle

✅ **api_config.dart mis à jour**
- Base URL: `http://10.0.2.2:8000/api/v1`
- Tous les endpoints configurés
- Timeouts: 30 secondes

## Commandes utiles

### Lister les devices
```bash
flutter devices
```

### Lancer sur un device spécifique
```bash
flutter run -d <device-id>
```

### Lancer avec hot reload
```bash
flutter run --hot
```

### Voir les logs
```bash
flutter logs
```

### Clean + rebuild
```bash
flutter clean
flutter pub get
flutter run
```

## Test de connexion

Depuis l'émulateur Android, le backend est accessible à:
```
http://10.0.2.2:8000
```

Test rapide:
```bash
# Dans l'émulateur (adb shell)
curl http://10.0.2.2:8000/health
```

## Résolution de problèmes

### "Connection refused"
1. Vérifier backend: `curl http://localhost:8000/health`
2. Vérifier URL: Doit être `10.0.2.2` pour émulateur
3. Redémarrer émulateur

### "404 Not Found"
- Vérifier que l'URL contient `/api/v1`
- Backend doit être sur le bon préfixe

### "422 Unprocessable Entity"
- Champs requis: `name`, `email`, `password`, `phone`, `role`
- Role doit être: `client` ou `transporter`
- Login nécessite le champ `role`

## Guide complet

Voir: [GUIDE_TEST_ANDROID_STUDIO.md](./GUIDE_TEST_ANDROID_STUDIO.md)
