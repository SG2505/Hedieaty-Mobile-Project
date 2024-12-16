import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hedieaty/Model/Gift.dart';

class FirebaseGiftService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<bool> createGift(String userId, int eventId, Gift gift) async {
    try {
      final querySnapshot = await _firestore
          .collection('events')
          .where('userId', isEqualTo: userId)
          .where('eventId', isEqualTo: eventId)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        final eventDocRef = querySnapshot.docs.first.reference;
        final giftDocId = '${userId}_${eventId}_${gift.id}';
        await eventDocRef.collection('gifts').doc(giftDocId).set(gift.toJson());
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print("Error adding gift: $e");
      return false;
    }
  }

  Future<Gift?> getGiftById(String userId, int eventId, String giftId) async {
    try {
      final querySnapshot = await _firestore
          .collection('events')
          .where('userId', isEqualTo: userId)
          .where('eventId', isEqualTo: eventId)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        final doc = await querySnapshot.docs.first.reference
            .collection('gifts')
            .doc(giftId)
            .get();
        if (doc.exists) {
          return Gift.fromJson(doc.data() as Map<String, dynamic>);
        }
      }
      return null;
    } catch (e) {
      print("Error getting gift by ID: $e");
      return null;
    }
  }

  Future<void> updateGift(String userId, int eventId, Gift gift) async {
    try {
      final querySnapshot = await _firestore
          .collection('events')
          .where('userId', isEqualTo: userId)
          .where('eventId', isEqualTo: eventId)
          .get();

      if (querySnapshot.docs.isNotEmpty && gift.id != null) {
        final giftDocId = '${userId}_${eventId}_${gift.id}';
        await querySnapshot.docs.first.reference
            .collection('gifts')
            .doc(giftDocId)
            .update(gift.toJson());
      } else {
        throw 'Event or Gift not found';
      }
    } catch (e) {
      print("Error updating gift: \$e");
    }
  }

  Future<void> deleteGift(String userId, int eventId, String giftId) async {
    try {
      final querySnapshot = await _firestore
          .collection('events')
          .where('userId', isEqualTo: userId)
          .where('eventId', isEqualTo: eventId)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        final giftDocId = '${userId}_${eventId}_$giftId';
        await querySnapshot.docs.first.reference
            .collection('gifts')
            .doc(giftDocId)
            .delete();
      } else {
        throw 'Event or Gift not found';
      }
    } catch (e) {
      print("Error deleting gift: $e");
    }
  }

  Future<List<Gift>> getGiftsByEvent(String userId, int eventId) async {
    try {
      final querySnapshot = await _firestore
          .collection('events')
          .where('userId', isEqualTo: userId)
          .where('eventId', isEqualTo: eventId)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        final giftsSnapshot =
            await querySnapshot.docs.first.reference.collection('gifts').get();

        return giftsSnapshot.docs
            .map((doc) => Gift.fromJson(doc.data()))
            .toList();
      }
      return [];
    } catch (e) {
      print("Error getting gifts for event: $e");
      return [];
    }
  }
}
