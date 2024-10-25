import 'package:flutter/material.dart';

class AppBarButton extends StatelessWidget {
  final double width;
  final double height;
  final Function onPressed;
  final String imagePath;
  final String label;
  const AppBarButton(
      {super.key,
      required this.onPressed,
      required this.width,
      required this.height,
      required this.imagePath,
      required this.label});

  @override
  Widget build(BuildContext context) {
    return Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        verticalDirection: VerticalDirection.down,
        direction: Axis.vertical,
        children: [
          IconButton(
              icon: Icon(
                Icons.home_outlined,
                color: Colors.grey,
              ),
              padding: EdgeInsets.zero,
              constraints: BoxConstraints(),
              onPressed: () {}),
          Center(child: Text("Home"))
        ]);
  }
}
