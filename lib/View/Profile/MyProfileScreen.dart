import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:hedieaty/Config/theme.dart';
import 'package:hedieaty/View/Widgets/GeneralTile.dart';
import 'package:hedieaty/View/Widgets/AppBar.dart';

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
          appBarActions: [], title: 'My Profile', isTherebackButton: true),
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
            'Salah',
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
                  context.push('/EditInfo');
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
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'My Events',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                TextButton(
                  onPressed: () => context.push('/MyEvents'),
                  child: Text(
                    'Go to my events',
                    style: TextStyle(
                        color: Color.fromRGBO(24, 192, 218, 1),
                        fontFamily: 'League Spartan',
                        fontWeight: FontWeight.w900,
                        fontSize: 20),
                  ),
                ),
              ],
            ),
          ),
          GeneralTile(
            text: 'Event 1',
            leadingImgPath: 'assets/icons/CategoryIcons/birthday.png',
            subtitle: 'Date: 15/12/2024\nCategory: Birthday',
            trailingImgPath: 'assets/icons/GiftListScreenIcons/next.png',
            iconFucntion: () => context.push('/EventDetails'),
          ),
          GeneralTile(
            text: 'Event 2',
            leadingImgPath: 'assets/icons/CategoryIcons/anniversary.png',
            subtitle: 'Date: 15/12/2024\nCategory: Anniversary',
            trailingImgPath: 'assets/icons/GiftListScreenIcons/next.png',
            iconFucntion: () => context.push('/EventDetails'),
          ),
        ],
      )),
    );
  }
}
