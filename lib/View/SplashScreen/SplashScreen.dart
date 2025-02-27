import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hedieaty/Config/theme.dart';
import 'package:go_router/go_router.dart';
import 'package:hedieaty/Firebase/FirebaseUserService.dart';
import 'package:hedieaty/Model/AppUser.dart';
import 'package:hedieaty/SQL_Local/LocalDB.dart';
import 'package:hedieaty/main.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 3), () {
      _checkLoginStatus();
    });
  }

  Future<void> _checkLoginStatus() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      var data = await FirebaseUserService().fetchUser(user.uid);
      currentUser = AppUser.fromJson(data!);
      await LocalDB().insertUser(currentUser);

      context.goNamed('home');
    } else {
      context.goNamed('login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeClass.blueThemeColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/icons/Miscellaneous/gift.png',
              width: 100,
              height: 100,
            ),
            const SizedBox(height: 20),
            Text(
              'Hedieaty',
              style: ThemeClass.theme.textTheme.displayLarge,
            ),
          ],
        ),
      ),
    );
  }
}
