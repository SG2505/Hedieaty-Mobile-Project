import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hedieaty/Config/theme.dart';
import 'package:hedieaty/Controller/FriendController.dart';
import 'package:hedieaty/View/HomeScreen/AddFriendWidget.dart';
import 'package:hedieaty/View/Widgets/AppBar.dart';
import 'package:hedieaty/View/HomeScreen/FriendTile.dart';
import 'package:hedieaty/View/Widgets/CustomBottomNavigationBar.dart';
import 'package:hedieaty/main.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class Homescreen extends StatefulWidget {
  const Homescreen({super.key});

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  TextEditingController searchBarController = TextEditingController();
  int currentIndex = 0;
  List<Map<String, dynamic>> friendsData = [];
  bool isLoading = true;
  bool isInitialLoad = true;
  bool isFetchingMore = false;
  ScrollController scrollController = ScrollController();

  final List<String> friendIds = [
    "22r8ZhByxaTvYokxXQt6Lnb9kfE2",
    "43XMAiX1PBa96DKtXjhThXL5idr2",
    "55CyPf8rsofr7889Kqqa7ILLeQq2",
    "9LAKb3anTEcKtt4CmZNfEuHAq8g1",
    "BTAB1q0usTThQVRQEpezjmk1dB63",
    "D7WwXCX02SNYbFdtszHLLipjILF3",
    "GFNe4EKXvrY62gxVdnAdhSuiMZu2",
    "apDJdrL93EgLhWRcDQYF1K93pz83",
    "bEYkVN28fDPKZwvLhKDCkcDuVc23",
    "hOvEP6fsNweufzNpwEXR7U44FxG3",
    "oGaKq49KUIZUZY9DyvkMb8ZOJSg1",
    "vnbP3BOGRmM4IF62kEhNzxTsec43",
    "yLtpcjYKyfXzTutFO0N3MZfqqIi1",
    "UrQB4wKJVFOs3HxlCiZL072V6Mr2",
    "SOIz03rT6YRzQmbvBtbBxfc1psw1",
    "vWiWVvdJoLVfDeQ3jLgOEOf1fTB3"
  ];

  @override
  void initState() {
    super.initState();
    _loadFriendsData();
    // Listen to scroll events to handle pagination
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        // Load more data when reaching the bottom if not already fetching
        if (!isFetchingMore) {
          _loadFriendsData();
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
                    //replace with user name
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
                  onChanged: (value) {
                    //this set state is used to show and hide the x button
                    setState(() {});
                  },
                  controller: searchBarController,
                  onTapOutside: (event) {
                    FocusScope.of(context).unfocus();
                  },
                  hintText: '  search friends & gift lists',
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
                  : ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: friendsData.length,
                      itemBuilder: (context, index) {
                        print(friendsData.length);
                        final friendData = friendsData[index];
                        final friend = friendData['friend'];
                        final events = friendData['events'];
                        final gifts = friendData['gifts'];

                        return Friendtile(
                          title: friend.name,
                          subtitle:
                              '${events.length} events, ${gifts.length} gifts',
                          imgPath: friend.profilePictureUrl ??
                              'assets/icons/HomeScreenIcons/user_avatar.png',
                          numOfEvents: events.length,
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

  Future<void> _loadFriendsData() async {
    setState(() {
      isFetchingMore = true; // Set flag to true to prevent multiple triggers
    });

    try {
      final fetchedData = await FriendController.loadFriendsData(friendIds,
          isInitialLoad: isInitialLoad);

      if (fetchedData.isNotEmpty) {
        setState(() {
          friendsData.addAll(fetchedData);
          isInitialLoad = false;
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
}
