import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:together/components/appbar.dart';
import 'package:together/components/bottom_navigation_bar.dart';
import 'package:together/components/snack_bar.dart';
import 'package:together/models/event_model.dart';
import 'package:together/screens/event_details.dart';
import 'package:together/utils/colors.dart';

class PendingEventScreen extends StatefulWidget {
  const PendingEventScreen({Key? key}) : super(key: key);

  @override
  State<PendingEventScreen> createState() => _PendingEventScreenState();
}

class _PendingEventScreenState extends State<PendingEventScreen> {
  List trending = [
    ['Music', 'assets/images/james-barbosa-qOWjDs-77cM-unsplash.jpg'],
    ['Politics', 'assets/images/Politics.jpg'],
  ];

  List you_may_like = [
    [
      'Volunteering',
      'assets/images/Happy volunteer looking at donation box on a sunny day-1.jpeg'
    ],
    ['Seasonal Special', 'assets/images/NewYear.jpg'],
  ];

  List preferred = [
    ['Education', 'assets/images/Education Cat.jpg'],
    ['Dancing', 'assets/images/Dancing.jpg'],
  ];

  ShowSnackBar snackBar = ShowSnackBar();

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: myAppBar(context, false),
      body: SizedBox(
        width: width,
        height: height,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
          child: Column(
            children: [
              Expanded(
                child: PreferredList(width),
              ),
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Container(
                      height: 60,
                      padding: EdgeInsets.only(right: 10),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: AppColor.primaryColor,
                            shape: RoundedRectangleBorder(
                              side: BorderSide(
                                  width: 2, color: AppColor.primaryColor),
                              borderRadius: BorderRadius.circular(10),
                            )),
                        onPressed: () {},
                        child: Text(
                          'Add Event to Review',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(
                      padding: EdgeInsets.only(left: 10),
                      height: 60,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: AppColor.primaryColor,
                            shape: RoundedRectangleBorder(
                              side: BorderSide(
                                  width: 2, color: AppColor.primaryColor),
                              borderRadius: BorderRadius.circular(10),
                            )),
                        onPressed: () {},
                        child: Text(
                          'Add Event to Review',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget PreferredList(double width) {
    return Container(
      width: width,
      height: (preferred.length) * 216,
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
              return SpinKitCircle(
                color: AppColor.primaryColor,
                size: 30,
              );
            } else {
              List<EventModel> events = (snapshot.data! as QuerySnapshot)
                  .docs
                  .map((doc) => EventModel.fromFirestore(doc))
                  .toList();
              if (events.length == 0) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
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
                                  builder: (context) => EventDetailsScreen(
                                        eventName: events[index].name,
                                        description: events[index].description,
                                        organizerId: events[index].organizer_id,
                                        startDate: events[index].start_date,
                                        endDate: events[index].end_date,
                                        latitude: events[index].latitude,
                                        longitude: events[index].longitude,
                                        images: events[index].images,
                                        category: events[index].category,
                                        coverImage: events[index].cover_image,
                                        location: events[index].location,
                                        tickets: events[index].tickets,
                                      )));
                        },
                        child: Stack(
                          children: [
                            Container(
                              margin: EdgeInsets.all(8),
                              width: width - 50,
                              height: 200,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: NetworkImage(
                                        '${events[index].cover_image}')),
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              child: Container(
                                margin: EdgeInsets.all(8),
                                width: width - 55,
                                height: 100,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    stops: [
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
                                      '${events[index].name}',
                                      style: TextStyle(
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

  Column YouMayLikeList(double width) {
    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.only(top: 20, left: 0),
            child: Text(
              'You may Like',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        Container(
          width: width,
          height: 140,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: you_may_like.length,
            itemBuilder: ((context, index) => Stack(
                  children: [
                    Container(
                      margin: EdgeInsets.all(8),
                      width: 200,
                      height: 140,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: AssetImage(you_may_like[index][1]),
                          )),
                    ),
                    Positioned(
                      bottom: 0,
                      child: Container(
                        margin: EdgeInsets.all(8),
                        width: 200,
                        height: 100,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            stops: [
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
                              you_may_like[index][0],
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ))
                  ],
                )),
          ),
        ),
      ],
    );
  }

  Column TrendingList(double width) {
    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.only(top: 20, left: 0),
            child: Text(
              'Trending',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        Container(
          width: width,
          height: 180,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: trending.length,
            itemBuilder: ((context, index) => Stack(
                  children: [
                    Container(
                      margin: EdgeInsets.all(8),
                      width: 230,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: AssetImage(trending[index][1]),
                          )),
                    ),
                    Positioned(
                      bottom: 0,
                      child: Container(
                        margin: EdgeInsets.all(8),
                        width: 230,
                        height: 100,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            stops: [
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
                              trending[index][0],
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ))
                  ],
                )),
          ),
        ),
      ],
    );
  }

  TextField SearchBar() {
    return TextField(
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide(color: AppColor.primaryColor, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide(color: AppColor.primaryColor, width: 1)),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide(color: AppColor.primaryColor, width: 1)),
        fillColor: Colors.white.withOpacity(0.7),
        filled: true,
        contentPadding: EdgeInsets.only(left: 20, top: 15, bottom: 15),
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
