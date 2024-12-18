import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Public method to get the Firestore instance
  FirebaseFirestore get db => _db;

  Future<void> saveUserProfile({
    required String? userId,
    required String name,
    required String? skinType,
    required int? age,
    required String? gender,
  }) async {
    if (userId != null) {
      await _db.collection('users').doc(userId).set({
        'name': name,
        'skinType': skinType,
        'age': age,
        'gender': gender,
      });
    }
  }
}
