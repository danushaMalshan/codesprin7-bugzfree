import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignUpWithEmail extends StatefulWidget {
  const SignUpWithEmail({Key? key}) : super(key: key);

  @override
  State<SignUpWithEmail> createState() => _SignUpWithEmailState();
}

class _SignUpWithEmailState extends State<SignUpWithEmail> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  TextEditingController _ctrlEmail = TextEditingController();
  TextEditingController _ctrlPassword = TextEditingController();

  Future<void> _signUpWithEmailPassword() async {
    try {
      UserCredential credential = await _auth.createUserWithEmailAndPassword(
          email: _ctrlEmail.text, password: _ctrlPassword.text);
    } on FirebaseException catch (e) {
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
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
                    AppLogo(width),
                    SignInWithEmailPassword(width),
                    LoginButton(width),
                    ForgotPasswordText()
                  ],
                ),
              ),
            ),
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
            _signUpWithEmailPassword();
          },
          child: Text(
            'Sign Up',
            style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
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
      height: 150,
      width: width - 60,
      decoration: BoxDecoration(
          border: Border.all(width: 3, color: Colors.grey.withOpacity(0.4)),
          borderRadius: BorderRadius.circular(30)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 20),
            child: TextField(
              controller: _ctrlEmail,
              cursorColor: Colors.grey.withOpacity(0.4),
              style: TextStyle(
                  color: Colors.grey,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Email',
                hintStyle: TextStyle(
                    color: Colors.grey.withOpacity(0.4),
                    fontWeight: FontWeight.normal),
              ),
            ),
          ),
          Container(
            height: 3,
            width: width - 110,
            color: Colors.grey.withOpacity(0.4),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20),
            child: TextField(
              controller: _ctrlPassword,
              cursorColor: Colors.grey.withOpacity(0.4),
              style: TextStyle(
                  color: Colors.grey,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Password',
                hintStyle: TextStyle(
                    color: Colors.grey.withOpacity(0.4),
                    fontWeight: FontWeight.normal),
              ),
            ),
          ),
        ],
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
