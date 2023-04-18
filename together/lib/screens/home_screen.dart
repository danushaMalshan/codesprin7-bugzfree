import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:together/components/appbar.dart';
import 'package:together/components/bottom_navigation_bar.dart';
import 'package:together/components/snack_bar.dart';
import 'package:together/models/category_model.dart';
import 'package:together/models/event_model.dart';
import 'package:together/screens/category_events.dart';
import 'package:together/screens/event_details.dart';
import 'package:together/utils/colors.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  User? user = FirebaseAuth.instance.currentUser;
  ShowSnackBar snackBar = ShowSnackBar();
  late String _randomId;
  List<int> randomNumbers = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  void addRandomNumbers() {
    for (int i = 0; i < 5; i++) {
      final random = Random();

      int randomNumber = random.nextInt(15);
      randomNumbers.add(randomNumber);
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    addRandomNumbers();
    return Scaffold(
      appBar: myAppBar(context, false),
      body: SizedBox(
        width: width,
        height: height,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SearchBar(),
                TrendingList(width),
                YouMayLikeList(width),
                PreferredList(width)
              ],
            ),
          ),
        ),
      ),
    );
  }

  Column PreferredList(double width) {
    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.only(top: 20, left: 0),
            child: Text(
              'Preferred',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        Container(
          width: width,
          child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .doc(user?.uid)
                  .snapshots()
                  .asyncMap((userDocument) async {
                List<int> userCategories =
                    userDocument.data()?['categories'].cast<int>();
                print(userCategories);
                QuerySnapshot eventDocuments = await FirebaseFirestore.instance
                    .collection('events')
                    .where('category', whereIn: userCategories)
                    .limit(1000)
                    .get();
                return eventDocuments;
              }),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  snackBar.showSnackaBar(
                      context, snapshot.error.toString(), null);
                  return Container();
                } else if (snapshot.connectionState ==
                    ConnectionState.waiting) {
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
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: events.length,
                      itemBuilder: ((context, index) => GestureDetector(
                            onTap: () {
                              var item = events[index];
                              DocumentReference docRef = FirebaseFirestore
                                  .instance
                                  .collection('categories')
                                  .doc('${events[index].category}');
                              docRef.update({'value': FieldValue.increment(1)});
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => EventDetailsScreen(
                                            tickets: item.tickets,
                                            category: item.category,
                                            coverImage: item.cover_image,
                                            description: item.description,
                                            endDate: item.end_date,
                                            eventName: item.name,
                                            images: item.images,
                                            latitude: item.latitude,
                                            location: item.location,
                                            longitude: item.longitude,
                                            organizerId: item.organizer_id,
                                            startDate: item.start_date,
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
                                          AppColor.primaryColor
                                              .withOpacity(0.8),
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
                                        padding:
                                            const EdgeInsets.only(bottom: 10),
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
        ),
      ],
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
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('categories')
                  .where('id', whereIn: randomNumbers)
                  .limit(5)
                  .snapshots(),
              builder: ((context, snapshot) {
                if (snapshot.hasError) {
                  snackBar.showSnackaBar(
                      context, snapshot.error.toString(), null);
                  return Container();
                } else if (snapshot.connectionState ==
                    ConnectionState.waiting) {
                  return SpinKitCircle(
                    color: AppColor.primaryColor,
                    size: 30,
                  );
                } else {
                  List<CategoryModel> categories =
                      (snapshot.data! as QuerySnapshot)
                          .docs
                          .map((doc) => CategoryModel.fromFirestore(doc))
                          .toList();
                  return ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: categories.length,
                    itemBuilder: ((context, index) => GestureDetector(
                          onTap: () {
                            DocumentReference docRef = FirebaseFirestore
                                .instance
                                .collection('categories')
                                .doc('${categories[index].id}');
                            docRef.update({'value': FieldValue.increment(1)});
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        CategoryEventsScreen()));
                          },
                          child: Stack(
                            children: [
                              Container(
                                margin: EdgeInsets.all(8),
                                width: 200,
                                height: 140,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    image: DecorationImage(
                                      fit: BoxFit.cover,
                                      image:
                                          NetworkImage(categories[index].image),
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
                                      padding:
                                          const EdgeInsets.only(bottom: 10),
                                      child: Text(
                                        categories[index].name,
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
              }),
            )),
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
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('categories')
                  .orderBy('value', descending: true)
                  .limit(5)
                  .snapshots(),
              builder: ((context, snapshot) {
                if (snapshot.hasError) {
                  snackBar.showSnackaBar(
                      context, snapshot.error.toString(), null);
                  return Container();
                } else if (snapshot.connectionState ==
                    ConnectionState.waiting) {
                  return SpinKitCircle(
                    color: AppColor.primaryColor,
                    size: 30,
                  );
                } else {
                  List<CategoryModel> categories =
                      (snapshot.data! as QuerySnapshot)
                          .docs
                          .map((doc) => CategoryModel.fromFirestore(doc))
                          .toList();

                  return ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: categories.length,
                    itemBuilder: ((context, index) => GestureDetector(
                          onTap: () {
                            DocumentReference docRef = FirebaseFirestore
                                .instance
                                .collection('categories')
                                .doc('${categories[index].id}');
                            docRef.update({'value': FieldValue.increment(1)});
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        CategoryEventsScreen()));
                          },
                          child: Stack(
                            children: [
                              Container(
                                margin: EdgeInsets.all(8),
                                width: 230,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    image: DecorationImage(
                                      fit: BoxFit.cover,
                                      image: NetworkImage(
                                        categories[index].image,
                                      ),
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
                                      padding:
                                          const EdgeInsets.only(bottom: 10),
                                      child: Text(
                                        categories[index].name,
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
              }),
            )),
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
