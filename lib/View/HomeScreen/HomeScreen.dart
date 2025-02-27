import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hedieaty/Config/theme.dart';
import 'package:hedieaty/Controller/FriendController.dart';
import 'package:hedieaty/Firebase/FCM.dart';
import 'package:hedieaty/Model/AppUser.dart';
import 'package:hedieaty/Model/Event.dart';
import 'package:hedieaty/View/HomeScreen/AddFriendWidget.dart';
import 'package:hedieaty/View/Widgets/AppBar.dart';
import 'package:hedieaty/View/HomeScreen/FriendTile.dart';
import 'package:hedieaty/View/Widgets/CustomBottomNavigationBar.dart';
import 'package:hedieaty/main.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class Homescreen extends StatefulWidget {
  final Map<String, dynamic>? extraFriendData;
  const Homescreen({super.key, this.extraFriendData});

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  TextEditingController searchBarController = TextEditingController();
  int currentIndex = 0;
  List<Map<String, dynamic>> friendsData = [];
  List<Map<String, dynamic>> searchResults = [];
  bool isLoading = true;
  bool isInitialLoad = true;
  bool isFetchingMore = false;
  bool hasMoreData = true;
  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    autoSync = currentUser.preferences['autoSync'] ?? 1;
    isInitialLoad = true;
    fcmTokenUpdate();
    loadFriendsData();
    // Listen to scroll events to handle pagination
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        // Load more data when reaching the bottom if not already fetching

        if (!isFetchingMore && hasMoreData) {
          loadFriendsData();
        }
      }
    });
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.extraFriendData != null &&
        !friendsData.contains(widget.extraFriendData)) {
      friendsData.insert(0, widget.extraFriendData!);
    }
    return Scaffold(
        appBar: CustomAppBar(
          title: 'Hedieaty',
          isTherebackButton: false,
          appBarActions: [
            IconButton(
                tooltip: 'Add Friend',
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => const AddFriendWidget(),
                  );
                  context.pushReplacementNamed('home');
                },
                icon: Image.asset(
                  'assets/icons/HomeScreenIcons/Add_Friend.png',
                  width: 30,
                  height: 30,
                )),
            IconButton(
                tooltip: 'Add Event',
                onPressed: () {
                  context.pushNamed("addEditEvents");
                },
                icon: Image.asset(
                  'assets/icons/HomeScreenIcons/Add_Event.png',
                  width: 30,
                  height: 30,
                )),
          ],
        ),
        bottomNavigationBar: CustomBottomNavigationBar(
          currentIndex: currentIndex,
          onTap: (index) {
            setState(() {
              currentIndex = index;
            });
            currentIndex = 0;
          },
        ),
        body: SingleChildScrollView(
          controller: scrollController,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Hello, ${currentUser.name}',
                    style: TextStyle(
                      fontSize: 35,
                      fontFamily: 'League Spartan',
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
                child: SearchBar(
                  onChanged: (value) async {
                    await searchFriends(value, friendsData);
                    setState(() {});
                  },
                  controller: searchBarController,
                  onTapOutside: (event) {
                    FocusScope.of(context).unfocus();
                  },
                  hintText: '  search friends',
                  hintStyle: WidgetStatePropertyAll(
                      Theme.of(context).textTheme.bodySmall),
                  textStyle: WidgetStatePropertyAll(
                      Theme.of(context).textTheme.bodySmall),
                  elevation: WidgetStatePropertyAll(0),
                  leading: Image.asset(
                      width: 25,
                      height: 25,
                      'assets/icons/HomeScreenIcons/search.png'),
                  trailing: [
                    searchBarController.text != ''
                        ? IconButton(
                            onPressed: () {
                              setState(() {
                                searchBarController.clear();
                                searchResults = [];
                              });
                            },
                            icon: Icon(Icons.cancel))
                        : Container()
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              isLoading
                  ? Center(
                      child: LoadingAnimationWidget.inkDrop(
                          color: ThemeClass.blueThemeColor, size: 60))
                  : friendsData.isEmpty
                      ? Center(
                          child: Text(
                            'Start adding friends to see their events here!',
                            style: TextStyle(
                              fontSize: 18,
                              fontFamily: 'League Spartan',
                              fontWeight: FontWeight.bold,
                              color: Colors.grey.shade700,
                            ),
                          ),
                        )
                      : searchResults.isNotEmpty
                          ? ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: searchResults.length,
                              itemBuilder: (context, index) {
                                final friendData = searchResults[index];
                                final friend = friendData['friend'] as AppUser;
                                final events =
                                    friendData['events'] as List<Event>;

                                String upcomingEventName = 'No upcoming events';
                                if (events.isNotEmpty) {
                                  events
                                      .sort((a, b) => a.date.compareTo(b.date));
                                  final upcomingEvent = events.firstWhere(
                                    (event) =>
                                        event.date.isAfter(DateTime.now()),
                                    orElse: () => events.first,
                                  );
                                  upcomingEventName =
                                      'upcoming: ${upcomingEvent.name}';
                                }

                                return Friendtile(
                                  title: friend.name,
                                  subtitle: upcomingEventName,
                                  imgPath: friend.profilePictureUrl ??
                                      'assets/icons/HomeScreenIcons/user_avatar.png',
                                  numOfEvents: events.length,
                                  events: events,
                                  friend: friend,
                                );
                              },
                            )
                          : ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: friendsData.length,
                              itemBuilder: (context, index) {
                                print(friendsData.length);
                                final friendData = friendsData[index];
                                final friend = friendData['friend'] as AppUser;
                                final events =
                                    friendData['events'] as List<Event>;

                                String upcomingEventName = 'No upcoming events';
                                if (events.isNotEmpty) {
                                  events
                                      .sort((a, b) => a.date.compareTo(b.date));
                                  final upcomingEvent = events.firstWhere(
                                    (event) =>
                                        event.date.isAfter(DateTime.now()),
                                    orElse: () => events.first,
                                  );
                                  upcomingEventName =
                                      'upcoming: ${upcomingEvent.name}';
                                }
                                return Friendtile(
                                  title: friend.name,
                                  subtitle: upcomingEventName,
                                  imgPath: friend.profilePictureUrl ??
                                      'assets/icons/HomeScreenIcons/user_avatar.png',
                                  numOfEvents: events.length,
                                  events: events,
                                  friend: friend,
                                );
                              },
                            ),
              isFetchingMore && isInitialLoad == false
                  ? Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: LoadingAnimationWidget.inkDrop(
                          color: ThemeClass.blueThemeColor, size: 60),
                    )
                  : Container()
            ],
          ),
        ));
  }

  Future<void> loadFriendsData() async {
    if (isFetchingMore || !hasMoreData) return;
    setState(() {
      if (isInitialLoad) {
        isLoading = true; // Show initial loading widget
      }
      isFetchingMore = true;
    });
    try {
      final fetchedData =
          await FriendController.loadFriendsData(isInitialLoad: isInitialLoad);

      if (fetchedData.isNotEmpty) {
        setState(() {
          friendsData.addAll(fetchedData);
          isInitialLoad = false;
        });
      } else {
        setState(() {
          hasMoreData = false; // No more data to fetch
        });
      }
    } catch (e) {
      print("Error loading friends data: $e");
    } finally {
      setState(() {
        isLoading = false;
        isFetchingMore = false; // Reset fetching flag after loading
      });
    }
  }

  Future<void> fcmTokenUpdate() async {
    var fcmToken = await FirebaseMessagingService().getFCMToken();
    print(fcmToken);

    FirebaseMessagingService()
        .updateFCMToken(userId: currentUser.id, token: fcmToken);
  }

  Future<void> searchFriends(
      String searchString, List<Map<String, dynamic>> friendsData) async {
    print("entering search");
    final results =
        await FriendController.searchFriends(searchString, friendsData);
    print(results);
    setState(() {
      searchResults = results;
    });
  }
}
