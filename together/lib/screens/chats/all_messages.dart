import 'package:flutter/material.dart';

import 'package:together/utils/colors.dart';
import '../../components/appbar.dart';

class MyAllMessages extends StatefulWidget {
  const MyAllMessages({Key? key}) : super(key: key);

  @override
  State<MyAllMessages> createState() => _MyAllMessagesState();
}

class _MyAllMessagesState extends State<MyAllMessages> {
  bool undeDevelopment = true;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: myAppBar(context, false),
        body: undeDevelopment
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    Image.asset(
                      'assets/images/repair.png',
                      height: 70,
                      width: 70,
                    ),
                    const Padding(
                      padding: EdgeInsets.only(
                        left: 20,
                        right: 20,
                        top: 20.0,
                      ),
                      child: Text(
                        'Sorry! This Screen is under development and will be available in future updates',
                        style: TextStyle(fontSize: 18),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              )
            : SafeArea(
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
      ),
    );
  }
}

TextStyle homeTextStyle() {
  return const TextStyle(
    fontSize: 30.0,
    fontWeight: FontWeight.bold,
    color: AppColor.primaryColor,
  );
}

TextStyle messagePreviewTextStyle() {
  return const TextStyle(
    fontSize: 25.0,
    fontWeight: FontWeight.bold,
    color: AppColor.primaryColor,
  );
}

Widget messagePreview(String organizerName, String date, String time) {
  return Container(
    margin: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
    padding: const EdgeInsets.symmetric(vertical: 20.0),
    decoration: BoxDecoration(
      border: Border.all(
        width: 2.0,
        color: AppColor.primaryColor,
      ),
      borderRadius: BorderRadius.circular(20.0),
    ),
    child: ListTile(
      leading: const Icon(
        Icons.person,
        size: 50,
        color: AppColor.primaryColor,
      ),
      title: Text(
        organizerName,
        style: messagePreviewTextStyle(),
      ),
      subtitle: Text(date),
      trailing: Text(time),
    ),
  );
}
