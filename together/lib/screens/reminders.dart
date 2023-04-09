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
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: myAppBar(),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Center(
              child: Container(
                margin: const EdgeInsets.only(
                    left: 10.0, top: 20.0, right: 10.0, bottom: 0.0),
                height: 70.0,
                child: Text(
                  'Reminders',
                  style: messagePreviewTextStyle(),
                ),
              ),
            ),
            Container(
              height: height - 208,
              child: ListView(
                children: [
                  Container(
                    margin: const EdgeInsets.only(
                        left: 20.0, top: 0.0, right: 20.0, bottom: 10.0),
                    decoration: BoxDecoration(
                      border: Border.all(width: 1),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Column(
                      children: <Widget>[
                        ListTile(
                          title: Text('Bentota Beach Fiesta'),
                          trailing: Icon(
                            Icons.delete,
                            color: Color(0xff142867),
                          ),
                        ),
                        Row(
                          children: <Widget>[
                            Container(
                              child: Column(
                                children: <Widget>[
                                  Text('Date: '),
                                  Text('Time: '),
                                ],
                              ),
                            ),

                          ],
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
