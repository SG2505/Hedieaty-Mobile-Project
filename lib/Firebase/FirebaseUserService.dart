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

  Future<bool> updateUser(String userId, Map<String, dynamic> data) async {
    try {
      await _firestore.collection('users').doc(userId).update(data);
      return true;
    } catch (e) {
      print('Error updating user in Firebase: $e');
      return false;
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

  Future<bool> deleteUser(String userId) async {
    try {
      await _firestore.collection('users').doc(userId).delete();
      print('User document deleted successfully.');
      return true;
    } catch (e) {
      print("Error deleting user document: $e");
      return false;
    }
  }
}
