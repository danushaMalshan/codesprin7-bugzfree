import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'package:together/components/appbar.dart';
import 'package:together/components/show_dialog.dart';

import 'package:together/components/snack_bar.dart';
import 'package:together/models/event_model.dart';
import 'package:together/screens/home/event_details.dart';
import 'package:together/utils/colors.dart';

class CategoryEventsScreen extends StatefulWidget {
  const CategoryEventsScreen(
      {Key? key,
      required this.id,
      required this.name,
      required this.image,
      required this.value})
      : super(key: key);
  final int id;
  final String image;
  final String name;
  final int value;
  @override
  State<CategoryEventsScreen> createState() => _CategoryEventsScreenState();
}

class _CategoryEventsScreenState extends State<CategoryEventsScreen> {
  ShowSnackBar snackBar = ShowSnackBar();

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    DateTime today = DateTime.now();
    return SafeArea(
      child: Scaffold(
          appBar: myAppBar(context, true),
          body: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('events')
                .where('category', isEqualTo: widget.id)
                .where('start_date', isGreaterThan: today)
                .orderBy('start_date', descending: true)
                .limit(50)
                .snapshots(),
            builder: ((context, snapshot) {
              if (snapshot.hasError) {
                snackBar.showSnackaBar(
                    context, snapshot.error.toString(), null);
                return Container();
              } else if (snapshot.connectionState == ConnectionState.waiting) {
                return const SpinKitWave(
                  color: AppColor.primaryColor,
                  size: 30,
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
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 30),
                        child: Text(
                          'Events related to this category have not been added yet',
                          style: TextStyle(
                              color: AppColor.primaryColor,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  );
                } else {
                  return Stack(children: [
                    bannerImage(width, height),
                    // Positioned.fill(
                    //   bottom: 20,
                    //   child: Align(
                    //     alignment: Alignment.bottomCenter,
                    //     child: Padding(
                    //       padding: const EdgeInsets.only(bottom: 40),
                    //       child: Text(
                    //         widget.name,
                    //         style: const TextStyle(
                    //             color: Colors.white,
                    //             fontWeight: FontWeight.bold,
                    //             fontSize: 50),
                    //         textAlign: TextAlign.center,
                    //       ),
                    //     ),
                    //   ),
                    // ),
                    Positioned(
                      bottom: 0,
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          width: width,
                          height: height * 0.62,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(40),
                              topRight: Radius.circular(40),
                            ),
                          ),
                          child: SizedBox(
                            width: width,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 30, vertical: 30),
                              child: Column(
                                children: [
                                  searchBar(),
                                  Expanded(
                                      child: eventsListView(width, events)),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ]);
                }
              }
            }),
          )),
    );
  }

  SizedBox eventsListView(double width, List<EventModel> events) {
    return SizedBox(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.vertical,
        itemCount: events.length,
        itemBuilder: ((context, index) => GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => EventDetailsScreen(
                              event: events[index],
                            )));
              },
              child: Stack(
                children: [
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    width: width - 60,
                    height: 150,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: NetworkImage(events[index].coverImage ??
                              'https://firebasestorage.googleapis.com/v0/b/together-d1575.appspot.com/o/images%2Fevents%2Fdefault_cover.jpg?alt=media&token=4faf4063-a0f9-409a-90a7-be92d76375ee'),
                        )),
                  ),
                  Positioned(
                    bottom: 0,
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      width: width - 60,
                      height: 80,
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
                            events[index].name ?? '',
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
      ),
    );
  }

  Positioned bannerImage(double width, double height) {
    return Positioned(
      top: 0,
      child: Container(
        width: width,
        height: height * 0.25,
        decoration: BoxDecoration(
          image: DecorationImage(
              colorFilter: ColorFilter.mode(
                  Colors.black.withOpacity(0.5), BlendMode.darken),
              image: NetworkImage(widget.image),
              fit: BoxFit.cover),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 30),
            child: Text(
              widget.name,
              style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 50),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }

  Widget searchBar() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 40),
      child: TextField(
        readOnly: true,
        onTap: () {
          customDevelopmentShowDialog(context,
              'Sorry! This feature is under development and will be available in future updates');
        },
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide:
                const BorderSide(color: AppColor.primaryColor, width: 1),
          ),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide:
                  const BorderSide(color: AppColor.primaryColor, width: 1)),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide:
                  const BorderSide(color: AppColor.primaryColor, width: 1)),
          fillColor: Colors.white.withOpacity(0.7),
          filled: true,
          contentPadding: const EdgeInsets.only(left: 20, top: 15, bottom: 15),
          suffixIcon: Icon(
            Icons.tune,
            color: AppColor.primaryColor.withOpacity(0.4),
            size: 30,
          ),
          prefixIcon: Icon(
            Icons.search,
            color: AppColor.primaryColor.withOpacity(0.4),
            size: 30,
          ),
          hintText: 'Search any Event',
          hintStyle: TextStyle(
            fontSize: 20,
            color: AppColor.primaryColor.withOpacity(0.4),
          ),
        ),
        cursorColor: Colors.black,
      ),
    );
  }
}
