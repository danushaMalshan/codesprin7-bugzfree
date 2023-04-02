import 'package:flutter/material.dart';
import 'package:together/components/appbar.dart';
import 'package:together/components/my_list_tile.dart';

Widget changeUserDetails() {
  return Scaffold(
    backgroundColor: Colors.white,
    appBar: myAppBar(),
    body: SafeArea(
      child: Container(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              margin: EdgeInsets.symmetric(vertical: 20),
              child: CircleAvatar(
                backgroundImage: AssetImage('Assets/Images/dp.jpg'),
                radius: 100.0,
              ),
            ),
            Container(
                margin: EdgeInsets.symmetric(vertical: 20.0),
                child: const Text('Let\'s make some changes on your profile!')),
            myListTile('Change User Name'),
            myListTile('Change Password'),
          ],
        ),
      ),
    ),
  );
}
