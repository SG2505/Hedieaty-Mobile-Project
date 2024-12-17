import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hedieaty/Model/Gift.dart';

class FirebaseGiftService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<bool> createGift(Gift gift) async {
    try {
      await _firestore.collection('gifts').doc(gift.id).set(gift.toJson());
      return true;
    } catch (e) {
      print("Error adding gift: $e");
      return false;
    }
  }

  Future<Gift?> getGiftById(String giftId) async {
    try {
      final doc = await _firestore.collection('gifts').doc(giftId).get();
      if (doc.exists) {
        return Gift.fromJson(doc.data() as Map<String, dynamic>);
      }
      return null;
    } catch (e) {
      print("Error getting gift by ID: $e");
      return null;
    }
  }

  Future<bool> updateGift(Gift gift) async {
    try {
      await _firestore.collection('gifts').doc(gift.id).update(gift.toJson());
      return true;
    } catch (e) {
      print("Error updating gift: $e");
      return false;
    }
  }

  Future<bool> deleteGift(String giftId) async {
    try {
      await _firestore.collection('gifts').doc(giftId).delete();
      return true;
    } catch (e) {
      print("Error deleting gift: $e");
      return false;
    }
  }

  Future<bool> deleteGiftsByEventId(String eventId) async {
    try {
      final querySnapshot = await _firestore
          .collection('gifts')
          .where('eventId', isEqualTo: eventId)
          .get();

      for (var doc in querySnapshot.docs) {
        await doc.reference.delete();
      }

      return true;
    } catch (e) {
      print("Error deleting gifts by eventId: $e");
      return false;
    }
  }

  Future<List<Gift>> getGiftsByEvent(String eventId) async {
    try {
      final querySnapshot = await _firestore
          .collection('gifts')
          .where('eventId', isEqualTo: eventId)
          .get();

      return querySnapshot.docs
          .map((doc) => Gift.fromJson(doc.data()))
          .toList();
    } catch (e) {
      print("Error getting gifts for event: $e");
      return [];
    }
  }
}
