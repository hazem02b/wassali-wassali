// firestore_service.dart - Service Firestore pour les opérations de base de données
import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // ==================== TRIPS ====================

  // Créer un nouveau trajet
  Future<String> createTrip(Map<String, dynamic> tripData) async {
    try {
      DocumentReference docRef = await _db.collection('trips').add({
        ...tripData,
        'createdAt': FieldValue.serverTimestamp(),
        'status': 'active',
      });
      return docRef.id;
    } catch (e) {
      throw Exception('Erreur lors de la création du trajet: $e');
    }
  }

  // Obtenir les trajets (avec filtres optionnels)
  Stream<QuerySnapshot> getTrips({
    String? from,
    String? to,
    String? status = 'active',
  }) {
    Query query = _db.collection('trips');

    if (status != null) {
      query = query.where('status', isEqualTo: status);
    }
    if (from != null && from.isNotEmpty) {
      query = query.where('from', isEqualTo: from);
    }
    if (to != null && to.isNotEmpty) {
      query = query.where('to', isEqualTo: to);
    }

    return query.orderBy('date', descending: false).snapshots();
  }

  // Obtenir un trajet spécifique
  Future<DocumentSnapshot> getTrip(String tripId) async {
    return await _db.collection('trips').doc(tripId).get();
  }

  // Obtenir les trajets d'un transporteur
  Stream<QuerySnapshot> getTransporterTrips(String transporterId) {
    return _db
        .collection('trips')
        .where('transporterId', isEqualTo: transporterId)
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  // Mettre à jour un trajet
  Future<void> updateTrip(String tripId, Map<String, dynamic> data) async {
    await _db.collection('trips').doc(tripId).update(data);
  }

  // Supprimer un trajet
  Future<void> deleteTrip(String tripId) async {
    await _db.collection('trips').doc(tripId).delete();
  }

  // ==================== BOOKINGS ====================

  // Créer une réservation
  Future<String> createBooking(Map<String, dynamic> bookingData) async {
    try {
      // Ajouter la réservation
      DocumentReference docRef = await _db.collection('bookings').add({
        ...bookingData,
        'status': 'pending',
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });

      // Mettre à jour le compteur de réservations du client
      await _db.collection('users').doc(bookingData['clientId']).update({
        'totalBookings': FieldValue.increment(1),
      });

      return docRef.id;
    } catch (e) {
      throw Exception('Erreur lors de la création de la réservation: $e');
    }
  }

  // Obtenir les réservations d'un utilisateur (client)
  Stream<QuerySnapshot> getUserBookings(String userId) {
    return _db
        .collection('bookings')
        .where('clientId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  // Obtenir les réservations d'un transporteur
  Stream<QuerySnapshot> getTransporterBookings(String transporterId) {
    return _db
        .collection('bookings')
        .where('transporterId', isEqualTo: transporterId)
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  // Mettre à jour le statut d'une réservation
  Future<void> updateBookingStatus(String bookingId, String status) async {
    await _db.collection('bookings').doc(bookingId).update({
      'status': status,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  // ==================== MESSAGES ====================

  // Créer ou obtenir une conversation
  Future<String> getOrCreateConversation(String userId1, String userId2) async {
    String conversationId = _getConversationId(userId1, userId2);

    DocumentSnapshot doc = await _db.collection('messages').doc(conversationId).get();

    if (!doc.exists) {
      await _db.collection('messages').doc(conversationId).set({
        'participants': [userId1, userId2],
        'createdAt': FieldValue.serverTimestamp(),
        'lastMessage': '',
        'lastMessageTime': FieldValue.serverTimestamp(),
      });
    }

    return conversationId;
  }

  // Envoyer un message
  Future<void> sendMessage({
    required String conversationId,
    required String senderId,
    required String text,
  }) async {
    await _db.collection('messages').doc(conversationId).collection('messages').add({
      'senderId': senderId,
      'text': text,
      'timestamp': FieldValue.serverTimestamp(),
      'read': false,
    });

    // Mettre à jour le dernier message
    await _db.collection('messages').doc(conversationId).update({
      'lastMessage': text,
      'lastMessageTime': FieldValue.serverTimestamp(),
    });
  }

  // Obtenir les messages d'une conversation
  Stream<QuerySnapshot> getMessages(String conversationId) {
    return _db
        .collection('messages')
        .doc(conversationId)
        .collection('messages')
        .orderBy('timestamp', descending: false)
        .snapshots();
  }

  // Obtenir les conversations d'un utilisateur
  Stream<QuerySnapshot> getUserConversations(String userId) {
    return _db
        .collection('messages')
        .where('participants', arrayContains: userId)
        .orderBy('lastMessageTime', descending: true)
        .snapshots();
  }

  // ==================== REVIEWS ====================

  // Créer un avis
  Future<void> createReview({
    required String transporterId,
    required String clientId,
    required String clientName,
    required String bookingId,
    required int rating,
    required String comment,
  }) async {
    await _db.collection('reviews').add({
      'transporterId': transporterId,
      'clientId': clientId,
      'clientName': clientName,
      'bookingId': bookingId,
      'rating': rating,
      'comment': comment,
      'createdAt': FieldValue.serverTimestamp(),
    });

    // Recalculer la note moyenne du transporteur
    QuerySnapshot reviews = await _db
        .collection('reviews')
        .where('transporterId', isEqualTo: transporterId)
        .get();

    if (reviews.docs.isNotEmpty) {
      double totalRating = 0;
      for (var doc in reviews.docs) {
        totalRating += (doc.data() as Map<String, dynamic>)['rating'];
      }
      double averageRating = totalRating / reviews.docs.length;

      await _db.collection('users').doc(transporterId).update({
        'rating': averageRating,
        'reviews': reviews.docs.length,
      });
    }
  }

  // Obtenir les avis d'un transporteur
  Stream<QuerySnapshot> getTransporterReviews(String transporterId) {
    return _db
        .collection('reviews')
        .where('transporterId', isEqualTo: transporterId)
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  // ==================== NOTIFICATIONS ====================

  // Créer une notification
  Future<void> createNotification({
    required String userId,
    required String title,
    required String message,
    required String type,
    String? relatedId,
  }) async {
    await _db.collection('notifications').add({
      'userId': userId,
      'title': title,
      'message': message,
      'type': type,
      'relatedId': relatedId,
      'read': false,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  // Obtenir les notifications d'un utilisateur
  Stream<QuerySnapshot> getUserNotifications(String userId) {
    return _db
        .collection('notifications')
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .limit(50)
        .snapshots();
  }

  // Marquer une notification comme lue
  Future<void> markNotificationAsRead(String notificationId) async {
    await _db.collection('notifications').doc(notificationId).update({
      'read': true,
    });
  }

  // ==================== HELPERS ====================

  String _getConversationId(String userId1, String userId2) {
    List<String> ids = [userId1, userId2]..sort();
    return '${ids[0]}_${ids[1]}';
  }
}
