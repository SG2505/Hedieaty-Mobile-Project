import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class GeneralSwitchListTile extends StatelessWidget {
  final String text;
  final String subtitile;
  final String leadingImgPath;
  final Color? tileColor;
  final bool toggleValue;
  final bool? hideToggle;
  final ValueChanged<bool> onToggleChanged;
  final VoidCallback? tileOnTap;
  const GeneralSwitchListTile({
    super.key,
    required this.text,
    required this.leadingImgPath,
    required this.subtitile,
    required this.toggleValue,
    required this.onToggleChanged,
    this.tileColor,
    this.tileOnTap,
    this.hideToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(15.0, 8, 15, 8),
      child: ListTile(
        onTap: tileOnTap,
        tileColor: tileColor,
        leading: Image.asset(
          leadingImgPath,
          width: 60,
          height: 60,
        ),
        title: Text(
          textAlign: TextAlign.start,
          text,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        subtitle: Text(
          textAlign: TextAlign.start,
          subtitile,
          style: Theme.of(context).textTheme.labelMedium,
        ),
        trailing: hideToggle == null
            ? CupertinoSwitch(
                activeColor: Color.fromRGBO(55, 154, 189, 1),
                value: toggleValue, // Current state of the toggle
                onChanged:
                    onToggleChanged, // Function to call when toggle changes
              )
            : null,
      ),
    );
  }
}
