import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:hedieaty/Config/theme.dart';
import 'package:hedieaty/View/Widgets/AppBar.dart';

class Giftlistscreen extends StatefulWidget {
  const Giftlistscreen({super.key});

  @override
  State<Giftlistscreen> createState() => _GiftlistscreenState();
}

class _GiftlistscreenState extends State<Giftlistscreen> {
  TextEditingController searchBarController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(appBarActions: [
        IconButton(
            tooltip: 'Add Gift',
            onPressed: () {},
            icon: Icon(
              size: 40,
              Icons.add_circle_rounded,
              color: const Color.fromRGBO(50, 48, 48, 1),
            ))
      ], title: 'My Gift List', isTherebackButton: true),
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
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
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
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            ListView(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              children: [
                for (var i = 0; i < 4; i++)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListTile(
                      onTap: () {
                        context.push('/GiftDetails');
                      },
                      leading: Image.asset(
                        'assets/icons/GiftListScreenIcons/gift.png',
                        width: 60,
                        height: 60,
                      ),
                      title: Text(
                        'Special Gift',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      subtitle: Text(
                        'Category: Special',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      trailing: IconButton(
                          onPressed: () {
                            context.push('/GiftDetails');
                          },
                          icon: Image.asset(
                              width: 35,
                              height: 35,
                              'assets/icons/GiftListScreenIcons/next.png')),
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListTile(
                    tileColor: ThemeClass.greenThemeColor,
                    onTap: () {
                      context.push('/GiftDetails');
                    },
                    leading: Image.asset(
                      'assets/icons/GiftListScreenIcons/gift.png',
                      width: 60,
                      height: 60,
                    ),
                    title: Text(
                      'Special Gift',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    subtitle: Text(
                      'Category: Special',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    trailing: IconButton(
                        onPressed: () => context.push('/GiftDetails'),
                        icon: Image.asset(
                            width: 35,
                            height: 35,
                            'assets/icons/GiftListScreenIcons/next.png')),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
