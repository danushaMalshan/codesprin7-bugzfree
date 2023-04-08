import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:together/components/appbar.dart';
import 'dart:async';

import 'package:together/components/bottom_navigation_bar.dart';

class EventDetailsScreen extends StatefulWidget {
  @override
  State<EventDetailsScreen> createState() => _EventDetailsScreenState();
}

class _EventDetailsScreenState extends State<EventDetailsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int selectedIndex = 0;

  Completer<GoogleMapController> _controller = Completer();

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  static final CameraPosition _kLake = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(37.43296265331129, -122.08832357078792),
      tilt: 59.440717697143555,
      zoom: 19.151926040649414);
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
    _tabController.addListener(_onTabSelect);
  }

  void _onTabSelect() {
    setState(() {
      selectedIndex = _tabController.index;
      print(selectedIndex);
    });
  }

  @override
  void dispose() {
    _tabController.removeListener(_onTabSelect);
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: myAppBar(),
      body: SizedBox(
        width: width,
        height: height,
        child: SingleChildScrollView(
          child: Column(
            children: [
              EventBanner(height, width),
              EventName(),
              CustomTabBar(),
              EventButtons(),
              EventDescription(),
              EventPhotos(context),
              EventLocationInMap(width),
              TicketReservationsButton(width),
            ],
          ),
        ),
      ),
    );
  }

  Container TicketReservationsButton(double width) {
    return Container(
              height: 75,
              margin: EdgeInsets.only(bottom: 40),
              width: width - 150,
              child: ElevatedButton(
                onPressed: () {},
                child: Text(
                  'Ticket Reservations',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                      fontSize: 18),
                ),
                style: ElevatedButton.styleFrom(
                  primary: Color(0xFF142867),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),
            );
  }

  Column EventLocationInMap(double width) {
    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding:
                const EdgeInsets.only(left: 30, right: 30, top: 30, bottom: 15),
            child: Text(
              'Event  Location',
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        Container(
          clipBehavior: Clip.hardEdge,
          margin: EdgeInsets.only(top: 30, bottom: 40),
          height: 200,
          width: width,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
          child: GoogleMap(
            mapType: MapType.normal,
            initialCameraPosition: _kGooglePlex,
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
            },
          ),
        )
      ],
    );
  }

  Column EventPhotos(BuildContext context) {
    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding:
                const EdgeInsets.only(left: 30, right: 30, top: 30, bottom: 15),
            child: Text(
              'Event  Photos',
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: CarouselSlider(
            options: CarouselOptions(
              height: 150,
              aspectRatio: 16 / 9,
              viewportFraction: 0.7,
              initialPage: 0,
              enableInfiniteScroll: true,
              reverse: false,
              autoPlay: true,
              autoPlayInterval: Duration(seconds: 5),
              autoPlayAnimationDuration: Duration(milliseconds: 800),
              autoPlayCurve: Curves.fastOutSlowIn,
              enlargeCenterPage: true,
              enlargeFactor: 0.2,
              scrollDirection: Axis.horizontal,
            ),
            items: [
              SliderImage(context,
                  'assets/images/obi-pixel7propix-BMjyJMlhPqY-unsplash.jpg'),
              SliderImage(context,
                  'assets/images/james-barbosa-qOWjDs-77cM-unsplash.jpg'),
              SliderImage(context,
                  'assets/images/andre-mosele--tlIcpJuEVQ-unsplash.jpg'),
            ],
            // items: [
            //   'assets/images/obi-pixel7propix-BMjyJMlhPqY-unsplash.jpg',
            //   'assets/images/james-barbosa-qOWjDs-77cM-unsplash.jpg',
            //   'assets/images/andre-mosele--tlIcpJuEVQ-unsplash.jpg'
            // ].map((i) {
            //   return Builder(
            //     builder: (BuildContext context) {
            //       return Container(
            //         width: MediaQuery.of(context).size.width,
            //         margin: EdgeInsets.symmetric(horizontal: 3.0),
            //         decoration: BoxDecoration(
            //             borderRadius: BorderRadius.circular(20),
            //             image: DecorationImage(
            //                 image: AssetImage(i), fit: BoxFit.cover)),
            //       );
            //     },
            //   );
            // }).toList(),
          ),
        )
      ],
    );
  }

  Container SliderImage(BuildContext context, String img) {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.symmetric(horizontal: 3.0),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          image: DecorationImage(image: AssetImage(img), fit: BoxFit.cover)),
    );
  }

  Column EventDescription() {
    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
            child: Text(
              'Event  Description',
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 0),
            child: Text(
              'Bottom line? Ecommerce is big and getting bigger. And navigating the ever-changing ecommerce terrain is a big challenge for small businesses used to the brick-and-mortar paradigm. So many factors impact your success online: how familiar people are with your brand, how effectively your ',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.normal,
                  color: Colors.black.withOpacity(0.6)),
            ),
          ),
        ),
      ],
    );
  }

  Padding EventButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: SizedBox(
              height: 75,
              child: Padding(
                padding: const EdgeInsets.only(right: 10),
                child: ElevatedButton(
                  onPressed: () {},
                  child: Text(
                    'Add Reminder',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                        fontSize: 18),
                  ),
                  style: ElevatedButton.styleFrom(
                    primary: Color(0xFF142867),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: SizedBox(
              height: 70,
              child: Padding(
                padding: const EdgeInsets.only(left: 10),
                child: ElevatedButton(
                  onPressed: () {},
                  child: Text(
                    'Contact Organizer',
                    style: TextStyle(
                        color: Color(0xFF142867),
                        fontWeight: FontWeight.w500,
                        fontSize: 18),
                  ),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                        side: BorderSide(color: Color(0xFF142867), width: 2)),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Align EventName() {
    return Align(
        alignment: Alignment.centerLeft,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
          child: Text(
            'Bentota Beach Fiesta',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
        ));
  }

  Container CustomTabBar() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 30),
      height: 200,
      decoration: BoxDecoration(
          color: Colors.grey.withOpacity(0.5),
          borderRadius: BorderRadius.circular(30)),
      child: Column(
        children: [
          TabBar(
            indicator: BoxDecoration(
              color: Color(0xFF142867),
              // Set selected tab color here
            ),
            // labelStyle: TextStyle(color: Color(0xFF142867)),
            unselectedLabelColor: Color(0xFF142867),
            controller: _tabController,
            labelPadding: EdgeInsets.symmetric(vertical: 15),
            labelStyle: TextStyle(fontWeight: FontWeight.bold),
            unselectedLabelStyle: TextStyle(fontWeight: FontWeight.bold),
            tabs: [
              Tab(
                text: "Date",
                icon: Icon(Icons.calendar_month),
              ),
              Tab(text: "Time", icon: Icon(Icons.access_time)),
              Tab(
                text: "Location",
                icon: Icon(Icons.location_on_outlined),
              ),
              Tab(
                text: "Price",
                icon: Icon(Icons.price_change_outlined),
              ),
              Tab(text: "Duration", icon: Icon(Icons.av_timer_sharp)),
            ],
          ),
          Expanded(
            child: Container(
              color: Color(0xFF142867),
              child: TabBarView(
                controller: _tabController,
                children: [
                  CustomTabView("25 March 2023"),
                  CustomTabView("7.30 pm Onwards"),
                  CustomTabView("Bentota Beach Premises"),
                  CustomTabView("Standing - Rs. 2,000/="),
                  CustomTabView("All Night"),
                ],
              ),
            ),
          ),
        ],
      ),
      clipBehavior: Clip.hardEdge,
    );
  }

  Center CustomTabView(String text) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            Icons.bookmark,
            color: Colors.white,
            size: 27,
          ),
          SizedBox(
            width: 10,
          ),
          Text(
            text,
            style: TextStyle(
                color: Colors.white, fontSize: 30, fontWeight: FontWeight.w500),
          )
        ],
      ),
    );
  }

  Container EventBanner(double height, double width) {
    return Container(
      width: width,
      child: Image.asset(
        'assets/images/bentota_Event_Banner.jpg',
        fit: BoxFit.fitWidth,
      ),
    );
  }
}
