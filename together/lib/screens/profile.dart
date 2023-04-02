import 'package:codesprin/components/appbar.dart';
import 'package:flutter/material.dart';
import 'components/my_list_tile.dart';

Widget myProfile() {
  return SafeArea(
    child: Scaffold(
      appBar: myAppBar(),
      body: SizedBox(
        width: double.infinity,
        child: Column(
          children: <Widget>[
            Row(
              children: [
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 10.0),
                    child: const CircleAvatar(
                      radius: 70,
                      backgroundImage: AssetImage(
                        'Assets/Images/dp.jpg',
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    alignment: Alignment.topLeft,
                    child: Column(
                      children: <Widget>[
                        const Text('Hi Vinuka'),
                        const Text('vinuka@gmail.com'),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: const Color(0xff142867),
                          ),
                          onPressed: () {},
                          child: const Text('Publish an Event'),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            myListTile('Change Profile Settings'),
            myListTile('Manage Reminders'),
            myListTile('Change Preferred Categories'),
            myListTile('Select Home Location'),
            myListTile('Logout'),
          ],
        ),
      ),
    ),
  );
}
