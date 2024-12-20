import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hedieaty/Firebase/FirebaseFriendService.dart';
import 'package:hedieaty/Model/AppUser.dart';
import 'package:hedieaty/Model/Event.dart';
import 'package:hedieaty/SQL_Local/LocalDB.dart';
import 'package:hedieaty/main.dart';

class FriendController {
  static final LocalDB _localDB = LocalDB();
  static final FirebaseFriendService _firebaseFriendService =
      FirebaseFriendService();

  static Future<List<Map<String, dynamic>>> loadFriendsData(
      {bool isInitialLoad = true}) async {
    if (!isInitialLoad && FirebaseFriendService.lastVisibleFriendDoc == null) {
      print("hello");
      print("is inital load $isInitialLoad");
      print("last doc ${FirebaseFriendService.lastVisibleFriendDoc}");
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

  static Future<List<Map<String, dynamic>>> searchFriends(
      String searchString, List<Map<String, dynamic>> friendsData) async {
    List<Map<String, dynamic>> results = [];
    try {
      // Local Search in friendsData
      for (var friendData in friendsData) {
        final friend = friendData['friend'] as AppUser;
        final events = friendData['events'] as List<Event>;

        // Check if the friend's name matches the search string
        bool matchesName = friend.name
            .toString()
            .toLowerCase()
            .contains(searchString.toLowerCase());

        if (matchesName) {
          results.add({
            'friend': friend,
            'events': events,
          });
        }
      }

      // If not found locally, search Firebase
      if (results.isEmpty) {
        QuerySnapshot userSnapshot = await FirebaseFirestore.instance
            .collection('users')
            .where('name', isGreaterThanOrEqualTo: searchString.toLowerCase())
            .where('name', isLessThan: searchString.toLowerCase() + 'z')
            .get();

        for (var doc in userSnapshot.docs) {
          String friendName = doc['name'].toString();
          String friendId = doc.id;

          bool matchesName =
              friendName.toLowerCase().contains(searchString.toLowerCase());

          if (matchesName) {
            // Check if both users are friends in the friends table
            QuerySnapshot friendSnapshot = await FirebaseFirestore.instance
                .collection('friends')
                .where('userId', isEqualTo: currentUser.id!)
                .where('friendId', isEqualTo: friendId)
                .get();

            if (friendSnapshot.docs.isNotEmpty) {
              // Fetch the events for the found friend
              QuerySnapshot eventsSnapshot = await FirebaseFirestore.instance
                  .collection('events')
                  .where('userId', isEqualTo: friendId)
                  .get();

              List<Event> events = [];
              for (var eventDoc in eventsSnapshot.docs) {
                print("hi");
                events.add(
                    Event.fromJson(eventDoc.data() as Map<String, dynamic>));
              }

              results.add({
                'friend': AppUser.fromJson(doc.data()
                    as Map<String, dynamic>), // Friend object from Firestore
                'events': events, // List of events fetched from Firestore
              });
              print("hi2");
            }
          }
        }
      }

      return results;
    } catch (e) {
      print(e);
      return [];
    }
  }
}
