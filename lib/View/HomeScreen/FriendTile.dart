import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hedieaty/Model/AppUser.dart';
import 'package:hedieaty/Model/Event.dart';

class Friendtile extends StatelessWidget {
  final String title;
  final String subtitle;
  final String imgPath;
  final int numOfEvents;
  final List<Event>? events;
  final AppUser friend;
  const Friendtile(
      {super.key,
      required this.title,
      required this.subtitle,
      required this.imgPath,
      required this.numOfEvents,
      this.events,
      required this.friend});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(15.0, 8, 15, 8),
      child: ListTile(
        onTap: () => context.pushNamed(
          'friendEvents',
          extra: {
            'events': events,
            'friend': friend,
          },
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        tileColor: Color.fromRGBO(206, 240, 252, 1),
        leading: CircleAvatar(
          radius: 25,
          backgroundImage: AssetImage(imgPath),
          backgroundColor: Colors.transparent,
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
            numOfEvents > 999 ? "+999" : '$numOfEvents',
            style: TextStyle(
                fontWeight: FontWeight.w900,
                fontSize: 25,
                color: Color.fromRGBO(206, 240, 252, 1)),
          ),
        ),
      ),
    );
  }
}
