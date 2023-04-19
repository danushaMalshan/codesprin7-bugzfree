import 'package:flutter/material.dart';
import 'package:together/components/bottom_navigation_bar.dart';
import 'package:together/components/snack_bar.dart';
import 'package:together/global.dart';
import 'package:together/utils/colors.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';

bool isSignUp = true;

final GoogleSignIn _googleSignIn = GoogleSignIn();

final FirebaseAuth _auth = FirebaseAuth.instance;
DateTime? _lastPressed;
Future<UserCredential?> signInWithGoogle() async {
  try {
    final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
    if (googleUser == null) return null;

    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    // Sign in to Firebase with the Google credential
    final UserCredential userCredential =
        await _auth.signInWithCredential(credential);
    final User? user = userCredential.user;

    // Persist user data in Firebase Authentication
    await user!.updateDisplayName(user.displayName ?? '');
    await user.updatePhotoURL(user.photoURL ?? '');
    await user.updateEmail(user.email ?? '');
    await user.reload(); // Reload user data from Firebase
    // Return the user credential
    return userCredential;
  } catch (error) {
    return null;
  }
}

VoidCallback _handleSignInWithGoogle() {
  return () async {
    UserCredential? userCredential = await signInWithGoogle();

    if (userCredential != null) {
      navigatorKey.currentState?.pushReplacement(MaterialPageRoute(
          builder: ((context) => const CustomNavigationBar(index: 2))));
    } else {}
  };
}

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  @override
  Widget build(BuildContext context) {
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
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
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
                        Colors.black,
                        null),
                    loginButtons(
                      "Continue with Facebook",
                      "assets/icons/facebook.png",
                      Colors.white,
                      const Color(0xff1877f2),
                      null,
                    ),
                    loginButtons(
                      "Continue with Google",
                      "assets/icons/google.png",
                      AppColor.primaryColor,
                      const Color(0xffd9d9d9),
                      () {
                        _handleSignInWithGoogle();
                        Navigator.pushReplacementNamed(context, '/home');
                      },
                    ),
                    signUpWithEmail(context),
                    const SizedBox(height: 20),
                    alreadyhaveAnAccountText(context),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  GestureDetector alreadyhaveAnAccountText(BuildContext context) {
    return GestureDetector(
        onTap: () {
          Navigator.pushReplacementNamed(context, '/login');
        },
        child: const Text("Already have an account?"));
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
