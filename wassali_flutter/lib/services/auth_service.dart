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
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
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
        await _firestore
            .collection('users')
            .doc(userCredential.user!.uid)
            .update({
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
        case 'operation-not-allowed':
          message = 'Opération non autorisée.';
          break;
        default:
          message = 'Erreur: ${e.message}';
      }
      return {'success': false, 'message': message};
    } catch (e) {
      return {'success': false, 'message': 'Une erreur est survenue: $e'};
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
        case 'user-disabled':
          message = 'Ce compte a été désactivé.';
          break;
        case 'invalid-credential':
          message = 'Email ou mot de passe incorrect.';
          break;
        default:
          message = 'Erreur: ${e.message}';
      }
      return {'success': false, 'message': message};
    } catch (e) {
      return {'success': false, 'message': 'Une erreur est survenue: $e'};
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
    } on FirebaseAuthException catch (e) {
      String message;
      switch (e.code) {
        case 'user-not-found':
          message = 'Aucun utilisateur trouvé avec cet email.';
          break;
        case 'invalid-email':
          message = 'Email invalide.';
          break;
        default:
          message = 'Erreur lors de l\'envoi de l\'email: ${e.message}';
      }
      return {'success': false, 'message': message};
    } catch (e) {
      return {
        'success': false,
        'message': 'Erreur lors de l\'envoi de l\'email: $e',
      };
    }
  }

  // Obtenir les données utilisateur depuis Firestore
  Future<DocumentSnapshot> getUserData(String userId) async {
    return await _firestore.collection('users').doc(userId).get();
  }

  // Stream des données utilisateur
  Stream<DocumentSnapshot> getUserDataStream(String userId) {
    return _firestore.collection('users').doc(userId).snapshots();
  }

  // Mettre à jour le profil
  Future<void> updateProfile(
      String userId, Map<String, dynamic> data) async {
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

  // Changer le mot de passe
  Future<Map<String, dynamic>> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      final user = currentUser;
      if (user == null) {
        return {'success': false, 'message': 'Utilisateur non connecté'};
      }

      // Réauthentifier l'utilisateur
      final credential = EmailAuthProvider.credential(
        email: user.email!,
        password: currentPassword,
      );

      await user.reauthenticateWithCredential(credential);

      // Changer le mot de passe
      await user.updatePassword(newPassword);

      return {
        'success': true,
        'message': 'Mot de passe changé avec succès!',
      };
    } on FirebaseAuthException catch (e) {
      String message;
      switch (e.code) {
        case 'wrong-password':
          message = 'Mot de passe actuel incorrect.';
          break;
        case 'weak-password':
          message = 'Le nouveau mot de passe est trop faible.';
          break;
        default:
          message = 'Erreur: ${e.message}';
      }
      return {'success': false, 'message': message};
    } catch (e) {
      return {'success': false, 'message': 'Une erreur est survenue: $e'};
    }
  }

  // Supprimer le compte
  Future<Map<String, dynamic>> deleteAccount(String password) async {
    try {
      final user = currentUser;
      if (user == null) {
        return {'success': false, 'message': 'Utilisateur non connecté'};
      }

      // Réauthentifier l'utilisateur
      final credential = EmailAuthProvider.credential(
        email: user.email!,
        password: password,
      );

      await user.reauthenticateWithCredential(credential);

      // Supprimer les données Firestore
      await _firestore.collection('users').doc(user.uid).delete();

      // Supprimer l'utilisateur Firebase Auth
      await user.delete();

      return {
        'success': true,
        'message': 'Compte supprimé avec succès',
      };
    } on FirebaseAuthException catch (e) {
      return {'success': false, 'message': 'Erreur: ${e.message}'};
    } catch (e) {
      return {'success': false, 'message': 'Une erreur est survenue: $e'};
    }
  }
}
