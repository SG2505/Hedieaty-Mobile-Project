import 'package:flutter/material.dart';
import 'package:hedieaty/Config/theme.dart';
import 'package:hedieaty/Controller/EventController.dart';
import 'package:hedieaty/Controller/UserController.dart';
import 'package:hedieaty/Firebase/AuthService.dart';
import 'package:hedieaty/View/Widgets/AppBar.dart';
import 'package:hedieaty/View/Widgets/CustomBottomNavigationBar.dart';
import 'package:hedieaty/View/Widgets/GeneralSwitchListTile.dart';
import 'package:hedieaty/View/Widgets/GeneralTile.dart';
import 'package:hedieaty/main.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:restart_app/restart_app.dart';
import 'package:toastification/toastification.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  int currentIndex = 3;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
          appBarActions: [], title: "Settings", isTherebackButton: true),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
          currentIndex = 3;
        },
      ),
      body: ListView(
        children: [
          GeneralSwitchListTile(
            text: "Auto Cloud Publish",
            leadingImgPath: "assets/icons/Miscellaneous/cloud-sync.png",
            subtitile: "",
            hideToggle: false,
            toggleValue: autoSync == 1 ? true : false,
            onToggleChanged: (value) async {
              if (value) {
                autoSync = 1;
                currentUser.preferences['autoSync'] = 1;

                _showLoadingPopUp(context);
                var result = await EventController.syncUnpublishedData();
                Navigator.of(context).pop();
                setState(() {});
                toastification.show(
                    context: context,
                    autoCloseDuration: const Duration(seconds: 5),
                    alignment: Alignment.topCenter,
                    icon: Icon(
                      result ? Icons.check_circle : Icons.cancel,
                      color: result ? Colors.green : Colors.red,
                    ),
                    title: Text(result
                        ? "Syncing Successful"
                        : "Syncing failed Please try again"));
              } else {
                setState(() {
                  autoSync = 0;
                  currentUser.preferences['autoSync'] = 0;
                });
              }
              await UserController.updateUser(
                  userId: currentUser.id!,
                  name: currentUser.name,
                  email: currentUser.email,
                  phoneNumber: currentUser.phoneNumber,
                  preferences: currentUser.preferences);
            },
          ),
          GeneralTile(
            text: "Logout",
            leadingImgPath: "assets/icons/Miscellaneous/sign-out.png",
            trailingImgPath: "assets/icons/GiftListScreenIcons/next.png",
            iconFucntion: () async {
              await Authservice().signOut();
              Restart.restartApp();
            },
          )
        ],
      ),
    );
  }

  Future<void> _showLoadingPopUp(BuildContext context) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Row(
            children: [
              LoadingAnimationWidget.inkDrop(
                  color: ThemeClass.blueThemeColor, size: 60),
              SizedBox(width: 20),
              Text("Syncing data..."),
            ],
          ),
        );
      },
    );
  }
}
