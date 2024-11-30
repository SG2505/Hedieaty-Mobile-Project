import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hedieaty/Config/router.dart';
import 'package:hedieaty/Config/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
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
