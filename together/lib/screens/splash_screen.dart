import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:together/components/bottom_navigation_bar.dart';
import 'package:together/screens/auth/signup.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool userLogged = false;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: _auth.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            User? user = snapshot.data as User?;
            Future.delayed(Duration(seconds: 5)).then((value) => {
                  if (user == null)
                    {
                      Navigator.pushReplacementNamed(
                          context, '/sign_up')
                    }
                  else
                    {Navigator.pushReplacementNamed(context, '/home')}
                });

            return Center(child: Image.asset('assets/icons/splash_logo.gif'));
          } else {
            // Connection is not yet established
            return Center(child: Image.asset('assets/icons/splash_logo.gif'));
          }
        },
      ),
    );
  }
}
