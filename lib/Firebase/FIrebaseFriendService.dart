import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hedieaty/Firebase/FCM.dart';
import 'package:hedieaty/Firebase/FirebaseEventsService.dart';
import 'package:hedieaty/Model/AppUser.dart';
import 'package:hedieaty/Model/Event.dart';
import 'package:hedieaty/main.dart';

class FirebaseFriendService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseEventService _eventService = FirebaseEventService();

  static DocumentSnapshot? lastVisibleFriendDoc;

  Future<List<Map<String, dynamic>>> getFriendsWithEvents(
      List<String> friendIds) async {
    try {
      List<Map<String, dynamic>> result = [];

      // Query for friends data
      Query friendsQuery = _firestore
          .collection('users')
          .where('id', whereIn: friendIds)
          .limit(10);

      if (lastVisibleFriendDoc != null) {
        friendsQuery = friendsQuery.startAfterDocument(lastVisibleFriendDoc!);
      }

      final friendsQuerySnapshot = await friendsQuery.get();
      //update last doc for pagination
      if (friendsQuerySnapshot.docs.isNotEmpty) {
        lastVisibleFriendDoc = friendsQuerySnapshot.docs.last;
      }

      List<AppUser> friends = friendsQuerySnapshot.docs
          .map((doc) => AppUser.fromJson(doc.data() as Map<String, dynamic>))
          .toList();

      for (var friend in friends) {
        List<Event> events = [];

        // For each friend, fetch their events
        events = await _eventService.getEventsByUserId(friend.id!);
        // Add friend and their events
        result.add({
          'friend': friend,
          'events': events,
        });
      }

      return result;
    } catch (e) {
      print("Error fetching friends, events: $e");
      return [];
    }
  }

  Future<String> addFriend(
      {required String currentUserId,
      required String phoneNumber,
      required String createdAt}) async {
    if (phoneNumber == currentUser.phoneNumber) {
      print("You can't add yourself as a friend.");
      throw "You can't add yourself as a friend.";
    }
    // Search for the user by phone number
    final querySnapshot = await _firestore
        .collection('users')
        .where('phoneNumber', isEqualTo: phoneNumber)
        .get();

    if (querySnapshot.docs.isEmpty) {
      print("User with this phone number not found.");
      throw "User with this phone number is not found.";
    }

    final friendUserDoc = querySnapshot.docs.first;
    final friendId = friendUserDoc.id;

    // Check if they are already friends
    final friendsSnapshot = await _firestore
        .collection('friends')
        .where('userId', isEqualTo: currentUserId)
        .where('friendId', isEqualTo: friendId)
        .get();

    if (friendsSnapshot.docs.isNotEmpty) {
      print("You are already friends.");
      throw "You are already friends.";
    }

    // Add the friend to the friends collection
    await _firestore.collection('friends').add({
      'userId': currentUserId,
      'friendId': friendId,
      'createdAt': createdAt,
    });
    // Add the friend to the friends the other way for easier syncing between friends
    await _firestore.collection('friends').add({
      'userId': friendId,
      'friendId': currentUserId,
      'createdAt': createdAt,
    });

    print("Friend added successfully.");
    return friendId;
  }

  Future<Map<String, dynamic>> getRecentlyAddedFriendwithEvents(
      String phoneNumber) async {
    try {
      final friendSnapshot = await _firestore
          .collection('users')
          .where('phoneNumber', isEqualTo: phoneNumber)
          .get();

      final friend = AppUser.fromJson(friendSnapshot.docs.first.data());
      final friendEvents = await _eventService.getEventsByUserId(friend.id!);

      return {'friend': friend, 'events': friendEvents};
    } catch (e) {
      print(e);
      return {};
    }
  }

  Future<String?> getDeviceMessageToken(String userId) async {
    try {
      final userDoc = await _firestore.collection('users').doc(userId).get();

      if (userDoc.exists) {
        return userDoc.data()?['deviceMessageToken'] as String?;
      } else {
        print("User not found.");
        return null;
      }
    } catch (e) {
      print("Error fetching device message token: $e");
      return null;
    }
  }

  Future<void> sendNotification(
      {required String userId,
      required String title,
      required String message}) async {
    try {
      var friendToken = await getDeviceMessageToken(userId);
      print(friendToken);
      if (friendToken != null) {
        await FirebaseMessagingService().sendNotification(
            targetFCMToken: friendToken, title: title, body: message);
      }
    } catch (e) {
      print(e);
    }
  }
}
