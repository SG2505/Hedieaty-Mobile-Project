import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_snake_navigationbar/flutter_snake_navigationbar.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap; // Function to call when an item is tapped

  const CustomBottomNavigationBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final List<String> labels = ['Home', 'Events', 'Profile', 'Settings'];
    final List<String> images = [
      'assets/icons/NavigationBarIcons/home.png',
      'assets/icons/NavigationBarIcons/myEvents.png',
      'assets/icons/NavigationBarIcons/profile.png',
      'assets/icons/NavigationBarIcons/settings.png'
    ];

    return SnakeNavigationBar.color(
      height: 70,
      elevation: 100,
      selectedLabelStyle:
          TextStyle(fontSize: 12, color: Color.fromRGBO(135, 217, 250, 1)),
      unselectedLabelStyle: TextStyle(fontSize: 12),
      backgroundColor: Color.fromRGBO(0, 0, 0, 0.8),
      behaviour: SnakeBarBehaviour.floating,
      snakeShape: SnakeShape.indicator,
      snakeViewColor: Color.fromRGBO(48, 49, 50, 1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(35)),
      padding: EdgeInsets.all(8),
      selectedItemColor: Color.fromRGBO(135, 217, 250, 1),
      unselectedItemColor: Colors.white,
      showUnselectedLabels: true,
      showSelectedLabels: true,
      currentIndex: currentIndex,
      onTap: (index) {
        // Call the parent widget's onTap to update the index
        onTap(index);

        switch (index) {
          case 0:
            context.go('/'); // Navigate to home
            break;
          case 1:
            context.pushNamed('myEvents'); // Navigate to events
            break;
          case 2:
            context.pushNamed('myProfile'); // Navigate to profile
            break;
          case 3:
            context.pushNamed('settings'); // Navigate to settings
            break;
          default:
            break;
        }
      },
      items: List.generate(
        images.length,
        (index) => BottomNavigationBarItem(
          icon: Image.asset(
            images[index], // Use the image path for the icon
            width: 35, // Set width for uniformity
            height: 35, // Set height for uniformity
            color: currentIndex == index
                ? Color.fromRGBO(135, 217, 250, 1)
                : Colors.white, // Color based on selection
          ),
          label: labels[index], // Use the corresponding label
        ),
      ),
    );
  }
}
