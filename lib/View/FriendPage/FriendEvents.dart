import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hedieaty/Model/AppUser.dart';
import 'package:hedieaty/Model/Event.dart';
import 'package:hedieaty/View/Widgets/AppBar.dart';
import 'package:hedieaty/View/Widgets/GeneralTile.dart';

class FriendEventsScreen extends StatefulWidget {
  final List<Event>? events;
  final AppUser friend;
  const FriendEventsScreen({super.key, this.events, required this.friend});

  @override
  State<FriendEventsScreen> createState() => _FriendEventsScreenState();
}

class _FriendEventsScreenState extends State<FriendEventsScreen> {
  TextEditingController searchBarController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
          appBarActions: [],
          title: "${widget.friend.name}'s Events",
          isTherebackButton: true),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 10,
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
            widget.events == null || widget.events!.isEmpty
                ? Center(
                    child: Text("${widget.friend.name} has no events"),
                  )
                : ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: widget.events!.length,
                    itemBuilder: (context, index) {
                      print(widget.events![0]);
                      var date = widget.events![index].date;
                      return GeneralTile(
                        text: widget.events![index].name!,
                        subtitle: "${date.day}-${date.month}${date.year}",
                        leadingImgPath:
                            'assets/icons/CategoryIcons/birthday.png',
                        trailingImgPath:
                            'assets/icons/EventDetailsIcons/next.png',
                        iconFucntion: () => context.push('/FriendGiftList',
                            extra: widget.events![index]),
                        tileFucntion: () => context.push('/FriendGiftList',
                            extra: widget.events![index]),
                      );
                    },
                  ),
          ],
        ),
      ),
    );
  }
}
