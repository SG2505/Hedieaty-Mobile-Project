import 'package:hedieaty/Firebase/FIrebaseFriendService.dart';
import 'package:hedieaty/SQL_Local/LocalDB.dart';

class FriendController {
  static final LocalDB _localDB = LocalDB();
  static final FirebaseFriendService _firebaseFriendService =
      FirebaseFriendService();

  static Future<List<Map<String, dynamic>>> loadFriendsData(
      List<String> friendIds,
      {bool isInitialLoad = true}) async {
    if (!isInitialLoad && FirebaseFriendService.lastVisibleFriendDoc == null) {
      return []; // No more data to load
    }

    return await _firebaseFriendService.getFriendsWithEventsAndGifts(friendIds);
  }
}
