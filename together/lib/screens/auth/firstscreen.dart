import 'package:flutter/material.dart';

class firstScreen extends StatefulWidget {
  const firstScreen({Key? key}) : super(key: key);

  @override
  State<firstScreen> createState() => _firstScreenState();
}

class _firstScreenState extends State<firstScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          SizedBox(
            width: double.infinity,
          ),
          Container(
            margin: EdgeInsets.symmetric(vertical: 50.0),
            child: Image(
              image: AssetImage("assets/images/logo.jpeg"),
              height: 250,
              width: 250,
            ),
          ),
          SizedBox(
            height: 200,
          ),
          loginButtons(
            'Sign up',
            const Color(0xffd9d9d9),
            const Color(0xff142867),
          ),
          loginButtons(
            'Log in',
            const Color(0xff142867),
            const Color(0xffd9d9d9),
          ),
        ],
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
