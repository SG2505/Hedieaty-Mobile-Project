import 'package:hedieaty/Model/Gift.dart';
import 'package:hedieaty/SQL_Local/LocalDB.dart';

class GiftController {
  static final LocalDB _localDB = LocalDB();

  /// Fetch gifts by event ID
  static Future<List<Gift>> getGiftsByEventId(int eventId) async {
    try {
      var gifts = await _localDB.getGiftsByEventId(eventId);
      print("Fetched Gifts: ${gifts.map((g) => g.toString()).toList()}");
      return gifts;
    } catch (e) {
      print("Error: \$e");
      return [];
    }
  }

  /// Add a new gift
  static Future<bool> addGift(Gift gift) async {
    try {
      await _localDB.insertGift(gift);
      return true;
    } catch (e) {
      print("Error: \$e");
      return false;
    }
  }

  /// Update an existing gift
  static Future<bool> updateGift(Gift gift) async {
    try {
      await _localDB.updateGift(gift);
      return true;
    } catch (e) {
      print("Error: \$e");
      return false;
    }
  }

  /// Delete a gift by ID
  static Future<bool> deleteGift(int id) async {
    try {
      await _localDB.deleteGift(id);
      return true;
    } catch (e) {
      print("Error: \$e");
      return false;
    }
  }
}
