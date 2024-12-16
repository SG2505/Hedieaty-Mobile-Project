import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hedieaty/Model/Event.dart';

class FirebaseEventService {
  final CollectionReference eventCollection =
      FirebaseFirestore.instance.collection('events');

  Future<void> createEvent(Event event) async {
    try {
      // make document id as userId_eventId
      String docId = '${event.userId}_${event.id}';
      // add the event to Firebase with the custom document id
      await eventCollection.doc(docId).set(event.toJson());
    } catch (e) {
      throw Exception('Failed to create event: $e');
    }
  }

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
      String docId = '${event.userId}_${event.id}';
      await eventCollection.doc(docId).update(event.toJson());
    } catch (e) {
      throw Exception('Failed to update event: $e');
    }
  }

  Future<void> deleteEvent(Event event) async {
    try {
      String docId = '${event.userId}_${event.id}';
      await eventCollection.doc(docId).delete();
    } catch (e) {
      throw Exception('Failed to delete event: $e');
    }
  }
}
