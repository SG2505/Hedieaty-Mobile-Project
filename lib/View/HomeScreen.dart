import 'package:flutter/material.dart';
import 'package:flutter_snake_navigationbar/flutter_snake_navigationbar.dart';
import 'package:hedieaty/Shared%20Widgets/App_Bar.dart';
import 'package:hedieaty/Shared%20Widgets/Home/FriendTile.dart';

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
        bottomNavigationBar: SnakeNavigationBar.color(
          height: 70,
          elevation: 100,
          selectedLabelStyle:
              TextStyle(fontSize: 12, color: Color.fromRGBO(135, 217, 250, 1)),
          unselectedLabelStyle: TextStyle(fontSize: 12),
          backgroundColor: Color.fromRGBO(0, 0, 0, 0.8),
          behaviour: SnakeBarBehaviour.floating,
          snakeShape: SnakeShape.indicator,
          snakeViewColor: Color.fromRGBO(135, 217, 250, 1),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(35)),
          padding: EdgeInsets.all(8),

          selectedItemColor: Color.fromRGBO(135, 217, 250, 1),
          unselectedItemColor: Colors.white,
          showUnselectedLabels: true,
          showSelectedLabels:
              true, // will always be false if snakeShape is circle

          currentIndex: currentIndex,
          onTap: (index) => setState(() => currentIndex = index),
          items: [
            BottomNavigationBarItem(
                icon: Icon(Icons.notifications), label: 'tickets'),
            BottomNavigationBarItem(
                icon: Icon(Icons.notifications), label: 'tickets'),
            BottomNavigationBarItem(
                icon: Icon(Icons.notifications), label: 'tickets'),
            BottomNavigationBarItem(
                icon: Icon(Icons.notifications), label: 'tickets'),
          ],
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
                    'Hello, Salah',
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
                  elevation: WidgetStatePropertyAll(0),
                  leading: Icon(Icons.search_rounded),
                  trailing: [
                    searchBarController.text != ''
                        ? IconButton(
                            onPressed: () {
                              setState(() {
                                searchBarController.clear();
                              });
                            },
                            icon: Icon(Icons.close_rounded))
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
                  Friendtile(
                      title: 'John Doe',
                      subtitle: 'Upcoming Event: Birthday',
                      imgPath: 'assets/icons/HomeScreenIcons/user_avatar.png',
                      numOfEvents: 2),
                  Friendtile(
                      title: 'John Doe',
                      subtitle: 'Upcoming Event: Birthday',
                      imgPath: 'assets/icons/HomeScreenIcons/user_avatar.png',
                      numOfEvents: 2),
                  Friendtile(
                      title: 'John Doe',
                      subtitle: 'Upcoming Event: Birthday',
                      imgPath: 'assets/icons/HomeScreenIcons/user_avatar.png',
                      numOfEvents: 2),
                  Friendtile(
                      title: 'John Doe',
                      subtitle: 'Upcoming Event: Birthday',
                      imgPath: 'assets/icons/HomeScreenIcons/user_avatar.png',
                      numOfEvents: 2),
                  Friendtile(
                      title: 'John Doe',
                      subtitle: 'Upcoming Event: Birthday',
                      imgPath: 'assets/icons/HomeScreenIcons/user_avatar.png',
                      numOfEvents: 2),
                  Friendtile(
                      title: 'John Doe',
                      subtitle: 'Upcoming Event: Birthday',
                      imgPath: 'assets/icons/HomeScreenIcons/user_avatar.png',
                      numOfEvents: 2),
                  Friendtile(
                      title: 'John Doe',
                      subtitle: 'Upcoming Event: Birthday',
                      imgPath: 'assets/icons/HomeScreenIcons/user_avatar.png',
                      numOfEvents: 2),
                  Friendtile(
                      title: 'John Doe',
                      subtitle: 'Upcoming Event: Birthday',
                      imgPath: 'assets/icons/HomeScreenIcons/user_avatar.png',
                      numOfEvents: 2),
                ],
              ),
            ],
          ),
        ));
  }
}
