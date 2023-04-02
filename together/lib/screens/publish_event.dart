import 'package:flutter/material.dart';
import 'package:together/components/appbar.dart';


class PublishEventScreen extends StatelessWidget {
  const PublishEventScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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

  Widget myTextField(IconData icon, String eventName) {
  return Container(
    margin: const EdgeInsets.symmetric(horizontal: 30.0,vertical: 10.0),
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
