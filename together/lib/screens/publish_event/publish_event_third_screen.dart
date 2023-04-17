import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';
import 'package:geocoding/geocoding.dart';
import 'package:together/components/appbar.dart';
import 'package:together/components/snack_bar.dart';
import 'package:together/screens/publish_event/publish_event_fourth_screen.dart';
import 'package:together/utils/colors.dart';

class PublishEventThirdScreen extends StatefulWidget {
  PublishEventThirdScreen(
      {Key? key,
      required this.eventName,
      required this.description,
      required this.startDate,
      required this.endDate,
      required this.tickets})
      : super(key: key);
  String eventName;
  String description;
  DateTime startDate;
  DateTime endDate;
  List<Map<String, dynamic>> tickets;
  @override
  State<PublishEventThirdScreen> createState() =>
      _PublishEventThirdScreenState();
}

class _PublishEventThirdScreenState extends State<PublishEventThirdScreen> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();
  TextEditingController _ctrlSearch = TextEditingController();
  ShowSnackBar snackBar = ShowSnackBar();
  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  Set<Marker> _markers = {};
  LatLng? latLng;
  void _onSearch() async {
    try {
      List<Location>? locations = await locationFromAddress(_ctrlSearch.text);
      Location location = locations.first;
      LatLng latLng = LatLng(location.latitude, location.longitude);
      this.latLng = latLng;
      List<Placemark> placemarks =
          await placemarkFromCoordinates(location.latitude, location.longitude);
      Placemark placemark = placemarks.first;

      setState(() {
        _markers.clear();
        _markers.add(
          Marker(
            markerId: MarkerId(location.toString()),
            position: latLng,
            infoWindow: InfoWindow(
              title: placemark.country,
              snippet: placemark.street,
            ),
          ),
        );
      });

      final GoogleMapController controller = await _controller.future;
      controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
        target: latLng,
        zoom: 15,
      )));
      print(placemark.name);
    } catch (e) {
      snackBar.showSnackaBar(context, e.toString(),null);
    }
  }

  void _onMapTap(LatLng latLng) {
    setState(() {
      _markers.clear();
      _markers.add(
        Marker(
          markerId: MarkerId(latLng.toString()),
          position: latLng,
          infoWindow: InfoWindow(
            title: widget.eventName,
            snippet: latLng.toString(),
          ),
        ),
      );
    });
    this.latLng = latLng;
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: myAppBar(context, true),
      body: SizedBox(
        height: height,
        width: width,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Text(
                'Mark Your Event Location',
                style: TextStyle(
                    color: AppColor.primaryColor,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
            ),
            Expanded(
              child: Stack(
                children: [
                  // Positioned(top: 20, left: 10, child: TextField()),

                  GoogleMap(
                    mapType: MapType.normal,
                    initialCameraPosition: _kGooglePlex,
                    onTap: _onMapTap,
                    onMapCreated: (GoogleMapController controller) {
                      _controller.complete(controller);
                    },
                    markers: _markers,
                  ),
                  Positioned.fill(
                    top: 30,
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30),
                        child: TextField(
                          controller: _ctrlSearch,
                          onSubmitted: ((value) {
                            if (value != '') {
                              _onSearch();
                            } else {
                              snackBar.showSnackaBar(
                                  context, 'Enter valid address',null);
                            }
                          }),
                          decoration: InputDecoration(
                            hintText: 'Enter Location Address',
                            border: UnderlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: BorderSide.none,
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: BorderSide.none,
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: BorderSide.none,
                            ),
                            fillColor: Colors.white.withOpacity(0.7),
                            filled: true,
                            contentPadding:
                                EdgeInsets.only(left: 20, top: 10, bottom: 10),
                            suffixIcon: Icon(
                              Icons.search,
                              color: Colors.black,
                            ),
                          ),
                          cursorColor: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: SizedBox(
                height: 40,
                width: width - 100,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        primary: AppColor.primaryColor,
                        shape: RoundedRectangleBorder(
                          side: BorderSide(
                              width: 2, color: AppColor.primaryColor),
                          borderRadius: BorderRadius.circular(10),
                        )),
                    onPressed: () {
                      if (latLng != null) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => PublishEventFourthScreen(
                                      description: widget.description,
                                      eventName: widget.eventName,
                                      startDate: widget.startDate,
                                      endDate: widget.endDate,
                                      tickets: widget.tickets,
                                      latLng: latLng!,
                                    )));
                      } else {
                        snackBar.showSnackaBar(
                            context, 'Please select your event location',null);
                      }
                    },
                    child: Text(
                      'Next',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
