import 'package:flutter/material.dart';

class homeScreen extends StatefulWidget {
  const homeScreen({Key? key}) : super(key: key);

  @override
  State<homeScreen> createState() => _homeScreenState();
}

class _homeScreenState extends State<homeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myAppBar(),
      body: SafeArea(
        child: ListView(
          children: <Widget>[
            Container(
              margin:
                  const EdgeInsets.symmetric(vertical: 30.0, horizontal: 20.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(35.0),
                border: Border.all(
                  width: 2.0,
                  color: const Color(0xff142867),
                ),
              ),
              child: const ListTile(
                leading: Icon(
                  Icons.search,
                  size: 35,
                ),
                title: TextField(
                  decoration: InputDecoration(
                    labelText: "Search for Event",
                  ),
                ),
                trailing: Icon(
                  Icons.tune,
                  size: 35,
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 2.0),
              child: Text(
                "Trending",
                style: homeTextStyle(),
              ),
            ),
            // ListView(
            //   scrollDirection: Axis.horizontal,
            // ),
          ],
        ),
      ),
    );
  }
}

//AppBar goes here...

PreferredSize myAppBar() {
  return PreferredSize(
    preferredSize: const Size.fromHeight(60),
    child: AppBar(
      backgroundColor: Colors.white,
      title: const Align(
        alignment: Alignment.center,
        child: Image(
          image: AssetImage(
            'assets/images/Logo & Name__1.png',
          ),
          height: 40,
          // width: 140,
        ),
      ),
      actions: const [
        SizedBox(width: 50),
      ],
    ),
  );
}

//TextStyles for home page goes here...

TextStyle homeTextStyle() {
  return const TextStyle(
    fontSize: 25.0,
    fontWeight: FontWeight.bold,
  );
}
