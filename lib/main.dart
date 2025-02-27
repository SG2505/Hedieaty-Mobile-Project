import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hedieaty/Config/router.dart';
import 'package:hedieaty/Config/theme.dart';
import 'package:hedieaty/Firebase/FCM.dart';
import 'package:hedieaty/Model/AppUser.dart';
import 'package:hedieaty/SQL_Local/LocalDB.dart';

late AppUser currentUser;
late int autoSync;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  final localDB = LocalDB();
  await FirebaseMessagingService().initNotifications();
  //await localDB.resetDatabase2();
  //await localDB.database; // initializes the db

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: Size(
          MediaQuery.of(context).size.width, MediaQuery.of(context).size.width),
      child: MaterialApp.router(
          color: ThemeClass.blueThemeColor,
          title: 'Hedieaty',
          debugShowCheckedModeBanner: false,
          routerConfig: RouterClass.router,
          theme: ThemeClass.theme),
    );
  }
}
