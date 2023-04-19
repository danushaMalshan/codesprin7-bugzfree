import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:together/components/appbar.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:together/components/snack_bar.dart';
import 'package:together/utils/colors.dart';

class UserDetailsScreen extends StatefulWidget {
  const UserDetailsScreen({Key? key}) : super(key: key);

  @override
  State<UserDetailsScreen> createState() => _UserDetailsScreenState();
}

class _UserDetailsScreenState extends State<UserDetailsScreen> {

  final TextEditingController _usernameController = TextEditingController();
  final FirebaseStorage _storage = FirebaseStorage.instance;
  File? _image;
  User? user = FirebaseAuth.instance.currentUser;
  bool newImageSelected = false;
  final _picker = ImagePicker();

  ShowSnackBar snackBar = ShowSnackBar();

  bool loading = false;
  @override
  void initState() {
 
    super.initState();
    _usernameController.text = user?.displayName ?? '';
  }

  Future<void> _updateUserDetails(BuildContext context) async {
    try {
      setState(() {
        loading = true;
      });

      if (user != null) {
        //add profile pic to firebase
        if (_image != null) {
          final ref = _storage.ref().child('images/pro_pic/${user!.email}');
          await ref.putFile(_image!);
          final imageUrl = await ref.getDownloadURL();
          await user!.updatePhotoURL(imageUrl);
        }

        await user!.updateDisplayName(_usernameController.text).then((value) {
          snackBar.showSnackaBar(
              context, "User Details update successfully", Colors.green);
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
      resizeToAvoidBottomInset: false,
      appBar: myAppBar(context, true),
      body: loading
          ? const Center(
              child: SpinKitWave(
                color: AppColor.primaryColor,
                size: 40,
              ),
            )
          : SingleChildScrollView(
              child: SizedBox(
                width: width,
                height: height,
                child: Column(children: [
                  const Padding(
                    padding: EdgeInsets.all(18.0),
                    child: Text(
                      'Let\'s change your credentials',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 30.0,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 20.0, horizontal: 8.0),
                    child: SizedBox(
                      height: 300,
                      width: 300,
                      child: Stack(
                        children: <Widget>[
                          Container(
                            clipBehavior: Clip.hardEdge,
                            height: 300,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                            ),
                            child: _image == null
                                ? CircleAvatar(
                                    radius: 150.0,
                                    child: Image.network(user?.photoURL ??
                                        'https://firebasestorage.googleapis.com/v0/b/together-d1575.appspot.com/o/images%2Fpro_pic%2Fuser.jpg?alt=media&token=4086b98c-0d4c-4789-a216-038b89b6a08d'))
                                : Image.file(
                                    _image!,
                                    fit: BoxFit.cover,
                                    width: 300,
                                    height: 300,
                                  ),
                          ),
                          Positioned(
                            bottom: 10.0,
                            right: 15.0,
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(30.0),
                                border:
                                    Border.all(width: 2.0, color: Colors.amber),
                              ),
                              height: 50.0,
                              width: 50.0,
                              child: IconButton(
                                icon: const Icon(Icons.add_photo_alternate),
                                onPressed: () async {
                                  final pickedFile = await _picker.pickImage(
                                      source: ImageSource.gallery,
                                      imageQuality: 50);
                                  setState(() {
                                    _image = File(pickedFile!.path);
                                  });
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
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
                        hintText: 'Username',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter username';
                        }
                        return null;
                      },
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      _updateUserDetails(context);
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          vertical: 16.0, horizontal: 40.0),
                      primary: const Color(0xff142867),
                    ),
                    child: const Text('Done'),
                  ),
                  Container(
                    height: 500,
                  )
                ]),
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
      contentPadding:
          const EdgeInsets.symmetric(vertical: 2.0, horizontal: 20.0),
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
