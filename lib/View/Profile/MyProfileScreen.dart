import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:hedieaty/Config/theme.dart';
import 'package:hedieaty/View/Widgets/GeneralTile.dart';
import 'package:hedieaty/View/Widgets/AppBar.dart';
import 'package:hedieaty/main.dart';

class MyProfileScreen extends StatefulWidget {
  const MyProfileScreen({super.key});

  @override
  State<MyProfileScreen> createState() => _MyProfileScreenState();
}

class _MyProfileScreenState extends State<MyProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
          appBarActions: [], title: currentUser.name, isTherebackButton: true),
      body: SingleChildScrollView(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(
            height: 5,
          ),
          Material(
            shape: CircleBorder(),
            color: ThemeClass.blueThemeColor,
            child: InkWell(
              onTap: () {},
              borderRadius: BorderRadius.circular(90),
              child: Container(
                width: 0.41.sw,
                height: 0.2.sh,
                alignment: Alignment.center,
                child: Text(
                  'Tap to set image',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Text(
            currentUser.name,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton.icon(
                style: ButtonStyle(
                    backgroundColor:
                        WidgetStatePropertyAll(ThemeClass.blueThemeColor)),
                iconAlignment: IconAlignment.end,
                onPressed: () {
                  context.pushNamed('editInfo');
                },
                label: Text(
                  'Edit Profile Info',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                icon: Image.asset(
                    alignment: Alignment.centerRight,
                    width: 23,
                    height: 23,
                    'assets/icons/ProfileScreenIcons/edit.png'),
              ),
              SizedBox(
                width: 10,
              ),
              TextButton.icon(
                style: ButtonStyle(
                    backgroundColor:
                        WidgetStatePropertyAll(ThemeClass.blueThemeColor)),
                iconAlignment: IconAlignment.end,
                onPressed: () {
                  context.push('/EditInfo');
                },
                label: Text(
                  'Notifications',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                icon: Image.asset(
                    alignment: Alignment.centerRight,
                    width: 23,
                    height: 23,
                    'assets/icons/ProfileScreenIcons/notification.png'),
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Divider(
            indent: 20,
            endIndent: 20,
            thickness: 2,
            color: Colors.grey.shade300,
          ),
          SizedBox(
            height: 12,
          ),
          GeneralTile(
            text: 'My Pledged Gifts',
            leadingImgPath: 'assets/icons/ProfileScreenIcons/pledgedgift.png',
            trailingImgPath: 'assets/icons/GiftListScreenIcons/next.png',
            iconFucntion: () => context.push('/MyPledgedGifts'),
            tileFucntion: () => context.push('/MyPledgedGifts'),
          ),
          SizedBox(
            height: 12,
          ),
          GeneralTile(
            text: 'My Events',
            leadingImgPath: 'assets/icons/CategoryIcons/event.png',
            trailingImgPath: 'assets/icons/GiftListScreenIcons/next.png',
            iconFucntion: () => context.pushNamed('myEvents'),
            tileFucntion: () => context.pushNamed('myEvents'),
          ),
        ],
      )),
    );
  }
}
