import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';

import 'package:together/components/appbar.dart';
import 'package:together/components/show_dialog.dart';
import 'package:together/components/snack_bar.dart';
import 'dart:async';

import 'package:together/models/event_model.dart';
import 'package:together/utils/colors.dart';
import 'package:url_launcher/url_launcher.dart';

class EventDetailsScreen extends StatefulWidget {
  const EventDetailsScreen({
    Key? key,
    required this.event,
  }) : super(key: key);
  @override
  State<EventDetailsScreen> createState() => _EventDetailsScreenState();
  final EventModel event;
}

class _EventDetailsScreenState extends State<EventDetailsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int selectedIndex = 0;
  String location = '';
  final Completer<GoogleMapController> _controller = Completer();
  String? duration;
  CameraPosition? _kGooglePlex;
  final Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
    _tabController.addListener(_onTabSelect);
    Duration duration = widget.event.endDate.difference(widget.event.startDate);
    String daysText = duration.inDays > 1 ? 'Days' : 'Day';
    String hourText = duration.inHours > 1 ? 'Hours' : 'Hour';
    if (duration.inDays > 0) {
      this.duration =
          "${duration.inDays} $daysText, ${duration.inHours.remainder(24)} $hourText";
    } else if (duration.inHours > 0) {
      this.duration = "${duration.inHours} $hourText";
    }
    _kGooglePlex = CameraPosition(
      target: LatLng(widget.event.latitude, widget.event.longitude),
      zoom: 14.4746,
    );
    _markerAdd();
  }

  Future share() async {
    Share.share(
        'Hey, I found a new Event. Check this out! \n\n${widget.event.name} \n\n ${widget.event.description} \n\n Ticket : ${widget.event.tickets?[0]['name']} - Rs. ${widget.event.tickets?[0]['price']}/= \n\n Location : ${widget.event.location}');
  }

  void _markerAdd() {
    setState(() {
      _markers.add(
        Marker(
          markerId: MarkerId(widget.event.name ?? ''),
          position: LatLng(widget.event.latitude, widget.event.longitude),
          infoWindow: InfoWindow(
            title: location,
          ),
        ),
      );
    });
  }

  Future<void> _launchUrl() async {
    final Uri url = Uri.parse(widget.event.ticketReservationLink ?? 'sss');
    try {
      await launchUrl(url);
    } catch (e) {
      ShowSnackBar snackBar = ShowSnackBar();
      snackBar.showSnackaBar(
          context, 'Could not launch because of invalid url $url', null);
    }
  }

  void _onTabSelect() {
    setState(() {
      selectedIndex = _tabController.index;
    });
  }

  @override
  void dispose() {
    _tabController.removeListener(_onTabSelect);
    _tabController.dispose();
    super.dispose();
  }

  String formatDate() {
    DateTime date = DateTime.parse('${widget.event.startDate}');
    String formattedDate = DateFormat('d MMMM y').format(date);
    return formattedDate;
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        appBar: myAppBar(context, true),
        body: SizedBox(
          width: width,
          height: height,
          child: SingleChildScrollView(
            child: Column(
              children: [
                eventBanner(height, width),
                eventName(),
                customTabBar(),
                eventButtons(),
                eventDescription(),
                (widget.event.images == null ||
                        widget.event.images?.length == 0)
                    ? Container()
                    : eventPhotos(context),
                eventLocationInMap(width),
                ticketReservationsButton(width),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget ticketReservationsButton(double width) {
    return SizedBox(
      width: width,
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Container(
              height: 60,
              margin: const EdgeInsets.only(bottom: 40, left: 10, right: 10),
              width: width,
              child: ElevatedButton(
                onPressed: widget.event.ticketReservationLink != null
                    ? () {
                        _launchUrl();
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  primary: AppColor.primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                child: const Text(
                  'Ticket Reservations',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              height: 60,
              margin: const EdgeInsets.only(bottom: 40, right: 10),
              width: width,
              child: ElevatedButton(
                onPressed: () {
                  share();
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                    side: const BorderSide(
                        width: 2, color: AppColor.primaryColor),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text(
                      'Share',
                      style: TextStyle(
                          color: AppColor.primaryColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    FaIcon(
                      FontAwesomeIcons.solidShareFromSquare,
                      color: AppColor.primaryColor,
                      size: 30,
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Column eventLocationInMap(double width) {
    return Column(
      children: [
        const Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: EdgeInsets.only(left: 30, right: 30, top: 30, bottom: 15),
            child: Text(
              'Event  Location',
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        Container(
          clipBehavior: Clip.hardEdge,
          margin: const EdgeInsets.only(top: 30, bottom: 40),
          height: 300,
          width: width,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
          child: GoogleMap(
            gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>[
              Factory<OneSequenceGestureRecognizer>(
                () => EagerGestureRecognizer(),
              ),
            ].toSet(),
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

  Column eventPhotos(BuildContext context) {
    return Column(
      children: [
        const Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: EdgeInsets.only(left: 30, right: 30, top: 30, bottom: 15),
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
              autoPlayInterval: const Duration(seconds: 5),
              autoPlayAnimationDuration: const Duration(milliseconds: 800),
              autoPlayCurve: Curves.fastOutSlowIn,
              enlargeCenterPage: true,
              enlargeFactor: 0.2,
              scrollDirection: Axis.horizontal,
            ),
            itemBuilder: ((context, index, realIndex) {
              return sliderImage(context, widget.event.images?[index]);
            }),
            itemCount: widget.event.images?.length ?? 0,
          ),
        )
      ],
    );
  }

  Container sliderImage(BuildContext context, String img) {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.symmetric(horizontal: 3.0),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          image: DecorationImage(image: NetworkImage(img), fit: BoxFit.cover)),
    );
  }

  Column eventDescription() {
    return Column(
      children: [
        const Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
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
              widget.event.description ?? "",
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

  Padding eventButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: SizedBox(
              height: 60,
              child: Padding(
                padding: const EdgeInsets.only(right: 10),
                child: ElevatedButton(
                  onPressed: () {
                    customDevelopmentShowDialog(context,
                        'Sorry! This feature is under development and will be available in future updates');
                  },
                  style: ElevatedButton.styleFrom(
                    primary: AppColor.primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  child: const Text(
                    'Add Reminder',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: SizedBox(
              height: 60,
              child: Padding(
                padding: const EdgeInsets.only(left: 10),
                child: ElevatedButton(
                  onPressed: () {
                    customDevelopmentShowDialog(context,
                        'Sorry! This feature is under development and will be available in future updates');
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                        side: const BorderSide(
                            color: AppColor.primaryColor, width: 2)),
                  ),
                  child: const Text(
                    'Contact Organizer',
                    style: TextStyle(
                        color: AppColor.primaryColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 16),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Align eventName() {
    return Align(
        alignment: Alignment.centerLeft,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
          child: Text(
            widget.event.name ?? '',
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
        ));
  }

  Container customTabBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 30),
      height: 200,
      decoration: BoxDecoration(
          color: Colors.grey.withOpacity(0.5),
          borderRadius: BorderRadius.circular(30)),
      clipBehavior: Clip.hardEdge,
      child: Column(
        children: [
          TabBar(
            indicator: const BoxDecoration(
              color: AppColor.primaryColor,
              // Set selected tab color here
            ),
            // labelStyle: TextStyle(color: AppColor.primaryColor),
            unselectedLabelColor: AppColor.primaryColor,
            controller: _tabController,
            labelPadding: const EdgeInsets.symmetric(vertical: 15),
            labelStyle: const TextStyle(fontWeight: FontWeight.bold),
            unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
            tabs: const [
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
                  customTabView(formatDate()),
                  customTabView(
                      "${DateFormat('h:mm a').format(widget.event.startDate)} Onwards"),
                  customTabView(widget.event.location),
                  customTabView(
                      "${widget.event.tickets?[0]['name']} - Rs. ${widget.event.tickets?[0]['price']}/="),
                  customTabView(duration ?? ''),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Center customTabView(String text) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Icon(
            Icons.bookmark,
            color: Colors.white,
            size: 25,
          ),
          const SizedBox(
            width: 10,
          ),
          Text(
            text,
            style: const TextStyle(
                color: Colors.white, fontSize: 25, fontWeight: FontWeight.w500),
          )
        ],
      ),
    );
  }

  SizedBox eventBanner(double height, double width) {
    return SizedBox(
      width: width,
      child: Image.network(
        widget.event.coverImage ??
            'https://firebasestorage.googleapis.com/v0/b/together-d1575.appspot.com/o/images%2Fevents%2Fdefault_cover.jpg?alt=media&token=4faf4063-a0f9-409a-90a7-be92d76375ee',
        fit: BoxFit.fitWidth,
      ),
    );
  }
}
