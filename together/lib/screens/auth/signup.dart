import 'package:flutter/material.dart';
import 'package:together/utils/colors.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';



final GoogleSignIn _googleSignIn = GoogleSignIn();

final FirebaseAuth _auth = FirebaseAuth.instance;

Future<UserCredential?> signInWithGoogle() async {
  try {

    final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
    if (googleUser == null) return null;


    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;


    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    // Sign in to Firebase with the Google credential
    final UserCredential userCredential = await _auth.signInWithCredential(credential);

    // Return the user credential
    return userCredential;
  } catch (error) {
    // Handle any errors
    print('Failed to sign in with Google: $error');
    return null;
  }
}

VoidCallback _handleSignInWithGoogle() {
  return () async {
    // Call the signInWithGoogle() method
    UserCredential? userCredential = await signInWithGoogle();

    // Do something with the userCredential, such as updating the UI or navigating to a new page
    if (userCredential != null) {
      print('Signed in with Google: ${userCredential.user?.displayName}');
      // Update the UI or navigate to a new page
    } else {
      print('Failed to sign in with Google');
      // Show an error message or perform error handling
    }
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
    return Scaffold(
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
                      Colors.black),
                  loginButtons(
                    "Continue with Facebook",
                    "assets/icons/facebook.png",
                    Colors.white,
                    const Color(0xff1877f2),
                  ),
                  loginButtons(
                    "Continue with Google",
                    "assets/icons/google.png",
                     AppColor.primaryColor,
                    const Color(0xffd9d9d9),
                  ),
                  SignUpWithEmail(context),
                  const SizedBox(height: 20),
                  AlreadyhaveAnAccountText(context),
                ],
              ),
            ],
          ),
        ),
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

  Padding SignUpWithEmail(BuildContext context) {
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

Widget loginButtons(
    String title, String imagePath, Color titleColor, Color backColor) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 30),
    child: ListTile(
      onTap: _handleSignInWithGoogle(),
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
