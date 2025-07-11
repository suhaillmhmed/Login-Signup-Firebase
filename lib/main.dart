import 'package:day1task/views/home_screen.dart';
import 'package:day1task/views/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:day1task/Styles/theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(
    ResponsiveSizer(
      builder: (context, orientation, screenType) {
        return const MyApp();
      },
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: appDarkTheme,
      home: LoginScreen(),
    );
  }
}
