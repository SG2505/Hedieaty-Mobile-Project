import 'package:flutter/material.dart';

class GeneralTile extends StatelessWidget {
  final String text;
  final String? subtitle;
  final String leadingImgPath;
  //if passing trailing img path an icon function needs to be passed even if empty for the trailing image  to show
  final String? trailingImgPath;
  final VoidCallback? tileFucntion;
  final VoidCallback? iconFucntion;
  final Color? tileColor;
  const GeneralTile(
      {super.key,
      required this.text,
      required this.leadingImgPath,
      this.trailingImgPath,
      this.subtitle,
      this.tileFucntion,
      this.iconFucntion,
      this.tileColor});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(15, 8, 15, 8),
      child: ListTile(
          tileColor: tileColor,
          leading: Uri.tryParse(leadingImgPath)!.hasAbsolutePath
              ? Image.network(
                  leadingImgPath,
                  width: 70,
                  height: 70,
                  errorBuilder: (context, error, stackTrace) {
                    return Image.asset(
                      'assets/icons/Miscellaneous/gift.png',
                      width: 50,
                      height: 50,
                    );
                  },
                )
              : Image.asset(
                  leadingImgPath,
                  width: 50,
                  height: 50,
                ),
          title: Text(
            textAlign: TextAlign.left,
            text,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          subtitle: subtitle == null
              ? null
              : Text(
                  textAlign: TextAlign.left,
                  subtitle!,
                  style: Theme.of(context).textTheme.labelMedium,
                ),
          trailing: iconFucntion == null
              ? null
              : IconButton(
                  alignment: Alignment.centerRight,
                  onPressed: iconFucntion,
                  icon: Image.asset(
                    trailingImgPath!,
                    width: 35,
                    height: 35,
                  )),
          onTap: () {}),
    );
  }
}
