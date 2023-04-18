import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:together/components/bottom_navigation_bar.dart';
import 'package:together/firebase_options.dart';
import 'package:together/global.dart';
import 'package:together/screens/auth/email_verify.dart';
import 'package:together/screens/auth/signin.dart';
import 'package:together/screens/auth/signup.dart';
import 'package:together/screens/auth/signup_with_email.dart';
import 'package:together/screens/category_events.dart';
import 'package:together/screens/event_details.dart';
import 'package:together/screens/find_location.dart';
import 'package:together/screens/splash_screen.dart';
import 'package:together/screens/user_details.dart';
import 'package:together/screens/user_profile.dart';
import 'package:together/screens/publish_event.dart';
import 'package:together/screens/select_category.dart';
import 'package:together/screens/auth/firstscreen.dart';
import 'package:together/screens/all_messages.dart';
import 'package:together/screens/pending_reminders.dart';
import 'package:together/screens/reminders.dart';
import 'package:together/screens/publish_event/publish_event_first_screen.dart';
import 'package:together/screens/publish_event/publish_event_second_screen.dart';
import 'package:together/utils/colors.dart';
import '/screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
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
        primaryColor: AppColor.primaryColor,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          centerTitle: true,
          iconTheme: IconThemeData(
            color: AppColor.primaryColor,
          ),
          elevation: 2,
        ),
        scaffoldBackgroundColor: const Color(0xFFFFFFFF),
        fontFamily: 'Poppins',
      ),
      builder: (context, child) => ResponsiveWrapper.builder(
        child,
        maxWidth: 1200,
        minWidth: 480,
        defaultScale: true,
        breakpoints: [
          const ResponsiveBreakpoint.resize(480, name: MOBILE),
          const ResponsiveBreakpoint.autoScale(800, name: TABLET),
          const ResponsiveBreakpoint.resize(1000, name: DESKTOP),
        ],
        background: Container(
          color: const Color(0xFFF5F5F5),
        ),
      ),
      scaffoldMessengerKey: snackbarKey,
      navigatorKey: navigatorKey,
      // home: EmailVerifyScreen(),
      initialRoute: '/',
      routes: {
        '/': (context) => SplashScreen(),
        '/home': (context) => CustomNavigationBar(index: 2),
         '/profile': (context) => CustomNavigationBar(index: 1),
        '/login': (context) => SignInScreen(),
        '/sign_up': (context) => SignUp(),
        '/sign_up_with_email': (context) => SignUpWithEmail(),
        '/select_category': (context) => SelectCategoryScreen(),
      },
    );
  }
}
