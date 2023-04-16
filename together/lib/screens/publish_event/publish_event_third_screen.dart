import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';
import 'package:geocoding/geocoding.dart';
import 'package:together/components/appbar.dart';
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
  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  Set<Marker> _markers = {};

  void _onSearch() async {
    List<Location> locations = await locationFromAddress(_ctrlSearch.text);
    Location location = locations.first;
    LatLng latLng = LatLng(location.latitude, location.longitude);

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
            title: placemark.name,
            snippet: placemark.street,
          ),
        ),
      );
    });

    // Move the camera to the searched location
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
      target: latLng,
      zoom: 15,
    )));
    print(placemark.name);
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
                          onChanged: ((value) {
                            _onSearch();
                          }),
                          decoration: InputDecoration(
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
          ],
        ),
      ),
    );
  }
}
