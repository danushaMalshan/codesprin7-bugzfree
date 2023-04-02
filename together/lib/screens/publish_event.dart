
import 'package:flutter/material.dart';
import 'package:together/components/appbar.dart';
import 'package:together/components/my_text_field.dart';

Widget eventPublish() {
  return Scaffold(
    appBar: myAppBar(),
    body: SafeArea(
      child: ListView(
        children: <Widget>[
          Center(
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 30.0),
              child: const Text('It\'s good to see you as an organizer!'),
            ),
          ),
          myTextField(Icons.festival, 'Event Name'),
          myTextField(Icons.location_on, 'Venue'),
          // Center(
          //   child: ListTile(
          //     leading: IconButton(
          //       iconSize: 50.0,
          //       icon: Icon(
          //         Icons.add_location_alt,
          //         color: Color(0xff142867),
          //       ),
          //       onPressed: () {},
          //     ),
          //     title: Text('Pin location from Google Maps'),
          //   ),
          // ),
          myTextField(Icons.money, 'Ticket Price'),
          // myTextField(Icons.schedule, 'Time'),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              primary: const Color(0xff142867),
            ),
            child: const Text('Review Details'),
          ),
        ],
      ),
    ),
  );
}
