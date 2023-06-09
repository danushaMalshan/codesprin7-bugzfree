import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:together/components/bottom_navigation_bar.dart';
import 'package:together/components/show_dialog.dart';
import 'package:together/components/snack_bar.dart';
import 'package:together/global.dart';
import 'package:together/utils/colors.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  bool isSignUp = true;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();
  DateTime? _lastPressed;
  final ShowSnackBar _snackBar = ShowSnackBar();
  bool _loading = false;
  Future<void> signInWithGoogle() async {
    try {
      setState(() {
        _loading = true;
      });

      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;
      if (googleAuth != null) {
        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );
        final UserCredential userCredential =
            await _auth.signInWithCredential(credential);
        final User? user = userCredential.user;
        if (user != null) {
          navigatorKey.currentState?.pushAndRemoveUntil(
              MaterialPageRoute(
                  builder: (context) => const CustomNavigationBar(
                        index: 2,
                      )),
              (route) => false);
        }
      }

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

  @override
  Widget build(BuildContext context) {
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
          backgroundColor: Colors.white,
          body: _loading
              ? const Center(
                  child: SpinKitWave(
                    color: AppColor.primaryColor,
                    size: 40,
                  ),
                )
              : SingleChildScrollView(
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        const SizedBox(height: 20),
                        const Image(
                          image: AssetImage("assets/images/logo.jpeg"),
                          height: 350,
                          width: 300,
                        ),
                        const SizedBox(height: 70),
                        Column(
                          children: [
                            loginButtons(
                                "Continue with Apple",
                                "assets/icons/apple_logo.png",
                                Colors.white,
                                Colors.black, () {
                              customDevelopmentShowDialog(context,
                                  'Sorry! This feature is under development. for now, you can use the sign in with the email & sign in with Google');
                            }),
                            loginButtons(
                              "Continue with Facebook",
                              "assets/icons/facebook.png",
                              Colors.white,
                              const Color(0xff1877f2),
                              () {
                                customDevelopmentShowDialog(context,
                                    'Sorry! This feature is under development. for now, you can use the sign in with the email & sign in with Google');
                              },
                            ),
                            loginButtons(
                              "Continue with Google",
                              "assets/icons/google.png",
                              AppColor.primaryColor,
                              const Color(0xffd9d9d9),
                              () {
                                signInWithGoogle();
                              },
                            ),
                            signUpWithEmail(context),
                            const SizedBox(height: 15),
                            alreadyHaveAnAccountText(context),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
        ),
      ),
    );
  }

  GestureDetector alreadyHaveAnAccountText(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamedAndRemoveUntil(
          context,
          '/login',
          (route) => false,
        );
      },
      child: Padding(
        padding: const EdgeInsets.only(top: 0),
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

  Padding signUpWithEmail(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 30),
      child: ListTile(
        onTap: () {
          Navigator.pushReplacementNamed(context, '/sign_up_with_email');
        },
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        tileColor: const Color(0xffd9d9d9),
        leading: const Icon(Icons.mail_outline_rounded, size: 32),
        title: const Center(
          child: Text(
            "Continue with Email",
            style: TextStyle(
              color: AppColor.primaryColor,
              fontSize: 20,
            ),
          ),
        ),
        trailing: const Icon(Icons.ice_skating, color: Colors.transparent),
      ),
    );
  }
}

Widget loginButtons(String title, String imagePath, Color titleColor,
    Color backColor, GestureTapCallback? functionName) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 30),
    child: ListTile(
      onTap: functionName,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      tileColor: backColor,
      leading: Image.asset(
        imagePath,
        height: 32,
      ),
      title: Center(
        child: Text(
          title,
          style: TextStyle(
            color: titleColor,
            fontSize: 20,
          ),
        ),
      ),
      trailing: const Icon(Icons.ice_skating, color: Colors.transparent),
    ),
  );
}
