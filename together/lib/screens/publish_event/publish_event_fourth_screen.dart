import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:together/components/appbar.dart';
import 'package:together/components/snack_bar.dart';
import 'package:together/models/event_model.dart';
import 'package:together/utils/colors.dart';
import 'dart:math';

class PublishEventFourthScreen extends StatefulWidget {
  PublishEventFourthScreen(
      {Key? key,
      required this.eventName,
      required this.description,
      required this.startDate,
      required this.endDate,
      required this.tickets,
      required this.latLng,
      required this.category,
      required this.location})
      : super(key: key);
  String eventName;
  String description;
  DateTime startDate;
  DateTime endDate;
  List<Map<String, dynamic>> tickets;
  LatLng latLng;
  int category;
  String location;
  @override
  State<PublishEventFourthScreen> createState() =>
      _PublishEventFourthScreenState();
}

class _PublishEventFourthScreenState extends State<PublishEventFourthScreen> {
  File? _coverImage;
  final _picker = ImagePicker();
  bool loading = false;
  List<File> _images = [];
  List<String> _imagesUrl = [];
  List<File>? _pickedImage;
  ShowSnackBar snackBar = ShowSnackBar();
  String? _coverImgUrl;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<void> _addEventToREview(BuildContext context) async {
    try {
      setState(() {
        loading = true;
      });
      User? _user = _auth.currentUser;
      if (_user != null) {
        //upload cover image
        final random = Random();
        final randomNumber = random.nextInt(10000);
        final coverRef = _storage.ref().child(
            'images/events/${_user.email}/${widget.eventName}$randomNumber/cover_image');
        await coverRef.putFile(_coverImage!);
        final coverImageUrl = await coverRef.getDownloadURL();
        _coverImgUrl = coverImageUrl;

        for (int i = 0; i < _images.length; i++) {
          final ref = _storage.ref().child(
              'images/events/${_user.email}/${widget.eventName}$randomNumber/img$i');
          await ref.putFile(_images[i]);
          final imageUrl = await ref.getDownloadURL();
          _imagesUrl.add(imageUrl);
        }

        EventModel event = EventModel(
            id: '',
            name: widget.eventName,
            organizer_id: _user.uid,
            description: widget.description,
            start_date: widget.startDate,
            end_date: widget.endDate,
            category: widget.category,
            latitude: widget.latLng.latitude,
            longitude: widget.latLng.longitude,
            cover_image: _coverImgUrl!,
            is_approve: false,
            images: _imagesUrl,
            location: widget.location,
            tickets: widget.tickets);
        await _firestore.collection('events').add(event.toMap()).then((value) {
          Navigator.pushReplacementNamed(context, '/profile');
          snackBar.showSnackaBar(
              context, 'Event successfully add for the review', Colors.green);
        });
      }

      setState(() {
        loading = false;
      });
    } on FirebaseException catch (e) {
      snackBar.showSnackaBar(context, e.message.toString(), null);
      setState(() {
        loading = false;
      });
    } catch (e) {
      snackBar.showSnackaBar(context, e.toString(), null);
      setState(() {
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: myAppBar(context, true),
      body: loading
          ? Center(
              child: SpinKitWave(
                color: AppColor.primaryColor,
                size: 50,
              ),
            )
          : SizedBox(
              width: width,
              height: height,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Text(
                      'Select the cover image for your event',
                      style: TextStyle(
                          color: AppColor.primaryColor,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                    width: width,
                    height: height / 4,
                    decoration: BoxDecoration(
                        color: AppColor.primaryColor.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20)),
                    child: _coverImage != null
                        ? Image.file(
                            _coverImage!,
                            fit: BoxFit.cover,
                            width: width,
                            height: height / 4,
                          )
                        : IconButton(
                            onPressed: () async {
                              final pickedFile = await _picker.pickImage(
                                  source: ImageSource.gallery,
                                  imageQuality: 50);
                              setState(() {
                                _coverImage = File(pickedFile!.path);
                              });
                            },
                            icon: Icon(
                              Icons.add,
                              color: AppColor.primaryColor.withOpacity(0.6),
                              size: 80,
                            ),
                          ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Text(
                      'Add other images',
                      style: TextStyle(
                          color: AppColor.primaryColor,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding:
                          const EdgeInsets.only(left: 20, right: 10, top: 20),
                      child: GridView.builder(
                        itemCount: _images.length + 1,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            childAspectRatio: 3 / 4,
                            crossAxisSpacing: 15,
                            mainAxisSpacing: 15,
                            crossAxisCount: 3),
                        itemBuilder: (context, index) => Container(
                          margin: EdgeInsets.only(right: 10),
                          width: width / 3 - 20,
                          height: height / 4,
                          decoration: BoxDecoration(
                              color: AppColor.primaryColor.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(20)),
                          child: index == _images.length
                              ? IconButton(
                                  onPressed: () async {
                                    File _img;
                                    final pickedFile = await _picker.pickImage(
                                        source: ImageSource.gallery,
                                        imageQuality: 50);

                                    _img = File(pickedFile!.path);
                                    setState(() {
                                      _images.add(_img);
                                    });
                                  },
                                  icon: Icon(
                                    Icons.add,
                                    color:
                                        AppColor.primaryColor.withOpacity(0.6),
                                    size: 50,
                                  ),
                                )
                              : Image.file(
                                  _images[index],
                                  fit: BoxFit.cover,
                                  width: width / 3 - 20,
                                  height: height / 4,
                                ),
                        ),
                      ),
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
                            _addEventToREview(context);
                          },
                          child: Text(
                            'Add Event to Review',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
    );
  }
}
