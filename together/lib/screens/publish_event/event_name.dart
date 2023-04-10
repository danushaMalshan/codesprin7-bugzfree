import 'package:flutter/material.dart';
import '../../components/appbar.dart';

class EventPublish1 extends StatefulWidget {
  const EventPublish1({Key? key}) : super(key: key);

  @override
  State<EventPublish1> createState() => _EventPublish1State();
}

class _EventPublish1State extends State<EventPublish1> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: myAppBar(),
      body: SafeArea(
        child: ListView(
          children: <Widget>[
            Container(
              margin: const EdgeInsets.symmetric(vertical: 20.0),
              width: width,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'It\'s good to see you as a Organizer!',
                    style: messagePreviewTextStyle(),
                  ),
                  Text(
                    'Tell us about your Event',
                    style: messagePreviewTextStyle(),
                  ),
                ],
              ),
            ),
            textField(Icons.festival_outlined, 'Name of the Event', 1),
            textField(Icons.description, 'Description', 4),
            textFieldWithButtons(
                Icons.edit_calendar, Icons.date_range, 'Date', 1),
            Row(
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: textFieldWithButtons(
                      Icons.more_time, Icons.schedule, 'Start', 1),
                ),
                Expanded(
                  flex: 1,
                  child: textFieldWithButtons(
                      Icons.more_time, Icons.update, 'End', 1),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

Widget textField(IconData icon, String hintText, int maxLines) {
  return Padding(
    padding: const EdgeInsets.only(
      top: 30.0,
      left: 25.0,
      right: 25.0,
    ),
    child: TextField(
      decoration: InputDecoration(
        icon: Icon(
          icon,
          color: const Color(0xff142867),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.0),
          borderSide: const BorderSide(
            width: 2,
            color: Color(0xff142867),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.0),
          borderSide: const BorderSide(
            width: 2,
            color: Color(0xff142867),
          ),
        ),
        hintText: hintText,
        hintStyle: const TextStyle(
          fontSize: 18.0,
          //color: Color(0xff142867),
        ),
      ),
      maxLines: maxLines,
    ),
  );
}

Widget textFieldWithButtons(
    IconData suffIcon, IconData icon, String hintText, int maxLines) {
  return Padding(
    padding: const EdgeInsets.only(
      top: 30.0,
      left: 25.0,
      right: 25.0,
    ),
    child: TextField(
      decoration: InputDecoration(
        icon: Icon(
          icon,
          color: const Color(0xff142867),
        ),
        suffixIcon: IconButton(
          onPressed: () {},
          icon: Icon(
            suffIcon,
            color: const Color(0xff142867),
            size: 30,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.0),
          borderSide: const BorderSide(
            width: 2,
            color: Color(0xff142867),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.0),
          borderSide: const BorderSide(
            width: 2,
            color: Color(0xff142867),
          ),
        ),
        hintText: hintText,
        hintStyle: const TextStyle(
          fontSize: 18.0,
          //color: Color(0xff142867),
        ),
      ),
      maxLines: maxLines,
    ),
  );
}

TextStyle messagePreviewTextStyle() {
  return const TextStyle(
    fontSize: 22.0,
    fontWeight: FontWeight.bold,
    color: Color(0xff142867),
  );
}
