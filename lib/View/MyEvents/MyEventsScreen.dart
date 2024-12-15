import 'package:flutter/material.dart';
import 'package:hedieaty/Controller/EventController.dart';
import 'package:hedieaty/Model/Event.dart';
import 'package:hedieaty/View/Widgets/AppBar.dart';
import 'package:hedieaty/View/MyEvents/EventTile.dart';
import 'package:hedieaty/View/Widgets/CustomBottomNavigationBar.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class MyEventsScreen extends StatefulWidget {
  const MyEventsScreen({super.key});

  @override
  State<MyEventsScreen> createState() => _MyEventsScreenState();
}

class _MyEventsScreenState extends State<MyEventsScreen> {
  TextEditingController searchBarController = TextEditingController();
  int currentIndex = 1;

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
        bottomNavigationBar: CustomBottomNavigationBar(
          currentIndex: currentIndex,
          onTap: (index) {
            setState(() {
              currentIndex = index;
            });
          },
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
              FutureBuilder<List<Event>>(
                future: EventController.getEvents(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    // Show a loading spinner while waiting for the data
                    return Center(
                      child: LoadingAnimationWidget.threeArchedCircle(
                        color: Colors.blue.shade400,
                        size: 60,
                      ),
                    );
                  } else if (snapshot.hasError) {
                    // Show error if something went wrong
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (snapshot.data == null || snapshot.data!.isEmpty) {
                    // Show message if no events are available
                    return Center(child: Text('No events available.'));
                  } else {
                    print(EventController.events);
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        final event = snapshot.data![index];
                        print(event);
                        return EventTile(
                          title: event.name!,
                          imgPath: 'assets/icons/Miscellaneous/book.png',
                          date:
                              '${event.date.day} - ${event.date.month} - ${event.date.year}',
                          category: event.category!,
                          status: event.status!,
                          event: event,
                        );
                      },
                    );
                  }
                },
              )
            ],
          ),
        ));
  }
}
