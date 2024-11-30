import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hedieaty/Model/AppUser.dart';

class FirebaseUserService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Create a new user in Firestore.
  Future<void> createUser(AppUser user) async {
    try {
      await _firestore.collection('users').doc(user.id).set(user.toJson());
      print('User document created successfully.');
    } catch (e) {
      print("Error creating user document: $e");
    }
  }
}
