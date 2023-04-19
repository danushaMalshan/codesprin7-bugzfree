import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:together/components/appbar.dart';
import 'package:together/components/snack_bar.dart';
import 'package:together/models/event_model.dart';
import 'package:together/screens/proflle/pneding_event_details.dart';
import 'package:together/utils/colors.dart';

class PendingEventScreen extends StatefulWidget {
  const PendingEventScreen({Key? key}) : super(key: key);

  @override
  State<PendingEventScreen> createState() => _PendingEventScreenState();
}

class _PendingEventScreenState extends State<PendingEventScreen> {
  ShowSnackBar snackBar = ShowSnackBar();

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return SafeArea(
      child: Scaffold(
        appBar: myAppBar(context, false),
        body: SizedBox(
          width: width,
          height: height,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
            child: Column(
              children: [
                Expanded(
                  child: preferredList(width),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget preferredList(double width) {
    return SizedBox(
      width: width,
      child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('events')
              .limit(1000)
              .where('is_approve', isEqualTo: false)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              snackBar.showSnackaBar(context, snapshot.error.toString(), null);
              return Container();
            } else if (snapshot.connectionState == ConnectionState.waiting) {
              return const SpinKitWave(
                color: AppColor.primaryColor,
                size: 40,
              );
            } else {
              List<EventModel> events = (snapshot.data! as QuerySnapshot)
                  .docs
                  .map((doc) => EventModel.fromFirestore(doc))
                  .toList();

              if (events.isEmpty) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: Text(
                      'Events not added yet',
                      style: TextStyle(
                          color: AppColor.primaryColor,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                );
              } else {
                return ListView.builder(
                  scrollDirection: Axis.vertical,
                  itemCount: events.length,
                  itemBuilder: ((context, index) => GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      PendingEventDetailsScreen(
                                        event: events[index],
                                      )));
                        },
                        child: Stack(
                          children: [
                            Container(
                              margin: const EdgeInsets.all(8),
                              width: width - 50,
                              height: 200,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image:
                                        NetworkImage(events[index].coverImage??"https://firebasestorage.googleapis.com/v0/b/together-d1575.appspot.com/o/images%2Fevents%2Fdefault_cover.jpg?alt=media&token=4faf4063-a0f9-409a-90a7-be92d76375ee")),
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              child: Container(
                                margin: const EdgeInsets.all(8),
                                width: width - 55,
                                height: 100,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    stops: const [
                                      0.2,
                                      0.8,
                                    ],
                                    begin: Alignment.bottomCenter,
                                    end: Alignment.topCenter,
                                    colors: [
                                      AppColor.primaryColor.withOpacity(0.8),
                                      Colors.white.withOpacity(0.1),
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                            ),
                            Positioned.fill(
                                bottom: 10,
                                left: 30,
                                child: Align(
                                  alignment: Alignment.bottomLeft,
                                  child: Padding(
                                    padding: const EdgeInsets.only(bottom: 10),
                                    child: Text(
                                      events[index].name??'',
                                      style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ))
                          ],
                        ),
                      )),
                );
              }
            }
          }),
    );
  }
}

//AppBar goes here...

//TextStyles for home page goes here...

TextStyle homeTextStyle() {
  return const TextStyle(
    fontSize: 25.0,
    fontWeight: FontWeight.bold,
  );
}
