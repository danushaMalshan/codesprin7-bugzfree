import 'package:flutter/material.dart';
import 'package:together/utils/colors.dart';

class FirstScreen extends StatefulWidget {
  const FirstScreen({Key? key}) : super(key: key);

  @override
  State<FirstScreen> createState() => _FirstScreenState();
}

class _FirstScreenState extends State<FirstScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            const SizedBox(
              width: double.infinity,
            ),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 50.0),
              child: const Image(
                image: AssetImage("assets/images/logo.jpeg"),
                height: 250,
                width: 250,
              ),
            ),
            const SizedBox(
              height: 200,
            ),
            loginButtons(
              'Sign up',
              const Color(0xffd9d9d9),
              AppColor.primaryColor,
            ),
            loginButtons(
              'Log in',
               AppColor.primaryColor,
              const Color(0xffd9d9d9),
            ),
          ],
        ),
      ),
    );
  }
}

Widget loginButtons(String title, Color titleColor, Color backColor) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 40),
    child: ListTile(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      tileColor: backColor,
      title: Center(
        child: Text(
          title,
          style: TextStyle(
            color: titleColor,
            fontSize: 20,
          ),
        ),
      ),
      trailing: const Icon(Icons.ice_skating, color: Colors.transparent),
    ),
  );
}
