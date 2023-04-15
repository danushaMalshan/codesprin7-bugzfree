import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:together/components/appbar.dart';
import 'package:together/components/bottom_navigation_bar.dart';
import 'package:file_picker/file_picker.dart';

class UserDetailsScreen extends StatefulWidget {
  const UserDetailsScreen({Key? key}) : super(key: key);

  @override
  State<UserDetailsScreen> createState() => _UserDetailsScreenState();
}

class _UserDetailsScreenState extends State<UserDetailsScreen> {
  // PlatformFile? pickedFile;
// DocumentSnapshot _username= Firestore.instance.colloection('users').doc('81mzPQlfl3PspsfYCQ0SowcNxF83').get();

  final _formKey = GlobalKey<FormState>();
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  // selectFile()async{
  //   FilePickerResult? result = await FilePicker.platform.pickFiles();
  //
  //   if (result != null) {
  //     File file = File(result.files.single.path);
  //   } else {
  //     // User canceled the picker
  //   }

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
                        backgroundImage:
                            AssetImage('assets/images/Profile Picture.jpg'),
                      ),
                      Positioned(
                        bottom: 10.0,
                        right: 15.0,
                        child: Container(
                          child: IconButton(
                            icon: Icon(Icons.add_photo_alternate),
                            onPressed: (){},
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(30.0),
                            border: Border.all(width: 2.0, color: Colors.black),
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
                          hintText: 'Email',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter email';
                          }
                          return null;
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 15.0, horizontal: 30.0),
                      child: TextFormField(
                        controller: _passwordController,
                        decoration: InputDecoration(
                          icon: const Icon(Icons.password),
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
                          hintText: 'Password',
                        ),
                        obscureText: true,
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
                        padding: const EdgeInsets.symmetric(vertical: 16.0,horizontal: 40.0),
                        primary: const Color(0xff142867),
                      ),
                    ),
                  ],
                ),
              ),
              // Stack(
              //   children: [
              //     CircleAvatar(
              //       radius: 75,
              //       backgroundColor: Colors.grey.shade200,
              //       child: CircleAvatar(
              //         radius: 70,
              //         backgroundImage: AssetImage('assets/images/default.png'),
              //       ),
              //     ),
              //     Positioned(
              //       bottom: 1,
              //       right: 1,
              //       child: Container(
              //         child: Padding(
              //           padding: const EdgeInsets.all(2.0),
              //           child: Icon(Icons.add_a_photo, color: Colors.black),
              //         ),
              //         decoration: BoxDecoration(
              //             border: Border.all(
              //               width: 3,
              //               color: Colors.white,
              //             ),
              //             borderRadius: BorderRadius.all(
              //               Radius.circular(
              //                 50,
              //               ),
              //             ),
              //             color: Colors.white,
              //             boxShadow: [
              //               BoxShadow(
              //                 offset: Offset(2, 4),
              //                 color: Colors.black.withOpacity(
              //                   0.3,
              //                 ),
              //                 blurRadius: 3,
              //               ),
              //             ]),
              //       ),
              //     ),
              //   ],
              // )
            ],
          ),
        ),
      ),
    );
  }
}


Container myListTile(String listTitle) {
  return Container(
    margin: EdgeInsets.symmetric(
      vertical: 6.0,
      horizontal: 20.0,
    ),
    child: ListTile(
      contentPadding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 20.0),
      shape: RoundedRectangleBorder(
        side: BorderSide(
          width: 2,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      title: Text(listTitle),
      trailing: const Icon(Icons.arrow_forward_ios),
    ),
  );
}
