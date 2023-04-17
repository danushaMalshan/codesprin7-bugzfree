import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:together/components/snack_bar.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  TextEditingController _ctrlEmail = TextEditingController();
  TextEditingController _ctrlPassword = TextEditingController();

  ShowSnackBar _snackBar = ShowSnackBar();

  FirebaseAuth _auth = FirebaseAuth.instance;
  bool _loading = false;

  Future<void> _signIn() async {
    try {
      setState(() {
        _loading = true;
      });
      final _userCredential = await _auth.signInWithEmailAndPassword(
          email: _ctrlEmail.text.trim(), password: _ctrlPassword.text.trim());
      if (_userCredential.user != null) {
        Navigator.pushReplacementNamed(context, '/home');
      }
      setState(() {
        _loading = false;
      });
    } on FirebaseException catch (e) {
      _snackBar.showSnackaBar(context, e.message.toString(),null);
      setState(() {
        _loading = false;
      });
    } catch (e) {
      _snackBar.showSnackaBar(context, e.toString(),null);
      setState(() {
        _loading = false;
      });
    }
  }

  bool _validate() {
    return (_ctrlPassword.text.isNotEmpty && _ctrlEmail.text.isNotEmpty);
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
                  CustomSignupButton(
                      Colors.black87,
                      'assets/icons/apple_logo.png',
                      'Continue with Apple',
                      Colors.white),
                  CustomSignupButton(
                      Colors.blue.shade600,
                      'assets/icons/facebook.png',
                      'Continue with Facebook',
                      Colors.white),
                  CustomSignupButton(
                    Colors.grey.withOpacity(0.5),
                    'assets/icons/google.png',
                    'Continue with Google',
                    Color.fromARGB(255, 1, 121, 226),
                  ),
                  OrText(),
                  SignInWithEmailPassword(width),
                  LoginButton(width),
                  ForgotPasswordText(),
                  DontHaveAnAccountText(context)
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  GestureDetector DontHaveAnAccountText(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushReplacementNamed(context, '/sign_up');
      },
      child: Padding(
        padding: const EdgeInsets.only(top: 15),
        child: RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: 'Don\'t have an account? ',
                style: TextStyle(color: Colors.blue.shade900, fontSize: 18),
              ),
              TextSpan(
                text: 'Sign Up',
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
              _signIn();
            } else {
              _snackBar.showSnackaBar(context, 'Fields Cannot be Empty',null);
            }
          },
          child: _loading
              ? Center(
                  child: SpinKitWave(color: Colors.white, size: 25),
                )
              : Text(
                  'Log In',
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
            child: TextFormField(
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
            child: TextFormField(
              obscureText: true,
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
    );
  }
}
