import 'package:hedieaty/Model/Event.dart';
import 'package:hedieaty/SQL_Local/LocalDB.dart';
import 'package:hedieaty/main.dart';

class EventController {
  static final LocalDB _localDB = LocalDB();
  static List<Event> events = [];

  static Future<bool> addEvent(Event event) async {
    try {
      await _localDB.insertEvent(event);
      return true;
    } catch (e) {
      print("Error: $e");
      return false;
    }
  }

  static Future<bool> updateEvent(Event event) async {
    try {
      await _localDB.updateEvent(event);
      return true;
    } catch (e) {
      print("Error: $e");
      return false;
    }
  }

  static Future<List<Event>> getEvents() async {
    try {
      events = await _localDB.getEventsByUserId(currentUser.id!);
      print(events.length);
      return events;
    } catch (e) {
      print("Error: $e");
      return [];
    }
  }

  static Future<bool> deleteEvent(int eventId) async {
    try {
      await _localDB.deleteEvent(eventId);
      return true;
    } catch (e) {
      print("Error: $e");
      return false;
    }
  }
}
