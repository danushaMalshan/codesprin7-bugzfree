import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
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
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  TextEditingController _ctrlEmail = TextEditingController();
  TextEditingController _ctrlPassword = TextEditingController();
  TextEditingController _ctrlAge = TextEditingController();
  TextEditingController _ctrlUsername = TextEditingController();
  bool loading = false;
  final _formKey = GlobalKey<FormState>();

  Future<void> _signUpWithEmailPassword() async {
    try {
      setState(() {
        loading = true;
      });
      UserCredential credential = await _auth.createUserWithEmailAndPassword(
          email: _ctrlEmail.text, password: _ctrlPassword.text);
      if (credential != null) {
        await addUserData(credential);
      }
      setState(() {
        loading = false;
      });
    } on FirebaseException catch (e) {
      _showSnackaBar(context, e.message.toString());
      setState(() {
        loading = false;
      });
    } catch (e) {
      _showSnackaBar(context, e.toString());
      setState(() {
        loading = false;
      });
    }
  }

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

  void _showSnackaBar(BuildContext context, String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        padding: EdgeInsets.symmetric(vertical: 20),
        backgroundColor: Colors.red,
        content: Text(
          msg,
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
          textAlign: TextAlign.center,
        )));
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
                  AppLogo(width),
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
              _showSnackaBar(context, 'Fields Cannot be Empty');
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
