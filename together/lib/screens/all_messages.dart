import 'package:flutter/material.dart';
import 'package:together/components/bottom_navigation_bar.dart';
import '../components/appbar.dart';

class myAllMessages extends StatefulWidget {
  const myAllMessages({Key? key}) : super(key: key);

  @override
  State<myAllMessages> createState() => _myAllMessagesState();
}

class _myAllMessagesState extends State<myAllMessages> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myAppBar(),
      body: SafeArea(
        child: ListView(
          children: <Widget>[
            Container(
              margin: const EdgeInsets.symmetric(vertical: 20.0),
              child: Center(
                child: Text(
                  'All Messages',
                  style: homeTextStyle(),
                ),
              ),
            ),
            messagePreview('Jagath Rathnayake', '10/03/2023', '22:52'),
            messagePreview('Nimal Lansa', '05/03/2023', '22:45'),
          ],
        ),
      ),
    );
  }
}

TextStyle homeTextStyle() {
  return const TextStyle(
    fontSize: 30.0,
    fontWeight: FontWeight.bold,
    color: Color(0xff142867),
  );
}

TextStyle messagePreviewTextStyle() {
  return const TextStyle(
    fontSize: 25.0,
    fontWeight: FontWeight.bold,
    color: Color(0xff142867),
  );
}

Widget messagePreview(String organizerName, String date, String time) {
  return Container(
    margin: const EdgeInsets.symmetric(horizontal:20.0,vertical: 10.0),
    padding: const EdgeInsets.symmetric(vertical: 20.0),
    decoration: BoxDecoration(
      border: Border.all(
        width: 2.0,
        color: const Color(0xff142867),
      ),
      borderRadius: BorderRadius.circular(20.0),
    ),
    child: ListTile(
      leading: const Icon(
        Icons.person,
        size: 50,
        color: Color(0xff142867),
      ),
      title: Text(organizerName,style: messagePreviewTextStyle(),),
      subtitle: Text(date),
      trailing: Text(time),
    ),
  );
}
