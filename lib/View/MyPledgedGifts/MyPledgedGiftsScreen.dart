import 'package:flutter/material.dart';
import 'package:hedieaty/View/Widgets/AppBar.dart';
import 'package:hedieaty/View/Widgets/GeneralTile.dart';

class MyPledgedGiftsScreen extends StatefulWidget {
  const MyPledgedGiftsScreen({super.key});

  @override
  State<MyPledgedGiftsScreen> createState() => _MyPledgedGiftsScreenState();
}

class _MyPledgedGiftsScreenState extends State<MyPledgedGiftsScreen> {
  TextEditingController searchBarController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
          appBarActions: [],
          title: 'My Pledged Gifts',
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
            GeneralTile(
              text: 'PS5',
              subtitle:
                  'Friend: John Doe\nEvent: Birthday\nDue Date: 15/10/2024',
              leadingImgPath: 'assets/icons/Miscellaneous/ps4.png',
              trailingImgPath: 'assets/icons/Miscellaneous/delete.png',
              iconFucntion: () {},
            ),
            GeneralTile(
              text: 'To Mars Book',
              subtitle:
                  'Friend: John Doe\nEvent: Birthday\nDue Date: 15/10/2024',
              leadingImgPath: 'assets/icons/Miscellaneous/book.png',
              trailingImgPath: 'assets/icons/Miscellaneous/delete.png',
              iconFucntion: () {},
            ),
            GeneralTile(
              text: 'ChessBoard',
              subtitle:
                  'Friend: John Doe\nEvent: Birthday\nDue Date: 15/10/2024',
              leadingImgPath: 'assets/icons/Miscellaneous/chess.png',
              trailingImgPath: 'assets/icons/Miscellaneous/delete.png',
              iconFucntion: () {},
            ),
            GeneralTile(
              text: 'To Mars Book',
              subtitle:
                  'Friend: John Doe\nEvent: Birthday\nDue Date: 15/10/2024',
              leadingImgPath: 'assets/icons/Miscellaneous/flashlight.png',
              trailingImgPath: 'assets/icons/Miscellaneous/delete.png',
              iconFucntion: () {},
            ),
          ],
        ),
      ),
    );
  }
}
