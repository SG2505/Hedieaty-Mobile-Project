import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hedieaty/Model/Event.dart';

class FirebaseEventService {
  final CollectionReference eventCollection =
      FirebaseFirestore.instance.collection('events');

  Future<bool> createEvent(Event event) async {
    try {
      await eventCollection.doc(event.id).set(event.toJson());
      return true;
    } catch (e) {
      print('Failed to create event: $e');
      return false;
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

  Future<bool> updateEvent(Event event) async {
    try {
      await eventCollection.doc(event.id).update(event.toJson());
      return true;
    } catch (e) {
      print('Failed to update event: $e');
      return false;
    }
  }

  Future<bool> deleteEvent(Event event) async {
    try {
      await eventCollection.doc(event.id).delete();
      return true;
    } catch (e) {
      print('Failed to delete event: $e');
      return false;
    }
  }
}
