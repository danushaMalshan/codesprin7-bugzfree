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
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.only(
                    left: 10.0, top: 20.0, right: 10.0, bottom: 20.0),
                child: Text(
                  'Pending Reminders',
                  textAlign: TextAlign.center,
                  style: messagePreviewTextStyle(),
                ),
              ),
              Expanded(
                child: ListView(
                  children: <Widget>[
                    Container(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 15.0),
                      padding: const EdgeInsets.symmetric(
                          vertical: 15.0, horizontal: 10.0),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.0),
                        border: Border.all(width: 2),
                      ),
                      child: Column(
                        children: <Widget>[
                          ListTile(
                            title: Text(
                              'Bentota Beach Fiesta',
                              style: forEventName(),
                            ),
                            subtitle: Text(
                              'Will be reminded on Monday',
                              style: forEventSub(),
                            ),
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
                                pendingReminderIcons(const Icon(Icons.delete),
                                    'Remove from Pending Reminders'),
                                pendingReminderIcons(
                                    const Icon(Icons.add_circle),
                                    'Add to Reminders Now'),
                                pendingReminderIcons(
                                    const Icon(Icons.arrow_circle_right),
                                    'Go to Event Details'),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 15.0),
                      padding: const EdgeInsets.symmetric(
                          vertical: 15.0, horizontal: 10.0),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.0),
                        border: Border.all(width: 2),
                      ),
                      child: Column(
                        children: <Widget>[
                          ListTile(
                            title: Text(
                              'Bentota Beach Fiesta',
                              style: forEventName(),
                            ),
                            subtitle: Text(
                              'Will be reminded on Monday',
                              style: forEventSub(),
                            ),
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
                                pendingReminderIcons(const Icon(Icons.delete),
                                    'Remove from Pending Reminders'),
                                pendingReminderIcons(
                                    const Icon(Icons.add_circle),
                                    'Add to Reminders Now'),
                                pendingReminderIcons(
                                    const Icon(Icons.arrow_circle_right),
                                    'Go to Event Details'),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 15.0),
                      padding: const EdgeInsets.symmetric(
                          vertical: 15.0, horizontal: 10.0),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.0),
                        border: Border.all(width: 2),
                      ),
                      child: Column(
                        children: <Widget>[
                          ListTile(
                            title: Text(
                              'Bentota Beach Fiesta',
                              style: forEventName(),
                            ),
                            subtitle: Text(
                              'Will be reminded on Monday',
                              style: forEventSub(),
                            ),
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
                                pendingReminderIcons(const Icon(Icons.delete),
                                    'Remove from Pending Reminders'),
                                pendingReminderIcons(
                                    const Icon(Icons.add_circle),
                                    'Add to Reminders Now'),
                                pendingReminderIcons(
                                    const Icon(Icons.arrow_circle_right),
                                    'Go to Event Details'),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 15.0),
                      padding: const EdgeInsets.symmetric(
                          vertical: 15.0, horizontal: 10.0),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.0),
                        border: Border.all(width: 2),
                      ),
                      child: Column(
                        children: <Widget>[
                          ListTile(
                            title: Text(
                              'Bentota Beach Fiesta',
                              style: forEventName(),
                            ),
                            subtitle: Text(
                              'Will be reminded on Monday',
                              style: forEventSub(),
                            ),
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
                                pendingReminderIcons(const Icon(Icons.delete),
                                    'Remove from Pending Reminders'),
                                pendingReminderIcons(
                                    const Icon(Icons.add_circle),
                                    'Add to Reminders Now'),
                                pendingReminderIcons(
                                    const Icon(Icons.arrow_circle_right),
                                    'Go to Event Details'),
                              ],
                            ),
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
    fontSize: 20.0,
    fontWeight: FontWeight.bold,
    color: Colors.black,
  );
}

TextStyle forEventName() {
  return const TextStyle(
    fontSize: 27.0,
    // fontWeight: FontWeight.bold,
    color: Color(0xff142867),
  );
}

TextStyle forEventSub() {
  return const TextStyle(
    fontSize: 17.0,
    // fontWeight: FontWeight.bold,
    color: Color(0xff142867),
  );
}

Widget pendingReminderIcons(Icon remIcon, String remToolTip) {
  return IconButton(
    icon: remIcon,
    onPressed: () {},
    tooltip: remToolTip,
    iconSize: 45.0,
    // color: Color(0xff142867),
  );
}
