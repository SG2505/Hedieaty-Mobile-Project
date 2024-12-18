import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hedieaty/Config/theme.dart';
import 'package:hedieaty/Controller/GiftController.dart';
import 'package:hedieaty/Model/Event.dart';
import 'package:hedieaty/Model/Gift.dart';
import 'package:hedieaty/View/Widgets/AppBar.dart';
import 'package:hedieaty/View/Widgets/GeneralSwitchListTile.dart';
import 'package:hedieaty/main.dart';

class FriendGiftListScreen extends StatefulWidget {
  final Event event;
  const FriendGiftListScreen({super.key, required this.event});

  @override
  State<FriendGiftListScreen> createState() => _FriendGiftListScreenState();
}

class _FriendGiftListScreenState extends State<FriendGiftListScreen> {
  TextEditingController searchBarController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
          appBarActions: [],
          title: "${widget.event.name} gift list",
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
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.all(8),
                  margin: EdgeInsets.fromLTRB(15, 0, 3, 0),
                  decoration: BoxDecoration(
                      color: ThemeClass.blueThemeColor,
                      borderRadius: BorderRadius.circular(20)),
                  child: Text(
                    'Available',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(8),
                  margin: EdgeInsets.fromLTRB(15, 0, 3, 0),
                  decoration: BoxDecoration(
                      color: ThemeClass.greenThemeColor,
                      borderRadius: BorderRadius.circular(20)),
                  child: Text(
                    'Pledged',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(8),
                  margin: EdgeInsets.fromLTRB(15, 0, 3, 0),
                  decoration: BoxDecoration(
                      color: ThemeClass.yellowThemeColor,
                      borderRadius: BorderRadius.circular(20)),
                  child: Text(
                    'You Pledged',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            FirestoreListView<Map<String, dynamic>>(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              query: FirebaseFirestore.instance
                  .collection('gifts')
                  .where('eventId', isEqualTo: widget.event.id),
              itemBuilder: (context, snapshot) {
                final giftData = snapshot.data();
                final gift = Gift.fromJson(giftData);
                bool isPledgedByOtherUser =
                    gift.pledgerId != null && gift.pledgerId != currentUser.id;

                return GeneralSwitchListTile(
                  hideToggle: isPledgedByOtherUser ? true : false,
                  tileColor: gift.status == 'Available'
                      ? ThemeClass.blueThemeColor
                      : gift.pledgerId == currentUser.id
                          ? ThemeClass.yellowThemeColor
                          : ThemeClass.greenThemeColor,
                  text: gift.name,
                  leadingImgPath: 'assets/icons/Miscellaneous/ps4.png',
                  subtitile: "Category: ${gift.category}, Price: ${gift.price}",
                  toggleValue: gift.status == 'Available' ? false : true,
                  onToggleChanged: (value) async {
                    if (value) {
                      gift.status = "Pledged";
                      gift.pledgerId = currentUser.id;
                      print(gift.id);
                    } else {
                      gift.status = "Available";
                      gift.pledgerId = null;
                    }
                    await GiftController.updateGift(gift);
                    setState(() {});
                  },
                );
              },
              emptyBuilder: (context) {
                return Center(
                  child: Text(
                    'No gifts yet for this event!',
                    style: ThemeClass.theme.textTheme.bodyLarge,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
