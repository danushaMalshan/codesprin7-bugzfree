import 'package:flutter/material.dart';
import 'package:together/components/appbar.dart';
import 'package:together/components/bottom_navigation_bar.dart';

class PublishEventScreen extends StatelessWidget {
  const PublishEventScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: myAppBar(),
      body: SafeArea(
        child: Center(
          child: Column(
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(top: 10.0),
                child: Column(
                  children: <Widget>[
                    Text('It\'s good to see you as a Event Organizer'),
                    Text('Tell us about your Event'),
                  ],
                ),
              ),
              TextField(),
            ],
          ),
        ),
      ),
    );
  }

  Widget myTextField(IconData icon, String eventName) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
      child: TextField(
        decoration: InputDecoration(
          labelText: eventName,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          icon: Icon(
            icon,
            color: Color(0xff142867),
          ),
        ),
      ),
    );
  }
}
