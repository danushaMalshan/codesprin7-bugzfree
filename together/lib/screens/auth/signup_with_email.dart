import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:together/components/snack_bar.dart';
import 'package:together/global.dart';
import 'package:together/screens/auth/email_verify.dart';
// import 'package:cached_network_image/cached_network_image.dart';

class SignUpWithEmail extends StatefulWidget {
  const SignUpWithEmail({Key? key}) : super(key: key);

  @override
  State<SignUpWithEmail> createState() => _SignUpWithEmailState();
}

class _SignUpWithEmailState extends State<SignUpWithEmail> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  File? _image;
  final _picker = ImagePicker();

  final TextEditingController _ctrlEmail = TextEditingController();
  final TextEditingController _ctrlPassword = TextEditingController();
  final TextEditingController _ctrlAge = TextEditingController();
  final TextEditingController _ctrlUsername = TextEditingController();

  ShowSnackBar snackBar = ShowSnackBar();

  bool loading = false;
  DateTime? _lastPressed;
  final _formKey = GlobalKey<FormState>();
  String? imageUrl;
  Future<void> _signUpWithEmailPassword() async {
    try {
      setState(() {
        loading = true;
      });

      UserCredential credential = await _auth.createUserWithEmailAndPassword(
          email: _ctrlEmail.text.trim(), password: _ctrlPassword.text.trim());

      if (_image != null) {
        final ref =
            _storage.ref().child('images/pro_pic/${_ctrlEmail.text.trim()}');
        await ref.putFile(_image!);
        imageUrl = await ref.getDownloadURL();
        await credential.user!.updatePhotoURL(imageUrl);
      }

      await credential.user!.updateDisplayName(_ctrlUsername.text);

      await addUserData(credential);

      navigatorKey.currentState?.push(
          MaterialPageRoute(builder: ((context) => EmailVerifyScreen(name:_ctrlUsername.text,email: _ctrlEmail.text))));

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

  bool isEmailVerified() {
    User? user = FirebaseAuth.instance.currentUser;
    return user != null && user.emailVerified;
  }

  Future<void> addUserData(UserCredential credential) async {
    String userID = credential.user!.uid;
    String? userEmail = credential.user!.email;
    _firestore.collection('users').doc(userID).set({
      'user_id': userID,
      'email': userEmail,
      'username': _ctrlUsername.text,
      'age': _ctrlAge.text,
      'is_admin': false,
      'img': imageUrl
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
    return WillPopScope(
      onWillPop: () async {
        DateTime currentTime = DateTime.now();
        bool backBtnPressedTwice = _lastPressed != null &&
            currentTime.difference(_lastPressed!) < const Duration(seconds: 2);

        if (backBtnPressedTwice) {
          return true;
        }

        _lastPressed = currentTime;

        ShowSnackBar snackBar = ShowSnackBar();
        snackBar.showSnackaBar(context, 'Press back again to exit', Colors.red);
        return false;
      },
      child: SafeArea(
        child: Scaffold(
          backgroundColor: const Color(0xFFFFFFFF),
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
                      profilePicture(),
                      signInWithEmailPassword(width),
                      loginButton(width),
                      forgotPasswordText(),
                      alreadyHaveAnAccountText(context)
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget profilePicture() {
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
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
              ),
              height: 150,
              width: 150,
              clipBehavior: Clip.hardEdge,
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
                  child: const Center(
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

  GestureDetector alreadyHaveAnAccountText(BuildContext context) {
    return GestureDetector(
      onTap: loading
          ? null
          : () {
              Navigator.pushNamedAndRemoveUntil(
                context,
                '/login',
                (route) => false,
              );
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

  Padding forgotPasswordText() {
    return Padding(
      padding: const EdgeInsets.only(top: 15),
      child: Text(
        'Forgot Password?',
        style: TextStyle(color: Colors.blue.shade900, fontSize: 18),
      ),
    );
  }

  Container appLogo(double width) {
    return Container(
        margin: const EdgeInsets.only(bottom: 50),
        width: (width / 100) * 65,
        child: Image.asset('assets/images/logo.jpeg'));
  }

  Padding loginButton(double width) {
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
              snackBar.showSnackaBar(context, 'Fields Cannot be Empty', null);
            }
          },
          style: ElevatedButton.styleFrom(
            primary: Colors.blue.shade900,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          child: loading
              ? const Center(
                  child: SpinKitWave(color: Colors.white, size: 25),
                )
              : const Text(
                  'Sign Up',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20),
                ),
        ),
      ),
    );
  }

  Container signInWithEmailPassword(double width) {
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
            customTextField(
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
            customTextField(
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
            customTextField(
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
            customTextField(
                controller: _ctrlPassword,
                hint: 'Password',
                isObscure: true,
                errorMsg: 'Please enter a valid Password'),
          ],
        ),
      ),
    );
  }

  Padding customTextField({
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
        style: const TextStyle(
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

  Padding orText() {
    return const Padding(
      padding: EdgeInsets.only(top: 20, bottom: 20),
      child: Text(
        'OR',
        style: TextStyle(color: Colors.grey, fontSize: 18),
      ),
    );
  }

  GestureDetector alreadyhaveAnAccountText(BuildContext context) {
    return GestureDetector(
        onTap: () {
          Navigator.pushNamedAndRemoveUntil(
            context,
            '/login',
            (route) => false,
          );
        },
        child: const Text("Already have an account?"));
  }

  Padding customSignupButton(
      Color color, String image, String title, Color txtColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 5),
      child: InkWell(
        onTap: () {},
        child: SizedBox(
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
            trailing: const SizedBox(
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
