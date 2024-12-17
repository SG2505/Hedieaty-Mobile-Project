import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hedieaty/Firebase/FirebaseEventsService.dart';
import 'package:hedieaty/Firebase/FirebaseGiftService.dart';
import 'package:hedieaty/Model/AppUser.dart';
import 'package:hedieaty/Model/Event.dart';
import 'package:hedieaty/Model/Gift.dart';

class FirebaseFriendService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseGiftService _giftService = FirebaseGiftService();
  final FirebaseEventService _eventService = FirebaseEventService();

  static DocumentSnapshot? lastVisibleFriendDoc;

  Future<List<Map<String, dynamic>>> getFriendsWithEventsAndGifts(
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
        List<Gift> gifts = [];
        // For each friend, fetch their events
        events = await _eventService.getEventsByUserId(friend.id!);

        for (var event in events) {
          // For each event, fetch the associated gifts
          gifts = await _giftService.getGiftsByEvent(event.id);
        }
        // Add friend, their events, and gifts to the result
        result.add({
          'friend': friend,
          'events': events,
          'gifts': gifts,
        });
      }

      return result;
    } catch (e) {
      print("Error fetching friends, events, and gifts: $e");
      return [];
    }
  }
}
