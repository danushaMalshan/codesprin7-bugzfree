import 'package:flutter/material.dart';
import 'package:together/components/appbar.dart';


class UserDetailsScreen extends StatelessWidget {
  const UserDetailsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                  backgroundImage:
                      AssetImage('assets/images/Profile Picture.jpg'),
                  radius: 100.0,
                ),
              ),
              Container(
                  margin: EdgeInsets.symmetric(vertical: 20.0),
                  child:
                      const Text('Let\'s make some changes on your profile!')),
              myListTile('Change User Name'),
              myListTile('Change Password'),
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
