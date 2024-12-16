import 'package:hedieaty/Firebase/FirebaseEventsService.dart';
import 'package:hedieaty/Model/Event.dart';
import 'package:hedieaty/SQL_Local/LocalDB.dart';
import 'package:hedieaty/main.dart';

class EventController {
  static final LocalDB _localDB = LocalDB();
  static final FirebaseEventService firebaseEventService =
      FirebaseEventService();
  static List<Event> events = [];

  static Future<bool> addEvent(Event event) async {
    try {
      int localId = await _localDB.insertEvent(event);
      event.id = localId;
      await firebaseEventService.createEvent(event);
      return true;
    } catch (e) {
      print("Error: $e");
      return false;
    }
  }

  static Future<bool> updateEvent(Event event) async {
    try {
      await _localDB.updateEvent(event);
      await firebaseEventService.updateEvent(event);
      return true;
    } catch (e) {
      print("Error: $e");
      return false;
    }
  }

  static Future<List<Event>> getEvents() async {
    try {
      events = await _localDB.getEventsByUserId(currentUser.id!);
      // add firebase later////////////////////////////
      print(events.length);
      return events;
    } catch (e) {
      print("Error: $e");
      return [];
    }
  }

  static Future<bool> deleteEvent(Event event) async {
    try {
      await _localDB.deleteEvent(event.id!);
      await firebaseEventService.deleteEvent(event);
      return true;
    } catch (e) {
      print("Error: $e");
      return false;
    }
  }
}
