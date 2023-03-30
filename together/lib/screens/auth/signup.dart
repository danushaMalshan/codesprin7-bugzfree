import 'package:flutter/material.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Image(
              image: AssetImage("Assets/Images/Logo.jpg"),
              height: 350,
              width: 300,
            ),
            SizedBox(height: 25),
            loginButtons("Continue with Apple", "Assets/Images/apple_logo.png",
                Colors.white, Colors.black),
            loginButtons(
              "Continue with Facebook",
              "Assets/Images/facebook.png",
              Colors.white,
              Color(0xff1877f2),
            ),
            loginButtons(
              "Continue with Google",
              "Assets/Images/google.png",
              const Color(0xff142867),
              const Color(0xffd9d9d9),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 30),
              child: Container(
                child: ListTile(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  tileColor: Color(0xffd9d9d9),
                  leading: Icon(Icons.mail_outline_rounded, size: 32),
                  title: Center(
                    child: Text(
                      "Continue with Email",
                      style: TextStyle(
                        color: Color(0xff142867),
                        fontSize: 20,
                      ),
                    ),
                  ),
                  trailing: Icon(Icons.ice_skating, color: Colors.transparent),
                ),
              ),
            ),
            Text("Already have an account?"),
          ],
        ),
      ),
    );
  }
}

Widget loginButtons(
    String title, String imagePath, Color titleColor, Color backColor) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 30),
    child: Container(
      child: ListTile(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        tileColor: backColor,
        leading: Image.asset(
          imagePath,
          height: 32,
        ),
        title: Center(
          child: Text(
            title,
            style: TextStyle(
              color: titleColor,
              fontSize: 20,
            ),
          ),
        ),
        trailing: Icon(Icons.ice_skating, color: Colors.transparent),
      ),
    ),
  );
}
