import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hedieaty/Model/Gift.dart';

class FirebaseGiftService {
  final CollectionReference giftsCollection =
      FirebaseFirestore.instance.collection('gifts');

  Future<void> createGift(Gift gift) async {
    try {
      await giftsCollection.add(gift.toJson());
    } catch (e) {
      print("Error adding gift: $e");
      throw e;
    }
  }

  Future<Gift?> getGiftById(String id) async {
    try {
      DocumentSnapshot doc = await giftsCollection.doc(id).get();
      if (doc.exists) {
        return Gift.fromJson(doc.data() as Map<String, dynamic>);
      }
      return null;
    } catch (e) {
      print("Error getting gift by ID: $e");
      throw e;
    }
  }

  Future<void> updateGift(Gift gift) async {
    try {
      if (gift.id != null) {
        await giftsCollection.doc(gift.id).update(gift.toJson());
      } else {
        throw 'Gift ID cannot be null for update';
      }
    } catch (e) {
      print("Error updating gift: $e");
      throw e;
    }
  }

  Future<void> deleteGift(String id) async {
    try {
      await giftsCollection.doc(id).delete();
    } catch (e) {
      print("Error deleting gift: $e");
      throw e;
    }
  }

  Future<List<Gift>> getGiftsByEvent(String eventId) async {
    try {
      QuerySnapshot querySnapshot =
          await giftsCollection.where('eventId', isEqualTo: eventId).get();

      return querySnapshot.docs
          .map((doc) => Gift.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print("Error getting gifts for event: $e");
      throw e;
    }
  }
}
