import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:together/components/appbar.dart';
import 'package:together/components/bottom_navigation_bar.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class UserDetailsScreen extends StatefulWidget {
  const UserDetailsScreen({Key? key}) : super(key: key);

  @override
  State<UserDetailsScreen> createState() => _UserDetailsScreenState();
}

class _UserDetailsScreenState extends State<UserDetailsScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _usernameController = TextEditingController();
  String _fieldValue = '';

  File? _imageFile;
  final _picker = ImagePicker();
  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().getImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  Future<void> _uploadImage() async {
    if (_imageFile != null) {
      // Upload image to Firebase Storage
      String fileName = DateTime.now().toString();
      firebase_storage.Reference ref =
      firebase_storage.FirebaseStorage.instance.ref().child('images/$fileName.jpg');
      await ref.putFile(_imageFile!);
      String downloadUrl = await ref.getDownloadURL();

      setState(() {
        _imageUrl = downloadUrl;
      });
    }
  }


  // Future<String> getUrl() async {
  //   try{
  //
  //     Reference ref = FirebaseStorage.instance.ref().child('images/pro_pic/user.jpg');
  //     String imageUrl = await ref.getDownloadURL();
  //     String url=("$imageUrl");
  //     return url;
  //
  //   }catch(e){}
  // }

  void _getDataFromFirestore() async {
    try {
      DocumentReference documentReference =
          FirebaseFirestore.instance.doc('users/81mzPQlfl3PspsfYCQ0SowcNxF83');
      DocumentSnapshot documentSnapshot = await documentReference.get();

      if (documentSnapshot.exists) {
        setState(() {
          _fieldValue = documentSnapshot.get('username');
          _usernameController.text = _fieldValue;
        });
      }
    } catch (e) {}
  }

  @override
  void initState() {
    super.initState();
    _getDataFromFirestore();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: myAppBar(),
      body: SafeArea(
        child: Container(
          width: width,
          height: height,
          child: ListView(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(18.0),
                child: const Text(
                  'Let\'s change your credentials',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 30.0,
                  ),
                ),
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 20.0, horizontal: 8.0),
                  child: Stack(
                    children: <Widget>[
                      const CircleAvatar(
                        radius: 150.0,
                        // backgroundImage: getUrl();
                      ),
                      Positioned(
                        bottom: 10.0,
                        right: 15.0,
                        child: Container(
                          child: IconButton(
                            icon: Icon(Icons.add_photo_alternate),
                            onPressed: _pickImage,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(30.0),
                            border: Border.all(width: 2.0, color: Colors.amber),
                          ),
                          height: 50.0,
                          width: 50.0,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 15.0, horizontal: 30.0),
                      child: TextFormField(
                        controller: _usernameController,
                        decoration: InputDecoration(
                          icon: const Icon(Icons.badge),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0),
                            borderSide: const BorderSide(
                              width: 2,
                              color: Color(0xff142867),
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0),
                            borderSide: const BorderSide(
                              width: 2,
                              color: Color(0xff142867),
                            ),
                          ),
                          hintText: 'Field Value',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter email';
                          }
                          return null;
                        },
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {},
                      child: Text('Done'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            vertical: 16.0, horizontal: 40.0),
                        primary: const Color(0xff142867),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Container myListTile(String listTitle) {
  return Container(
    margin: const EdgeInsets.symmetric(
      vertical: 6.0,
      horizontal: 20.0,
    ),
    child: ListTile(
      contentPadding: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 20.0),
      shape: RoundedRectangleBorder(
        side: const BorderSide(
          width: 2,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      title: Text(listTitle),
      trailing: const Icon(Icons.arrow_forward_ios),
    ),
  );
}
