import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class EventTile extends StatelessWidget {
  final String title;
  final String date;
  final String category;
  final String status;
  final String imgPath;
  const EventTile(
      {super.key,
      required this.title,
      required this.imgPath,
      required this.date,
      required this.category,
      required this.status});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(15.0, 8, 15, 8),
      child: ListTile(
        title: Text(
          title,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        tileColor: Color.fromRGBO(206, 240, 252, 1),
        subtitle: Text(
          'Date: $date\nStatus: $status\nCategory: $category',
          style: Theme.of(context).textTheme.bodySmall,
        ),
        leading: imgPath == ''
            ? Icon(
                Icons.star_rate_rounded,
                color: Colors.yellow.shade400,
                size: 60,
              )
            : Image.asset(
                imgPath,
                width: 35,
                height: 35,
              ),
        trailing: IconButton(
            onPressed: () {},
            icon: Image.asset(
              'assets/icons/EventScreenIcons/delete.png',
              width: 35,
              height: 35,
            )),
        onTap: () => context.push('/EventDetails'),
      ),
    );
  }
}
