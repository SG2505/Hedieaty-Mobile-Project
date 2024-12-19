import 'package:hedieaty/Firebase/FirebaseEventsService.dart';
import 'package:hedieaty/Firebase/FirebaseGiftService.dart';
import 'package:hedieaty/Model/Event.dart';
import 'package:hedieaty/SQL_Local/LocalDB.dart';
import 'package:hedieaty/main.dart';

class EventController {
  static final LocalDB _localDB = LocalDB();
  static final FirebaseEventService firebaseEventService =
      FirebaseEventService();
  static final FirebaseGiftService firebaseGiftService = FirebaseGiftService();
  static List<Event> events = [];

  static Future<bool> addEvent(Event event) async {
    try {
      event.isPublished = autoSync == 1 ? 1 : 0;
      await _localDB.insertEvent(event);
      if (autoSync == 1) {
        await firebaseEventService.createEvent(event);
      }
      return true;
    } catch (e) {
      print("Error: $e");
      return false;
    }
  }

  static Future<bool> updateEvent(Event event) async {
    try {
      event.isPublished = autoSync == 1 ? 1 : 0;
      await _localDB.updateEvent(event);
      if (autoSync == 1) {
        await firebaseEventService.updateEvent(event);
      }
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
    if (autoSync == 0) {
      print("Delete not allowed when auto-sync is off.");
      return false;
    }
    try {
      await _localDB.deleteEvent(event.id);
      await firebaseEventService.deleteEvent(event);
      return true;
    } catch (e) {
      print("Error: $e");
      return false;
    }
  }

  static Future<bool> syncUnpublishedData() async {
    try {
      final unpublishedEvents = await _localDB.getUnpublishedEvents();
      for (var event in unpublishedEvents) {
        event.isPublished = 1;
        await firebaseEventService.createEvent(event);
        await _localDB.updateEvent(event);
      }

      final unpublishedGifts = await _localDB.getUnpublishedGifts();
      for (var gift in unpublishedGifts) {
        gift.isPublished = 1;
        await firebaseGiftService.createGift(gift);
        await _localDB.updateGift(gift);
      }
      print("Sync completed.");
      return true;
    } catch (e) {
      print("Error syncing data: $e");
      return false;
    }
  }
}
