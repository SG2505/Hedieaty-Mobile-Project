import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hedieaty/Model/AppUser.dart';
import 'package:hedieaty/main.dart';

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

  Future<void> addFriend(
      {required String currentUserId, required String phoneNumber}) async {
    try {
      if (phoneNumber == currentUser.phoneNumber) {
        print("You can't add yourself as a friend.");
        return;
      }
      // Search for the user by phone number
      final querySnapshot = await _firestore
          .collection('users')
          .where('phoneNumber', isEqualTo: phoneNumber)
          .get();

      if (querySnapshot.docs.isEmpty) {
        print("User with this phone number not found.");
        return;
      }

      final friendUserDoc = querySnapshot.docs.first;
      final friendId = friendUserDoc.id;

      // Check if they are already friends
      final friendsSnapshot = await _firestore
          .collection('friends')
          .where('userId', isEqualTo: currentUserId)
          .where('friendId', isEqualTo: friendId)
          .get();

      if (friendsSnapshot.docs.isNotEmpty) {
        print("You are already friends.");
        return;
      }

      // Add the friend to the friends collection
      await _firestore.collection('friends').add({
        'userId': currentUserId,
        'friendId': friendId,
      });

      print("Friend added successfully.");
    } catch (e) {
      print("Error adding friend: $e");
    }
  }
}
