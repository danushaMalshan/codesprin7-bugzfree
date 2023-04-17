import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:together/components/snack_bar.dart';
// import 'package:cached_network_image/cached_network_image.dart';


class SignUpWithEmail extends StatefulWidget {
  const SignUpWithEmail({Key? key}) : super(key: key);

  @override
  State<SignUpWithEmail> createState() => _SignUpWithEmailState();
}

class _SignUpWithEmailState extends State<SignUpWithEmail> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  File? _image;
  final _picker = ImagePicker();

  TextEditingController _ctrlEmail = TextEditingController();
  TextEditingController _ctrlPassword = TextEditingController();
  TextEditingController _ctrlAge = TextEditingController();
  TextEditingController _ctrlUsername = TextEditingController();


  ShowSnackBar snackBar = ShowSnackBar();

  bool loading = false;

  final _formKey = GlobalKey<FormState>();

  Future<void> _signUpWithEmailPassword() async {
    try {
      setState(() {
        loading = true;
      });

      //
      UserCredential credential = await _auth.createUserWithEmailAndPassword(
          email: _ctrlEmail.text.trim(), password: _ctrlPassword.text.trim());
      if (credential != null) {
        //add profile pic to firebase
        if (_image != null) {
          final ref =
              _storage.ref().child('images/pro_pic/${_ctrlEmail.text.trim()}');
          await ref.putFile(_image!);
          final imageUrl = await ref.getDownloadURL();
          await credential.user!.updatePhotoURL(imageUrl);
        }

        await credential.user!.updateDisplayName(_ctrlUsername.text);
        
        await addUserData(credential);
        await _auth.signInWithEmailAndPassword(
            email: _ctrlEmail.text.trim(), password: _ctrlPassword.text.trim());
        _auth.authStateChanges().listen((User? user) {
          if (user == null) {
            Navigator.pushReplacementNamed(context, '/login');
          } else {
            Navigator.pushReplacementNamed(context, '/select_category');
          }
        });
      }
      setState(() {
        loading = false;
      });
    } on FirebaseException catch (e) {
      snackBar.showSnackaBar(context, e.message.toString(),null);
      setState(() {
        loading = false;
      });
    } catch (e) {
      snackBar.showSnackaBar(context, e.toString(),null);
      setState(() {
        loading = false;
      });
    }
  }

  Future<void> _signInWithEmailPassword() async {}

  Future<void> addUserData(UserCredential credential) async {
    String userID = credential.user!.uid;
    String? userEmail = credential.user!.email;
    _firestore.collection('users').doc(userID).set({
      'user_id': userID,
      'email': userEmail,
      'username': _ctrlUsername.text,
      'age': _ctrlAge.text
    });
  }

  bool _validate() {
    return (_ctrlAge.text.isNotEmpty &&
        _ctrlPassword.text.isNotEmpty &&
        _ctrlEmail.text.isNotEmpty &&
        _ctrlUsername.text.isNotEmpty);
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Color(0xFFFFFFFF),
      body: SizedBox(
        width: width,
        height: height,
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 30),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // AppLogo(width),
                  ProfilePicture(),
                  SignInWithEmailPassword(width),
                  LoginButton(width),
                  ForgotPasswordText(),
                  AlreadyHaveAnAccountText(context)
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget ProfilePicture() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(width: 5, color: Colors.grey.withOpacity(0.4)),
            ),
            child: Container(
              child: CircleAvatar(
                backgroundColor: Colors.transparent,
                radius: 65,
                child: _image == null
                    ? Icon(
                        Icons.person_outline_sharp,
                        size: 90,
                        color: Colors.grey.withOpacity(0.4),
                      )
                    : Image.file(
                        _image!,
                        fit: BoxFit.cover,
                        width: 150,
                        height: 150,
                      ),
              ),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
                // border:
                //     Border.all(width: 5, color: Colors.grey.withOpacity(0.4)),
              ),
              height: 150,
              width: 150,
              clipBehavior: Clip.hardEdge,
            ),
          ),
          Positioned(
              bottom: 6,
              right: 0,
              child: GestureDetector(
                onTap: () async {
                  final pickedFile = await _picker.pickImage(
                      source: ImageSource.gallery, imageQuality: 50);
                  setState(() {
                    _image = File(pickedFile!.path);
                  });
                },
                child: CircleAvatar(
                  backgroundColor: Colors.grey.shade300,
                  radius: 20,
                  child: Center(
                      child: Icon(
                    Icons.camera_alt_outlined,
                    size: 24,
                    color: Colors.white,
                  )),
                ),
              ))
        ],
      ),
    );
  }

  GestureDetector AlreadyHaveAnAccountText(BuildContext context) {
    return GestureDetector(
      onTap: loading
          ? null
          : () {
              Navigator.pushReplacementNamed(context, '/login');
            },
      child: Padding(
        padding: const EdgeInsets.only(top: 15),
        child: RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: 'Already have an account? ',
                style: TextStyle(color: Colors.blue.shade900, fontSize: 18),
              ),
              TextSpan(
                text: 'Login',
                style: TextStyle(
                    color: Colors.blue.shade900,
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              )
            ],
          ),
        ),
      ),
    );
  }

  Padding ForgotPasswordText() {
    return Padding(
      padding: const EdgeInsets.only(top: 15),
      child: Text(
        'Forgot Password?',
        style: TextStyle(color: Colors.blue.shade900, fontSize: 18),
      ),
    );
  }

  Container AppLogo(double width) {
    return Container(
        margin: EdgeInsets.only(bottom: 50),
        width: (width / 100) * 65,
        child: Image.asset('assets/images/logo.jpeg'));
  }

  Padding LoginButton(double width) {
    return Padding(
      padding: const EdgeInsets.only(top: 50),
      child: SizedBox(
        height: 60,
        width: width - 60,
        child: ElevatedButton(
          onPressed: () {
            if (_validate()) {
              _signUpWithEmailPassword();
            } else {
              snackBar.showSnackaBar(context, 'Fields Cannot be Empty',null);
            }
          },
          child: loading
              ? Center(
                  child: SpinKitWave(color: Colors.white, size: 25),
                )
              : Text(
                  'Sign Up',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20),
                ),
          style: ElevatedButton.styleFrom(
            primary: Colors.blue.shade900,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        ),
      ),
    );
  }

  Container SignInWithEmailPassword(double width) {
    return Container(
      height: 330,
      width: width - 60,
      decoration: BoxDecoration(
          border: Border.all(width: 3, color: Colors.grey.withOpacity(0.4)),
          borderRadius: BorderRadius.circular(30)),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CustomTextField(
              controller: _ctrlUsername,
              hint: 'Username',
              isObscure: false,
              keyboardType: TextInputType.name,
              errorMsg: 'Please enter a valid name',
            ),
            Container(
              height: 3,
              width: width - 110,
              color: Colors.grey.withOpacity(0.4),
            ),
            CustomTextField(
                controller: _ctrlAge,
                hint: 'Age',
                isObscure: false,
                keyboardType: TextInputType.number,
                errorMsg: 'Please enter a valid age'),
            Container(
              height: 3,
              width: width - 110,
              color: Colors.grey.withOpacity(0.4),
            ),
            CustomTextField(
                controller: _ctrlEmail,
                hint: 'Email',
                isObscure: false,
                keyboardType: TextInputType.emailAddress,
                errorMsg: 'Please enter a valid Email'),
            Container(
              height: 3,
              width: width - 110,
              color: Colors.grey.withOpacity(0.4),
            ),
            CustomTextField(
                controller: _ctrlPassword,
                hint: 'Password',
                isObscure: true,
                errorMsg: 'Please enter a valid Password'),
          ],
        ),
      ),
    );
  }

  Padding CustomTextField({
    required String hint,
    required TextEditingController controller,
    TextInputType? keyboardType,
    required bool isObscure,
    RegExp? reg,
    required String errorMsg,
  }) {
    return Padding(
      padding: const EdgeInsets.only(left: 20),
      child: TextFormField(
        obscureText: isObscure,
        keyboardType: keyboardType,
        controller: controller,
        cursorColor: Colors.grey.withOpacity(0.4),
        style: TextStyle(
            color: Colors.grey, fontSize: 20, fontWeight: FontWeight.bold),
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hint,
          hintStyle: TextStyle(
              color: Colors.grey.withOpacity(0.4),
              fontWeight: FontWeight.normal),
        ),
      ),
    );
  }

  Padding OrText() {
    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 20),
      child: Text(
        'OR',
        style: TextStyle(color: Colors.grey, fontSize: 18),
      ),
    );
  }

  GestureDetector AlreadyhaveAnAccountText(BuildContext context) {
    return GestureDetector(
        onTap: () {
          Navigator.pushReplacementNamed(context, '/login');
        },
        child: const Text("Already have an account?"));
  }

  Padding CustomSignupButton(
      Color color, String image, String title, Color txtColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 5),
      child: InkWell(
        onTap: () {},
        child: Container(
          height: 60,
          child: ListTile(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            tileColor: color,
            title: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Text(
                title,
                style: TextStyle(
                    color: txtColor, fontWeight: FontWeight.w500, fontSize: 20),
                textAlign: TextAlign.center,
              ),
            ),
            trailing: Container(
              height: 32,
              width: 32,
            ),
            leading: Image.asset(
              image,
              height: 32,
              width: 32,
            ),
          ),
        ),
      ),
    );
  }
}
