import 'package:flutter/material.dart';
import 'package:together/components/appbar.dart';

class Reminders extends StatefulWidget {
  const Reminders({Key? key}) : super(key: key);

  @override
  State<Reminders> createState() => _RemindersState();
}

class _RemindersState extends State<Reminders> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: myAppBar(),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Container(
              width: width,
              margin: const EdgeInsets.only(
                  left: 10.0, top: 20.0, right: 10.0, bottom: 0.0),
              child: Text(
                'Reminders',
                textAlign: TextAlign.center,
                style: messagePreviewTextStyle(),
              ),
            ),
            Expanded(
              child: ListView(
                children: [
                  reminderTile('Bentota Beach Fiesta','Date: 25th March','Time: 7:30pm onwards'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Container reminderTile(String title, String sub1,String sub2){
  return Container(
    padding: const EdgeInsets.symmetric(
        vertical: 10.0, horizontal: 10.0),
    margin: const EdgeInsets.only(
        top: 20.0, left: 30.0, right: 30.0, bottom: 0.0),
    decoration: BoxDecoration(
      color: const Color(0xffBEF1FF),
      borderRadius: BorderRadius.circular(10.0),
      border: Border.all(
        width: 3,
        color: const Color(0xff142867),
      ),
    ),
    child: Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            Text(
              title,
              style: reminderTitle(),
            ),
            const Spacer(),
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.delete),
              iconSize: 30.0,
            ),
          ],
        ),
        const SizedBox(
          height: 8.0,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(
                  vertical: 8.0, horizontal: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    sub1,
                    style: reminderSubtitle(),
                  ),
                  Text(
                    sub2,
                    style: reminderSubtitle(),
                  ),
                ],
              ),
            ),
            const Spacer(),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 10.0),
              child: const Icon(
                Icons.hourglass_top,
                size: 35.0,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 10.0),
              child: Column(
                children: <Widget>[
                  Text(
                    'HH:MM:SS',
                    style: reminderSubtitle(),
                  ),
                  Text(
                    '00:00:00',
                    style: reminderCountdown(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    ),
  );
}

TextStyle messagePreviewTextStyle() {
  return const TextStyle(
    fontSize: 25.0,
    fontWeight: FontWeight.bold,
    color: Colors.black,
  );
}

TextStyle reminderTitle() {
  return const TextStyle(
    fontSize: 23.0,
    fontWeight: FontWeight.bold,
    color: Colors.black,
  );
}

TextStyle reminderSubtitle() {
  return const TextStyle(
    fontSize: 15.0,
    color: Colors.black,
  );
}

TextStyle reminderCountdown() {
  return const TextStyle(
    fontSize: 20.0,
    fontWeight: FontWeight.bold,
    color: Colors.black,
  );
}
