# 🚚 Système de Gestion des Trajets pour Transporteurs

## ✅ Fonctionnalités implémentées

### 1. Voir les trajets publiés
- Page "Mes trajets" accessible depuis l'onglet "Trips" du menu
- Deux onglets: **Active** et **Passés**
- Affichage du nombre de réservations par trajet
- Indication des réservations payées (✅)

### 2. Modifier un trajet
- Bouton ✏️ "Modifier" pour chaque trajet actif
- Modal d'édition avec champs:
  - Date de départ
  - Poids disponible
  - Prix par kg
  - Notes
- **Mise à jour automatique pour les clients** - les changements sont visibles immédiatement

### 3. Supprimer un trajet
- Bouton 🗑️ "Supprimer" pour chaque trajet actif
- **Protection des trajets payés**: Impossible de supprimer si des réservations ont été payées
- **Annulation automatique** des réservations non payées lors de la suppression

## 🔄 Flux de mise à jour

```
TRANSPORTEUR modifie le trajet
    ↓
Backend met à jour Trip dans la BDD
    ↓
CLIENT rafraîchit la page de recherche
    ↓
✅ Changements visibles immédiatement
```

**Les clients voient automatiquement:**
- Nouveau prix par kg
- Nouveau poids disponible
- Nouvelle date de départ
- Nouvelles notes

## 🗑️ Flux de suppression

### Cas 1: Aucune réservation payée

```
TRANSPORTEUR clique sur Supprimer
    ↓
Backend vérifie: 0 réservations payées ✅
    ↓
Backend annule toutes les réservations non payées
    ↓
Backend marque le trajet comme is_active = False
    ↓
CLIENT voit ses réservations passées en "cancelled"
    ↓
✅ Trajet supprimé avec succès
```

### Cas 2: Des réservations ont été payées

```
TRANSPORTEUR clique sur Supprimer
    ↓
Backend vérifie: 2 réservations payées ❌
    ↓
Backend retourne erreur 400
    ↓
Frontend affiche:
"Impossible de supprimer ce trajet. 
2 réservation(s) payée(s) existe(nt)."
    ↓
❌ Suppression bloquée
```

## 🎯 Règles de protection

### Pour les clients:
1. ✅ Si réservation NON payée + trajet supprimé → Status: `cancelled`, message "Trajet supprimé par le transporteur"
2. ✅ Si réservation PAYÉE → Le trajet **NE PEUT PAS** être supprimé
3. ✅ Mises à jour visibles en temps réel lors de la recherche

### Pour les transporteurs:
1. ✅ Peut modifier n'importe quel trajet actif
2. ✅ Peut supprimer SEULEMENT si aucune réservation payée
3. ✅ Voit le nombre de réservations et lesquelles sont payées

## 📱 Interface utilisateur

### Page "Mes trajets" (MyTrips.tsx)

**Onglet "Active":**
```
┌─────────────────────────────────────────┐
│ 📍 Tunis → Paris                    ✏️🗑️ │
│ 📅 26 Jan 2025                          │
│ ⚖️ 45/50kg    💰 15.50€/kg             │
│ ─────────────────────────────────────   │
│ 📦 3 réservation(s)  ✅ 1 payée(s)      │
└─────────────────────────────────────────┘
```

**Boutons disponibles:**
- ✏️ **Modifier**: Ouvre le modal d'édition
- 🗑️ **Supprimer**: Ouvre la confirmation de suppression

### Modal d'édition

```
┌────────── Modifier le trajet ──────────┐
│                                    ✕   │
│ Date de départ                         │
│ [2025-01-26T10:00]                     │
│                                        │
│ Poids disponible (kg)                  │
│ [45.0]                                 │
│                                        │
│ Prix par kg (€)                        │
│ [15.50]                                │
│                                        │
│ Notes (optionnel)                      │
│ [Trajet rapide, voiture climatisée]   │
│                                        │
│ [Annuler]        [Enregistrer]        │
└────────────────────────────────────────┘
```

### Dialog de suppression

**Sans réservations payées:**
```
┌────────── Confirmer la suppression ─────┐
│ ⚠️                                       │
│ Voulez-vous vraiment supprimer le       │
│ trajet Tunis → Paris ?                  │
│                                         │
│ Les réservations non payées seront     │
│ également supprimées.                   │
│                                         │
│ [Annuler]        [Supprimer]           │
└─────────────────────────────────────────┘
```

**Avec réservations payées:**
```
┌────────── Suppression impossible ───────┐
│ 🔴                                       │
│ Impossible de supprimer ce trajet.      │
│ 2 réservation(s) payée(s) existe(nt).   │
│                                         │
│              [Fermer]                   │
└─────────────────────────────────────────┘
```

## 🔧 Implémentation technique

### Frontend (MyTrips.tsx)

```typescript
// Vérifier les réservations payées avant suppression
const handleDelete = (trip: Trip) => {
  const paidBookings = bookings.filter(
    b => b.trip_id === trip.id && b.is_paid
  );

  if (paidBookings.length > 0) {
    setDeleteError(`Impossible de supprimer...`);
  }
};

// Modifier un trajet
const handleUpdateTrip = async () => {
  await apiService.updateTrip(
    editingTrip.id, 
    editingTrip, 
    token
  );
  alert('✅ Trajet mis à jour\n📢 Visible pour les clients!');
};
```

### Backend (trips.py)

```python
@router.delete("/{trip_id}")
async def delete_trip(trip_id: int, ...):
    # Vérifier les réservations payées
    paid_bookings = db.query(Booking).filter(
        Booking.trip_id == trip_id,
        Booking.is_paid == True
    ).count()
    
    if paid_bookings > 0:
        raise HTTPException(
            status_code=400,
            detail=f"Cannot delete trip with {paid_bookings} paid booking(s)"
        )
    
    # Annuler les réservations non payées
    unpaid_bookings = db.query(Booking).filter(
        Booking.trip_id == trip_id,
        Booking.is_paid == False
    ).all()
    
    for booking in unpaid_bookings:
        booking.status = 'cancelled'
    
    # Soft delete
    trip.is_active = False
    db.commit()
```

### API Service (api.service.ts)

```typescript
async updateTrip(tripId: number, tripData: any, token: string) {
  return this.put(`${API_CONFIG.ENDPOINTS.TRIPS}/${tripId}`, tripData, token);
}

async deleteTrip(tripId: number, token: string) {
  return this.delete(`${API_CONFIG.ENDPOINTS.TRIPS}/${tripId}`, token);
}
```

## 📋 Endpoints API

### GET /api/v1/trips/my
Récupère tous les trajets du transporteur connecté
```json
Response: [
  {
    "id": 1,
    "origin_city": "Tunis",
    "destination_city": "Paris",
    "departure_date": "2025-01-26T10:00:00",
    "max_weight": 50,
    "available_weight": 45,
    "price_per_kg": 15.50,
    "is_active": true
  }
]
```

### PUT /api/v1/trips/{trip_id}
Met à jour un trajet
```json
Request: {
  "departure_date": "2025-01-27T10:00:00",
  "available_weight": 40,
  "price_per_kg": 16.00,
  "notes": "Nouveau prix"
}

Response: {
  "id": 1,
  "origin_city": "Tunis",
  "destination_city": "Paris",
  "departure_date": "2025-01-27T10:00:00",
  "available_weight": 40,
  "price_per_kg": 16.00,
  "notes": "Nouveau prix"
}
```

### DELETE /api/v1/trips/{trip_id}
Supprime un trajet (si aucune réservation payée)
```json
Success: 204 No Content

Error (si réservations payées): 
{
  "detail": "Cannot delete trip with 2 paid booking(s)"
}
```

## ✅ Avantages du système

### Pour les transporteurs:
1. 🎯 Contrôle total sur leurs trajets
2. 📊 Visibilité sur les réservations et paiements
3. 🔒 Protection contre la suppression accidentelle de trajets payés
4. ⚡ Modifications en temps réel

### Pour les clients:
1. 🔄 Informations toujours à jour
2. 🛡️ Protection des réservations payées
3. 📢 Notification si trajet supprimé (status cancelled)
4. 💰 Aucun paiement perdu

## 🚀 Flux complet d'utilisation

### Scénario 1: Modification de prix

1. Transporteur va dans "Mes trajets"
2. Clique sur ✏️ pour le trajet Paris → Lyon
3. Change le prix de 12€/kg à 15€/kg
4. Clique "Enregistrer"
5. ✅ Message: "Trajet mis à jour - Les clients verront les changements!"
6. Client cherche Paris → Lyon
7. Voit le nouveau prix: 15€/kg

### Scénario 2: Suppression avec réservations non payées

1. Transporteur a un trajet Tunis → Paris
2. 2 clients ont réservé (non payé)
3. Transporteur clique 🗑️ "Supprimer"
4. Confirmation: "Les réservations non payées seront supprimées"
5. Confirme la suppression
6. ✅ Trajet supprimé
7. Clients voient status "cancelled" avec message

### Scénario 3: Tentative de suppression avec paiements

1. Transporteur a un trajet Berlin → Rome
2. 3 clients ont réservé, 2 ont payé
3. Transporteur clique 🗑️ "Supprimer"
4. ❌ Message: "Impossible de supprimer - 2 réservations payées"
5. Bouton "Supprimer" désactivé
6. Trajet reste actif

## 📝 Notes importantes

- Les trajets ne sont jamais vraiment supprimés (soft delete avec `is_active = False`)
- Les bookings non payés sont annulés (`status = 'cancelled'`)
- Les modifications sont instantanées pour tous les utilisateurs
- Aucune notification push pour le moment (future feature)
