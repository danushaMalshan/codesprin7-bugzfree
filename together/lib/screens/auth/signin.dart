import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:together/components/snack_bar.dart';
import 'package:together/utils/colors.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final TextEditingController _ctrlEmail = TextEditingController();
  final TextEditingController _ctrlPassword = TextEditingController();
  DateTime? _lastPressed;
  final ShowSnackBar _snackBar = ShowSnackBar();
  var ctime;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _loading = false;

  Future<void> _signIn() async {
    try {
      setState(() {
        _loading = true;
      });
      await _auth
          .signInWithEmailAndPassword(
              email: _ctrlEmail.text.trim(),
              password: _ctrlPassword.text.trim())
          .then((value) {
        Navigator.pushNamedAndRemoveUntil(
          context,
          '/home',
          (route) => false,
        );
      });

      setState(() {
        _loading = false;
      });
    } on FirebaseException catch (e) {
      _snackBar.showSnackaBar(context, e.message.toString(), null);
      setState(() {
        _loading = false;
      });
    } catch (e) {
      _snackBar.showSnackaBar(context, e.toString(), null);
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
    return WillPopScope(
      onWillPop: () async {
        DateTime currentTime = DateTime.now();
        bool backBtnPressedTwice = _lastPressed != null &&
            currentTime.difference(_lastPressed!) < Duration(seconds: 2);

        if (backBtnPressedTwice) {
          return true;
        }

        _lastPressed = currentTime;

        ShowSnackBar snackBar = ShowSnackBar();
        snackBar.showSnackaBar(context, 'Press back again to exit', Colors.red);
        return false;
      },
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
                    appLogo(width),
                    customSignupButton(
                        Colors.black87,
                        'assets/icons/apple_logo.png',
                        'Continue with Apple',
                        Colors.white),
                    customSignupButton(
                        Colors.blue.shade600,
                        'assets/icons/facebook.png',
                        'Continue with Facebook',
                        Colors.white),
                    customSignupButton(
                      Colors.grey.withOpacity(0.5),
                      'assets/icons/google.png',
                      'Continue with Google',
                      const Color.fromARGB(255, 1, 121, 226),
                    ),
                    orText(),
                    signInWithEmailPassword(width),
                    loginButton(width),
                    forgotPasswordText(),
                    dontHaveAnAccountText(context)
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  GestureDetector dontHaveAnAccountText(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamedAndRemoveUntil(
          context,
          '/sign_up',
          (route) => false,
        );
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
              _signIn();
            } else {
              _snackBar.showSnackaBar(context, 'Fields Cannot be Empty', null);
            }
          },
          style: ElevatedButton.styleFrom(
            primary: Colors.blue.shade900,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          child: _loading
              ? const Center(
                  child: SpinKitWave(color: Colors.white, size: 25),
                )
              : const Text(
                  'Log In',
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
              style: const TextStyle(
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
              style: const TextStyle(
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

  Padding orText() {
    return const Padding(
      padding: EdgeInsets.only(top: 20, bottom: 20),
      child: Text(
        'OR',
        style: TextStyle(color: Colors.grey, fontSize: 18),
      ),
    );
  }

  Padding customSignupButton(
      Color color, String image, String title, Color txtColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 5),
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
    );
  }
}
