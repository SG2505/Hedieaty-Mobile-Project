import 'package:flutter/material.dart';
import 'package:flutter_snake_navigationbar/flutter_snake_navigationbar.dart';
import 'package:hedieaty/View/Widgets/AppBar.dart';
import 'package:hedieaty/View/MyEvents/EventTile.dart';

class MyEvents extends StatefulWidget {
  const MyEvents({super.key});

  @override
  State<MyEvents> createState() => _MyEventsState();
}

class _MyEventsState extends State<MyEvents> {
  TextEditingController searchBarController = TextEditingController();
  int currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar(
          title: 'My Events',
          isTherebackButton: true,
          appBarActions: [
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
                height: 15,
              ),
              Row(
                children: [
                  Container(
                    margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: SearchBar(
                      onChanged: (value) {
                        //this set state is used to show and hide the x button
                        setState(() {});
                      },
                      controller: searchBarController,
                      onTapOutside: (event) {
                        FocusScope.of(context).unfocus();
                      },
                      hintText: '  search events',
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
                    width: 10,
                  ),
                  IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Icons.filter_list_rounded,
                        size: 35,
                      ))
                ],
              ),
              SizedBox(
                height: 20,
              ),
              ListView(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                children: [
                  for (var i = 1; i < 16; i++)
                    EventTile(
                        title: 'title',
                        imgPath: '',
                        date: '15/12/2024',
                        category: 'category',
                        status: 'status')
                ],
              ),
            ],
          ),
        ));
  }
}
