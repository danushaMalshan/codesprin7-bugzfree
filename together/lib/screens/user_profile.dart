import 'package:flutter/material.dart';
import 'package:together/components/appbar.dart';
import 'package:together/components/my_list_tile.dart';


class UserProfileScreen extends StatelessWidget {
  const UserProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                        'assets/images/Profile Picture.jpg',
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

  Container myListTile(String listTitle) {
  return Container(
    margin: EdgeInsets.symmetric(
      vertical: 6.0,
      horizontal: 20.0,
    ),
    child: ListTile(
      contentPadding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 20.0),
      shape: RoundedRectangleBorder(
        side: BorderSide(
          width: 2,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      title: Text(listTitle),
      trailing: const Icon(Icons.arrow_forward_ios),
    ),
  );
}

}

