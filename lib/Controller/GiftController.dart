import 'package:hedieaty/Firebase/FirebaseGiftService.dart';
import 'package:hedieaty/Model/Gift.dart';
import 'package:hedieaty/SQL_Local/LocalDB.dart';

class GiftController {
  static final LocalDB _localDB = LocalDB();
  static final FirebaseGiftService _firebaseGiftService = FirebaseGiftService();

  static Future<bool> addGift(Gift gift) async {
    try {
      await _localDB.insertGift(gift);
      await _firebaseGiftService.createGift(gift);
      return true;
    } catch (e) {
      print("Error: $e");
      return false;
    }
  }

  static Future<bool> updateGift(Gift gift) async {
    try {
      await _localDB.updateGift(gift);
      await _firebaseGiftService.updateGift(gift);
      return true;
    } catch (e) {
      print("Error: \$e");
      return false;
    }
  }

  static Future<bool> deleteGift(String id) async {
    try {
      await _localDB.deleteGift(id);
      await _firebaseGiftService.deleteGift(id);
      return true;
    } catch (e) {
      print("Error: $e");
      return false;
    }
  }

  static Future<bool> deleteAllGiftsByEventId(String id) async {
    try {
      await _localDB.deleteGiftsByEventId(id);
      await _firebaseGiftService.deleteGiftsByEventId(id);
      return true;
    } catch (e) {
      print("Error: $e");
      return false;
    }
  }

  static Future<List<Gift>> getGiftsByEventId(String eventId) async {
    try {
      var gifts = await _localDB.getGiftsByEventId(eventId);
      print("Fetched Gifts: ${gifts.map((g) => g.toString()).toList()}");
      return gifts;
    } catch (e) {
      print("Error: $e");
      return [];
    }
  }
}
