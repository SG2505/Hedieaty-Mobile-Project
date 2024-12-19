import 'package:flutter/material.dart';
import 'package:hedieaty/Config/theme.dart';
import 'package:hedieaty/Firebase/FirebaseGiftService.dart';
import 'package:hedieaty/Model/Gift.dart';
import 'package:hedieaty/View/Widgets/AppBar.dart';
import 'package:hedieaty/View/Widgets/GeneralTile.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

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
            FutureBuilder<List<Map<String, dynamic>>>(
              future: FirebaseGiftService().getPledgedGiftsWithEventAndFriend(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                      child: LoadingAnimationWidget.inkDrop(
                          color: ThemeClass.blueThemeColor, size: 60));
                } else if (snapshot.hasError ||
                    !snapshot.hasData ||
                    snapshot.data!.isEmpty) {
                  return const Center(child: Text("No pledged gifts found."));
                }

                final gifts = snapshot.data!;

                return ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(10),
                  itemCount: gifts.length,
                  itemBuilder: (context, index) {
                    final giftEventFreindMap = gifts[index];
                    final date = giftEventFreindMap['event'].date as DateTime;
                    return GeneralTile(
                      text: giftEventFreindMap['gift'].name,
                      subtitle:
                          'Friend: ${giftEventFreindMap['friend'].name}\nEvent: ${giftEventFreindMap['event'].name}\nDue Date: ${date.day}-${date.month}-${date.year}',
                      leadingImgPath: giftEventFreindMap['gift'].imageUrl ??
                          'assets/icons/LoginScreenIcons/gift.png',
                      trailingImgPath: 'assets/icons/Miscellaneous/delete.png',
                      iconFucntion: () async {
                        final gift = giftEventFreindMap['gift'] as Gift;
                        gift.status = "Available";
                        gift.pledgerId = null;
                        await FirebaseGiftService().updateGift(gift);
                        setState(() {});
                      },
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
