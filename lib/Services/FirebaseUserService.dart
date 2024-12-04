import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hedieaty/Model/AppUser.dart';

class FirebaseUserService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> createUser(AppUser user) async {
    try {
      await _firestore.collection('users').doc(user.id).set(user.toJson());
      print('User document created successfully.');
    } catch (e) {
      print("Error creating user document: $e");
    }
  }

  Future<void> updateUser(AppUser user) async {
    try {
      await _firestore.collection('users').doc(user.id).update(user.toJson());
      print('User document updated successfully.');
    } catch (e) {
      print("Error updating user document: $e");
    }
  }

  Future<Map<String, dynamic>?> fetchUser(String uid) async {
    try {
      final fetchedData = await _firestore.collection('users').doc(uid).get();
      if (fetchedData.exists) {
        print('User data fetched successfully.');
        return fetchedData.data();
      }
    } catch (e) {
      print("Error fetching user document: $e");
    }
    return null;
  }
}
