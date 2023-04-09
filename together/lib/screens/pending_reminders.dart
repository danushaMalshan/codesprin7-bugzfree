import 'package:flutter/material.dart';
import 'package:together/components/appbar.dart';

class PendingReminders extends StatefulWidget {
  const PendingReminders({Key? key}) : super(key: key);

  @override
  State<PendingReminders> createState() => _PendingRemindersState();
}

class _PendingRemindersState extends State<PendingReminders> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myAppBar(),
      body: SafeArea(
        child: SizedBox(
          height: double.infinity,
          width: double.infinity,
          child: ListView(
            children: <Widget>[
              Container(
                margin: const EdgeInsets.symmetric(
                    vertical: 20.0, horizontal: 10.0),
                child: Text(
                  'Pending Reminders',
                  textAlign: TextAlign.center,
                  style: messagePreviewTextStyle(),
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20.0),
                padding: const EdgeInsets.symmetric(
                    vertical: 20.0, horizontal: 10.0),
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.0),
                  border: Border.all(width: 2),
                ),
                child: Column(
                  children: <Widget>[
                    ListTile(
                      title: Text('Bentota Beach Fiesta', style: forEventName(),),
                      subtitle: Text('Will be reminded on Monday'),
                    ),
                    const Divider(
                      color: Color(0xff142867),
                      thickness: 2.0,
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 5.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[

                          Icon(
                            Icons.add_circle,
                            size: 60.0,
                          ),
                          Icon(
                            Icons.arrow_circle_right_rounded,
                            size: 60.0,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

TextStyle messagePreviewTextStyle() {
  return const TextStyle(
    fontSize: 25.0,
    fontWeight: FontWeight.bold,
    color: Colors.black,
  );
}

TextStyle forEventName() {
  return const TextStyle(
    fontSize: 25.0,
    // fontWeight: FontWeight.bold,
    color: Colors.black,
  );
}