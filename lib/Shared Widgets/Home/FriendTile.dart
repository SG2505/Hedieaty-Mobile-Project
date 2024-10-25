import 'package:flutter/material.dart';

class Friendtile extends StatelessWidget {
  final String title;
  final String subtitle;
  final String imgPath;
  final int numOfEvents;
  const Friendtile(
      {super.key,
      required this.title,
      required this.subtitle,
      required this.imgPath,
      required this.numOfEvents});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(15.0, 8, 15, 8),
      child: ListTile(
        onTap: () {},
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        tileColor: Color.fromRGBO(206, 240, 252, 1),
        leading: CircleAvatar(
          radius: 25,
          backgroundImage: AssetImage(imgPath),
        ),
        title: Text(
          title,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        subtitle: Text(
          subtitle,
          style: Theme.of(context).textTheme.bodySmall,
        ),
        trailing: CircleAvatar(
          backgroundColor: Colors.black,
          child: Text(
            '$numOfEvents',
            style: TextStyle(
                fontFamily: 'League Spartan',
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Color.fromRGBO(206, 240, 252, 1)),
          ),
        ),
      ),
    );
  }
}
