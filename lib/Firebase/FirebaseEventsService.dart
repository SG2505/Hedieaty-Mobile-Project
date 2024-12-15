import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hedieaty/Model/Event.dart';

class FirebaseEventService {
  final CollectionReference eventCollection =
      FirebaseFirestore.instance.collection('events');

  Future<void> createEvent(Event event) async {
    try {
      await eventCollection.add(event.toJson());
    } catch (e) {
      throw Exception('Failed to create event: $e');
    }
  }

  // Future<Event?> getEventById(String id) async {
  //   try {
  //     DocumentSnapshot doc = await eventCollection.doc(id).get();
  //     if (doc.exists) {
  //       return Event.fromJson(doc.data() as Map<String, dynamic>)..id = doc.id;
  //     }
  //     return null;
  //   } catch (e) {
  //     throw Exception('Failed to fetch event: $e');
  //   }
  // }

  Future<List<Event>> getEventsByUserId(String userId) async {
    try {
      QuerySnapshot snapshot =
          await eventCollection.where('userId', isEqualTo: userId).get();
      return snapshot.docs
          .map((doc) => Event.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch events: $e');
    }
  }

  Future<void> updateEvent(Event event) async {
    try {
      if (event.id != null) {
        // await eventCollection.doc(event.id).update(event.toJson()); adjuuuuuuuuuuuuuuuuust
      } else {
        throw Exception('Event ID is required for updating');
      }
    } catch (e) {
      throw Exception('Failed to update event: $e');
    }
  }

  Future<void> deleteEvent(String id) async {
    try {
      await eventCollection.doc(id).delete();
    } catch (e) {
      throw Exception('Failed to delete event: $e');
    }
  }
}
