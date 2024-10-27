import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final List<Widget> appBarActions;
  final String title;
  final bool isTherebackButton;
  const CustomAppBar(
      {super.key,
      required this.appBarActions,
      required this.title,
      required this.isTherebackButton});

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
        preferredSize:
            Size.fromHeight(MediaQuery.of(context).size.height * 0.08),
        child: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(colors: [
                Color.fromRGBO(73, 211, 253, 1),
                Color.fromRGBO(179, 247, 239, 1)
              ], begin: Alignment.topLeft, end: Alignment.bottomRight),
              borderRadius: BorderRadius.circular(18)),
          child: AppBar(
            title: Text(
              title,
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            backgroundColor: Colors.transparent,
            shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.vertical(bottom: Radius.circular(25))),
            leading: isTherebackButton
                ? IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(Icons.arrow_back_ios_rounded))
                : null,
            actions: appBarActions,
          ),
        ));
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size.fromHeight(kToolbarHeight * 1.2);
}
