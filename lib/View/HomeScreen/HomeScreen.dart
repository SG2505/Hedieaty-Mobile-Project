import 'package:flutter/material.dart';
import 'package:hedieaty/View/Widgets/AppBar.dart';
import 'package:hedieaty/View/HomeScreen/FriendTile.dart';
import 'package:hedieaty/View/Widgets/CustomBottomNavigationBar.dart';
import 'package:hedieaty/main.dart';

class Homescreen extends StatefulWidget {
  const Homescreen({super.key});

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  TextEditingController searchBarController = TextEditingController();
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar(
          title: 'Hedieaty',
          isTherebackButton: false,
          appBarActions: [
            IconButton(
                tooltip: 'Add Friend',
                onPressed: () {},
                icon: Image.asset(
                  'assets/icons/HomeScreenIcons/Add_Friend.png',
                  width: 30,
                  height: 30,
                )),
            IconButton(
                tooltip: 'Add Event',
                onPressed: () {},
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
              ListView(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                children: [
                  for (var i = 1; i < 16; i++)
                    Friendtile(
                        title: 'John Doe',
                        subtitle: 'Upcoming: Birthday',
                        imgPath: 'assets/icons/HomeScreenIcons/user_avatar.png',
                        numOfEvents: i),
                ],
              ),
            ],
          ),
        ));
  }
}
