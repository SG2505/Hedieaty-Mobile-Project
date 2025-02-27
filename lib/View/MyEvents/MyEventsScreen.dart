import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hedieaty/Config/theme.dart';
import 'package:hedieaty/Controller/EventController.dart';
import 'package:hedieaty/Controller/GiftController.dart';
import 'package:hedieaty/Model/Event.dart';
import 'package:hedieaty/View/Widgets/AppBar.dart';
import 'package:hedieaty/View/MyEvents/EventTile.dart';
import 'package:hedieaty/View/Widgets/CustomBottomNavigationBar.dart';
import 'package:hedieaty/main.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:toastification/toastification.dart';

class MyEventsScreen extends StatefulWidget {
  const MyEventsScreen({super.key});

  @override
  State<MyEventsScreen> createState() => _MyEventsScreenState();
}

class _MyEventsScreenState extends State<MyEventsScreen> {
  TextEditingController searchBarController = TextEditingController();
  int currentIndex = 1;
  String selectedSort = 'name'; // Default sort by name
  List<Event> events = [];
  List<Event> filteredEvents = [];

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    searchBarController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar(
          title: 'My Events',
          isTherebackButton: true,
          appBarActions: [
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
            currentIndex = 1;
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
                        setState(() {
                          searchEvents(value);
                        });
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
                                    filteredEvents = List.from(events);
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
                      onPressed: () {
                        _showSortDialog();
                      },
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
                    return Center(
                      child: LoadingAnimationWidget.inkDrop(
                        color: ThemeClass.blueThemeColor,
                        size: 60,
                      ),
                    );
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (snapshot.data == null || snapshot.data!.isEmpty) {
                    return Center(child: Text('No events available.'));
                  } else {
                    //print(EventController.events);
                    if (events.isEmpty) {
                      events = snapshot.data!;
                      filteredEvents = List.from(events);
                    }
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: filteredEvents.length,
                      itemBuilder: (context, index) {
                        final event = filteredEvents[index];

                        if (event.date.day == DateTime.now().day &&
                            event.date.month == DateTime.now().month &&
                            event.date.year == DateTime.now().year) {
                          event.status = "current";
                        }
                        return EventTile(
                          title: event.name!,
                          imgPath:
                              ThemeClass.getCategoryImagePath(event.category),
                          date:
                              '${event.date.day} - ${event.date.month} - ${event.date.year}',
                          category: event.category!,
                          status: event.status!,
                          event: event,
                          onDelete: () async {
                            if (autoSync == 0) {
                              toastification.show(
                                  context: context,
                                  autoCloseDuration: Duration(seconds: 5),
                                  alignment: Alignment.topCenter,
                                  icon: Icon(
                                    Icons.cancel_rounded,
                                    color: Colors.red,
                                  ),
                                  title: Text(
                                      "Can't Delete When Auto Sync is off"));
                            } else {
                              await GiftController.deleteAllGiftsByEventId(
                                  event.id);
                              await EventController.deleteEvent(event);
                              toastification.show(
                                  context: context,
                                  autoCloseDuration: Duration(seconds: 5),
                                  alignment: Alignment.topCenter,
                                  icon: Icon(
                                    Icons.check_circle,
                                    color: Colors.green,
                                  ),
                                  title: Text("Event Deleted Successfully"));
                              setState(() {
                                setState(() {
                                  events.remove(event);
                                  filteredEvents.remove(event);
                                });
                              });
                            }
                          },
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

  // Filter the list of events based on the search query
  void searchEvents(String query) {
    setState(() {
      filteredEvents = events
          .where((event) =>
              event.name!.toLowerCase().contains(query.toLowerCase()) ||
              event.category!.toLowerCase().contains(query.toLowerCase()) ||
              event.status!.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  void _showSortDialog() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              'Sort by',
              style: ThemeClass.theme.textTheme.bodyMedium,
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  title: Text('Name'),
                  onTap: () {
                    setState(() {
                      selectedSort = 'name';
                      sortEvents();
                    });
                    Navigator.of(context).pop();
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                ListTile(
                  title: Text('Category'),
                  onTap: () {
                    setState(() {
                      selectedSort = 'category';
                      sortEvents();
                    });
                    Navigator.of(context).pop();
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                ListTile(
                  title: Text('Status'),
                  onTap: () {
                    setState(() {
                      selectedSort = 'status';
                      sortEvents();
                    });
                    Navigator.of(context).pop();
                  },
                ),
                const SizedBox(height: 20),
                ListTile(
                  title: Text('Date'),
                  onTap: () {
                    setState(() {
                      selectedSort = 'date';
                      sortEvents();
                    });
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          );
        });
  }

  // Sort the events based on the selected option
  void sortEvents() {
    if (selectedSort == 'name') {
      filteredEvents.sort((a, b) => a.name!.compareTo(b.name!));
    } else if (selectedSort == 'category') {
      filteredEvents.sort((a, b) => a.category!.compareTo(b.category!));
    } else if (selectedSort == 'status') {
      filteredEvents.sort((a, b) => a.status!.compareTo(b.status!));
    } else if (selectedSort == 'date') {
      filteredEvents.sort((a, b) => a.date.compareTo(b.date));
    }
    FocusManager.instance.primaryFocus?.unfocus();
  }
}
