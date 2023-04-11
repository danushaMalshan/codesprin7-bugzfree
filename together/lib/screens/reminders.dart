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

    // return Scaffold(
    //   appBar: myAppBar(),
    //   body: SafeArea(
    //     child: Column(
    //       children: <Widget>[
    //         Center(
    //           child: Container(
    //             margin: const EdgeInsets.only(
    //                 left: 10.0, top: 20.0, right: 10.0, bottom: 0.0),
    //             height: 70.0,
    //             child: Text(
    //               'Reminders',
    //               style: messagePreviewTextStyle(),
    //             ),
    //           ),
    //         ),
    //         Container(
    //           height: height - 208,
    //           child: ListView(
    //             children: [
    //               Container(
    //                 margin: const EdgeInsets.only(
    //                     left: 20.0, top: 0.0, right: 20.0, bottom: 10.0),
    //                 decoration: BoxDecoration(
    //                   border: Border.all(width: 1),
    //                   borderRadius: BorderRadius.circular(10.0),
    //                 ),
    //                 child: Column(
    //                   children: <Widget>[
    //                     ListTile(
    //                       title: Text('Bentota Beach Fiesta'),
    //                       trailing: Icon(
    //                         Icons.delete,
    //                         color: Color(0xff142867),
    //                       ),
    //                     ),
    //                     Row(
    //                       children: <Widget>[
    //                         Container(
    //                           child: Column(
    //                             children: <Widget>[
    //                               Text('Date: '),
    //                               Text('Time: '),
    //                             ],
    //                           ),
    //                         ),

    //                       ],
    //                     ),
    //                   ],
    //                 ),
    //               ),
    //             ],
    //           ),
    //         ),
    //       ],
    //     ),
    //   ),
    // );

    return Scaffold(

        appBar: myAppBar(),
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Text(
                  'Reminders',
                  style: messagePreviewTextStyle(),
                ),

              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: Column(
                      children: [
                        CustomReminderTile(width),
                        CustomReminderTile(width),
                        CustomReminderTile(width),
                        CustomReminderTile(width),
                        CustomReminderTile(width),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ));
  }

  Container CustomReminderTile(double width) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      width: width,
      height: 130,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Color(0xFF142867).withOpacity(0.1),
          border: Border.all(width: 2, color: Color(0xFF142867))),
      child: Column(
        children: [
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.only(left: 20, top: 5, right: 10),
              child: Row(
                children: [
                  Text(
                    'Bentota Beach Fiesta',
                    style: TextStyle(fontSize: 20, color: Color(0xFF142867)),
                  ),
                  Spacer(),
                  Icon(Icons.delete)
                ],
              ),
            ),

          ),
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.only(left: 20, top: 10, right: 20),
              child: Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Date : March 25'),
                        Text('Time :8.30 pm onward'),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 5),
                          child: Text(
                            'HH : MM : SS',
                            style: TextStyle(fontSize: 12),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Icon(
                              Icons.av_timer_outlined,
                              size: 35,
                              color: Color(0xFF142867),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              '00:00:00',
                              style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF142867)),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),

                ],
              ),
            ),
          )
        ],
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
    fontSize: 20.0,
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
