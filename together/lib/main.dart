import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:together/components/bottom_navigation_bar.dart';
import 'package:together/screens/auth/signin.dart';
import 'package:together/screens/auth/signup.dart';
import 'package:together/screens/category_events.dart';
import 'package:together/screens/event_details.dart';
import 'package:together/screens/find_location.dart';
import 'package:together/screens/user_details.dart';
import 'package:together/screens/user_profile.dart';
import 'package:together/screens/publish_event.dart';
import 'package:together/screens/select_category.dart';
import 'package:together/screens/auth/firstscreen.dart';
import 'package:together/screens/all_messages.dart';
import '/screens/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xFF142867),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          centerTitle: true,
          iconTheme: IconThemeData(
            color: Color(0xFF142867),
          ),
          elevation: 2,
        ),
        scaffoldBackgroundColor: const Color(0xFFFFFFFF),
        fontFamily: 'Poppins',
      ),
      builder: (context, child) => ResponsiveWrapper.builder(child,
          maxWidth: 1200,
          minWidth: 480,
          defaultScale: true,
          breakpoints: [
            const ResponsiveBreakpoint.resize(480, name: MOBILE),
            const ResponsiveBreakpoint.autoScale(800, name: TABLET),
            const ResponsiveBreakpoint.resize(1000, name: DESKTOP),
          ],
          background: Container(color: const Color(0xFFF5F5F5))),
      home: CustomNavigationBar(index: 2),
    );
  }
}
