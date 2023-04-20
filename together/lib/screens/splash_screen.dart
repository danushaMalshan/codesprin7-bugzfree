import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
    return SafeArea(
      child: Scaffold(
        body: StreamBuilder(
          stream: _auth.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.active) {
              User? user = snapshot.data as User?;
              Future.delayed(const Duration(seconds: 5)).then((value) => {
                    if (user == null)
                      {Navigator.pushReplacementNamed(context, '/login')}
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
      ),
    );
  }
}
