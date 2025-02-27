import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:hedieaty/Firebase/FirebaseGiftService.dart';
import 'package:hedieaty/Model/Gift.dart';
import 'package:hedieaty/SQL_Local/LocalDB.dart';
import 'package:hedieaty/main.dart';

class GiftController {
  static final LocalDB _localDB = LocalDB();
  static final FirebaseGiftService _firebaseGiftService = FirebaseGiftService();

  static Future<bool> addGift(Gift gift) async {
    try {
      if (autoSync == 1 && await _isConnected()) {
        gift.isPublished = 1;
        await _firebaseGiftService.createGift(gift);
      } else {
        gift.isPublished = 0;
      }
      await _localDB.insertGift(gift);

      return true;
    } catch (e) {
      print("Error: $e");
      return false;
    }
  }

  static Future<bool> updateGift(Gift gift) async {
    try {
      if (autoSync == 1 && await _isConnected()) {
        gift.isPublished = 1;
        await _firebaseGiftService.updateGift(gift);
      } else {
        gift.isPublished = 0;
      }
      await _localDB.updateGift(gift);

      return true;
    } catch (e) {
      print("Error: $e");
      return false;
    }
  }

  static Future<bool> deleteGift(String id) async {
    if (autoSync == 0 || await _isConnected() == false) {
      print("Delete not allowed when auto-sync is off or no internet.");
      return false;
    }
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
    if (autoSync == 0 || await _isConnected() == false) {
      print("Delete not allowed when auto-sync is off or no internet.");
      return false;
    }
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

      if (await _isConnected()) {
        var firebaseGifts = await _firebaseGiftService.getGiftsByEvent(eventId);

        for (var firebaseGift in firebaseGifts) {
          bool isGiftInLocalDB =
              gifts.any((localGift) => localGift.id == firebaseGift.id);

          if (!isGiftInLocalDB) {
            await _localDB.insertGift(firebaseGift);
            gifts.add(firebaseGift);
          }
        }
      }

      print("Fetched Gifts: ${gifts.map((g) => g.toString()).toList()}");
      return gifts;
    } catch (e) {
      print("Error: $e");
      return [];
    }
  }

  static Future<bool> _isConnected() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    return connectivityResult.contains(ConnectivityResult.mobile) ||
        connectivityResult.contains(ConnectivityResult.wifi);
  }
}
