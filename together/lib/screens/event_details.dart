import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:together/components/appbar.dart';
import 'dart:async';

import 'package:together/components/bottom_navigation_bar.dart';
import 'package:together/utils/colors.dart';

class EventDetailsScreen extends StatefulWidget {
  EventDetailsScreen(
      {Key? key,
      required this.eventName,
      required this.description,
      required this.organizerId,
      required this.startDate,
      required this.endDate,
      required this.latitude,
      required this.longitude,
      required this.images,
      required this.category,
      required this.coverImage,
      required this.location,
      required this.tickets})
      : super(key: key);
  @override
  State<EventDetailsScreen> createState() => _EventDetailsScreenState();
  String eventName;
  String description;
  String organizerId;
  DateTime startDate;
  DateTime endDate;
  double latitude;
  double longitude;
  List<dynamic> images;
  int category;
  String coverImage;
  String location;
  List<dynamic> tickets;
}

class _EventDetailsScreenState extends State<EventDetailsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int selectedIndex = 0;
  String location = '';
  Completer<GoogleMapController> _controller = Completer();
  String? duration;
  CameraPosition? _kGooglePlex;
  Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
    _tabController.addListener(_onTabSelect);
    Duration duration = widget.endDate.difference(widget.startDate);
    if (duration.inDays > 0) {
      this.duration =
          "${duration.inDays} days, ${duration.inHours.remainder(24)}:${duration.inMinutes.remainder(60)}:${duration.inSeconds.remainder(60)}";
    } else if (duration.inHours > 0) {
      this.duration =
          "${duration.inHours}:${duration.inMinutes.remainder(60)}:${duration.inSeconds.remainder(60)}";
    }
    _kGooglePlex = CameraPosition(
      target: LatLng(widget.latitude, widget.longitude),
      zoom: 14.4746,
    );
    _markerAdd();
  }

  void _markerAdd() {
    setState(() {
      _markers.add(
        Marker(
          markerId: MarkerId('${widget.eventName}'),
          position: LatLng(widget.latitude, widget.longitude),
          infoWindow: InfoWindow(
            title: location,
          ),
        ),
      );
    });
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

  String formatDate() {
    DateTime date = DateTime.parse('${widget.startDate}');
    String formattedDate = DateFormat('d MMMM y').format(date);
    return formattedDate;
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: myAppBar(context, true),
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
              color: Colors.white, fontWeight: FontWeight.w500, fontSize: 18),
        ),
        style: ElevatedButton.styleFrom(
          primary: AppColor.primaryColor,
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
            markers: _markers,
            initialCameraPosition: _kGooglePlex!,
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
          child: CarouselSlider.builder(
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
            itemBuilder: ((context, index, realIndex) {
              return SliderImage(context, widget.images[index]);
            }),
            itemCount: widget.images.length,
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
          image: DecorationImage(image: NetworkImage(img), fit: BoxFit.cover)),
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
              widget.description,
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
                    primary: AppColor.primaryColor,
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
                        color: AppColor.primaryColor,
                        fontWeight: FontWeight.w500,
                        fontSize: 18),
                  ),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                        side:
                            BorderSide(color: AppColor.primaryColor, width: 2)),
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
            widget.eventName,
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
              color: AppColor.primaryColor,
              // Set selected tab color here
            ),
            // labelStyle: TextStyle(color: AppColor.primaryColor),
            unselectedLabelColor: AppColor.primaryColor,
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
              color: AppColor.primaryColor,
              child: TabBarView(
                controller: _tabController,
                children: [
                  CustomTabView(formatDate()),
                  CustomTabView(
                      "${DateFormat('h:mm a').format(widget.startDate)} Onwards"),
                  CustomTabView(widget.location),
                  CustomTabView(
                      "${widget.tickets[0]['name']} - Rs. ${widget.tickets[0]['price']}/="),
                  CustomTabView(this.duration ?? ''),
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
      height: 200,
      child: Image.network(
        widget.coverImage,
        fit: BoxFit.cover,
      ),
    );
  }
}
