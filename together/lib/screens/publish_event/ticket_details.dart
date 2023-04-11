import 'package:flutter/material.dart';
import 'package:together/components/appbar.dart';

class TicketDetails extends StatefulWidget {
  const TicketDetails({Key? key}) : super(key: key);

  @override
  State<TicketDetails> createState() => _TicketDetailsState();
}

class _TicketDetailsState extends State<TicketDetails> {
  @override
  Widget build(BuildContext context) {
    //List was implemented
    List<Widget> fields = [
      Container(
        margin: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        padding: const EdgeInsets.symmetric(vertical: 20.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          border: Border.all(
            width: 1.0,
          ),
        ),
        child: Column(
          children: <Widget>[
            textField(Icons.local_activity, 'Status', 1),
            const SizedBox(
              height: 10.0,
            ),
            textField(Icons.local_atm, 'Price', 1),
          ],
        ),
      ),
    ];

    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: myAppBar(),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              margin: const EdgeInsets.symmetric(vertical: 20.0),
              width: width,
              child: Text(
                'Tell us about Ticket Prices...',
                textAlign: TextAlign.center,
                style: messagePreviewTextStyle(),
              ),
            ),
            Expanded(
              child: ListView(
                children: <Widget>[
                  Column(
                    children: fields,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10.0, horizontal: 50.0),
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          fields.add(
                            Container(
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 20.0, vertical: 10.0),
                              padding:
                                  const EdgeInsets.symmetric(vertical: 20.0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.0),
                                border: Border.all(
                                  width: 1.0,
                                ),
                              ),
                              child: Column(
                                children: <Widget>[
                                  textField(Icons.local_activity, 'Status', 1),
                                  const SizedBox(
                                    height: 10.0,
                                  ),
                                  textField(Icons.local_atm, 'Price', 1),
                                ],
                              ),
                            ),
                          );
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        primary: const Color(0xff142867),
                        padding: const EdgeInsets.symmetric(vertical: 20.0),
                      ),
                      child: const Text('Add field'),
                    ),
                  ),
                  const SizedBox(
                    height: 20.0,
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

Widget textField(IconData icon, String hintText, int maxLines) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 30.0),
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

TextStyle messagePreviewTextStyle() {
  return const TextStyle(
    fontSize: 22.0,
    fontWeight: FontWeight.bold,
    color: Color(0xff142867),
  );
}
