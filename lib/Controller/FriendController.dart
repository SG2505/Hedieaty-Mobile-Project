import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hedieaty/Firebase/FirebaseFriendService.dart';
import 'package:hedieaty/SQL_Local/LocalDB.dart';
import 'package:hedieaty/main.dart';

class FriendController {
  static final LocalDB _localDB = LocalDB();
  static final FirebaseFriendService _firebaseFriendService =
      FirebaseFriendService();

  static Future<List<Map<String, dynamic>>> loadFriendsData(
      {bool isInitialLoad = true}) async {
    if (!isInitialLoad && FirebaseFriendService.lastVisibleFriendDoc == null) {
      return []; // No more data to load
    }
    //sync friends before loading data to ensure if a freind added you to his friendlist he isa added to ypurs and you can fetch his events
    await FriendController.syncFriends();

    List<String> friendsIds =
        await _localDB.getFriendsByUserId(currentUser.id!);
    print(friendsIds);
    return await _firebaseFriendService.getFriendsWithEvents(friendsIds);
  }

  static Future<String> handleAddFriend(String phoneNumber) async {
    try {
      String createdAt = DateTime.now().toIso8601String();
      var friendId = await _firebaseFriendService.addFriend(
          currentUserId: currentUser.id!,
          phoneNumber: phoneNumber,
          createdAt: createdAt);
      _localDB.insertFriend(currentUser.id!, friendId, createdAt);
      return "Added Friend Successfully";
    } catch (e) {
      return e as String;
    }
  }

  static Future<void> syncFriends() async {
    var x = await _localDB.getFriendsByUserId(currentUser.id!);
    print(x);
    String? lastSyncTime =
        await _localDB.getLatestFriendshipCreatedAt(currentUser.id!);

    lastSyncTime ??= "1970-01-01T00:00:00.000Z";
    print('lastSyncTime: $lastSyncTime');
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('friends')
        .where('userId', isEqualTo: currentUser.id!)
        .where('createdAt', isGreaterThan: lastSyncTime)
        .get();
    print('docs length: ${snapshot.docs.length}');
    for (var doc in snapshot.docs) {
      String friendId = doc['friendId'];
      String createdAt = doc['createdAt'];
      //print(friendId);
      print(createdAt);

      await _localDB.insertFriend(currentUser.id!, friendId, createdAt);
    }
  }
}
