import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class EventDetailsTile extends StatelessWidget {
  final String text;
  final String leadingImgPath;
  final String? trailingImgPath;
  final bool? isGoToGiftList;
  const EventDetailsTile(
      {super.key,
      required this.text,
      required this.leadingImgPath,
      this.isGoToGiftList,
      this.trailingImgPath});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(15.0, 8, 15, 8),
      child: ListTile(
          leading: Image.asset(
            leadingImgPath,
            width: 35,
            height: 35,
          ),
          title: Text(
            textAlign: TextAlign.center,
            text,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          trailing: isGoToGiftList == null
              ? null
              : IconButton(
                  alignment: Alignment.centerRight,
                  onPressed: () {
                    context.push('/GiftList');
                  },
                  icon: Image.asset(
                    trailingImgPath!,
                    width: 35,
                    height: 35,
                  )),
          onTap: () {
            isGoToGiftList == null ? null : context.push('/GiftList');
          }),
    );
  }
}
