// auth_service.dart - Service d'authentification Firebase
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Utilisateur actuel
  User? get currentUser => _auth.currentUser;

  // Stream de l'état d'authentification
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Inscription
  Future<Map<String, dynamic>> signUp({
    required String email,
    required String password,
    required String name,
    required String phone,
    required String type,
  }) async {
    try {
      // Créer l'utilisateur dans Firebase Auth
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Créer le profil dans Firestore
      await _firestore.collection('users').doc(userCredential.user!.uid).set({
        'email': email,
        'name': name,
        'phone': phone,
        'type': type,
        'verified': false,
        'totalBookings': 0,
        'totalSpent': 0,
        'createdAt': FieldValue.serverTimestamp(),
      });

      // Si transporteur, ajouter des champs supplémentaires
      if (type == 'transporter') {
        await _firestore.collection('users').doc(userCredential.user!.uid).update({
          'rating': 0.0,
          'reviews': 0,
          'totalTrips': 0,
        });
      }

      return {
        'success': true,
        'user': userCredential.user,
        'message': 'Inscription réussie!',
      };
    } on FirebaseAuthException catch (e) {
      String message;
      switch (e.code) {
        case 'email-already-in-use':
          message = 'Cet email est déjà utilisé.';
          break;
        case 'invalid-email':
          message = 'Email invalide.';
          break;
        case 'weak-password':
          message = 'Le mot de passe est trop faible.';
          break;
        default:
          message = 'Erreur: ${e.message}';
      }
      return {'success': false, 'message': message};
    } catch (e) {
      return {'success': false, 'message': 'Une erreur est survenue.'};
    }
  }

  // Connexion
  Future<Map<String, dynamic>> signIn({
    required String email,
    required String password,
  }) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      return {
        'success': true,
        'user': userCredential.user,
        'message': 'Connexion réussie!',
      };
    } on FirebaseAuthException catch (e) {
      String message;
      switch (e.code) {
        case 'user-not-found':
          message = 'Aucun utilisateur trouvé avec cet email.';
          break;
        case 'wrong-password':
          message = 'Mot de passe incorrect.';
          break;
        case 'invalid-email':
          message = 'Email invalide.';
          break;
        default:
          message = 'Erreur: ${e.message}';
      }
      return {'success': false, 'message': message};
    } catch (e) {
      return {'success': false, 'message': 'Une erreur est survenue.'};
    }
  }

  // Déconnexion
  Future<void> signOut() async {
    await _auth.signOut();
  }

  // Réinitialiser le mot de passe
  Future<Map<String, dynamic>> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      return {
        'success': true,
        'message': 'Email de réinitialisation envoyé!',
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'Erreur lors de l\'envoi de l\'email.',
      };
    }
  }

  // Obtenir les données utilisateur depuis Firestore
  Future<DocumentSnapshot> getUserData(String userId) async {
    return await _firestore.collection('users').doc(userId).get();
  }

  // Mettre à jour le profil
  Future<void> updateProfile(String userId, Map<String, dynamic> data) async {
    await _firestore.collection('users').doc(userId).update(data);
  }

  // Vérifier si l'email est vérifié
  Future<bool> isEmailVerified() async {
    await currentUser?.reload();
    return currentUser?.emailVerified ?? false;
  }

  // Envoyer l'email de vérification
  Future<void> sendEmailVerification() async {
    await currentUser?.sendEmailVerification();
  }
}
