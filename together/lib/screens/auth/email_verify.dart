import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:together/components/snack_bar.dart';
import 'package:together/global.dart';
import 'package:together/screens/select_category.dart';
import 'package:together/utils/colors.dart';

class EmailVerifyScreen extends StatefulWidget {
  const EmailVerifyScreen({Key? key, required this.name, required this.email})
      : super(key: key);
  final String name;
  final String email;
  @override
  State<EmailVerifyScreen> createState() => _EmailVerifyScreenState();
}

class _EmailVerifyScreenState extends State<EmailVerifyScreen> {
  bool isEmailVerified = false;
  Timer? timer;
  DateTime? _lastPressed;
  bool isLoading = true;
  User? user = FirebaseAuth.instance.currentUser;
  
  @override
  void initState() {
    super.initState();
    isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    if (!isEmailVerified) {
      sendVerificationEmail();

      timer = Timer.periodic(const Duration(seconds: 3), (timer) {
        checkEmailVerified();
      });
    } else {
      Navigator.pushNamedAndRemoveUntil(
        context,
        '/select_category',
        (route) => false,
      );
    }
  }

  Future checkEmailVerified() async {
    await FirebaseAuth.instance.currentUser!.reload();
    setState(() {
      isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    });

    if (isEmailVerified) {
      timer?.cancel();
      navigatorKey.currentState?.pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const SelectCategoryScreen()),
          (route) => false);
    }
  }

  @override
  void dispose() async {
    super.dispose();
    timer?.cancel();
  }

  Future sendVerificationEmail() async {
    try {
      final user = FirebaseAuth.instance.currentUser!;
      await user.sendEmailVerification();
    } catch (e) {
      ShowSnackBar showSnackBar = ShowSnackBar();
      showSnackBar.showSnackaBar(context, e.toString(), null);
    }
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
          body: SafeArea(
            child: SizedBox(
              height: height,
              width: width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: Image.asset(
                      'assets/images/verify_email.jpg',
                      filterQuality: FilterQuality.low,
                    ),
                  ),
                  const Text(
                    'Email Verfication',
                    style: TextStyle(
                        color: AppColor.primaryColor,
                        fontSize: 37,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: Text(
                      'Hi! ${widget.name}, We sent confirmation email to: \n${widget.email}\n Check your email and click on the confirmation link to continue.',
                      style: TextStyle(
                        color: AppColor.primaryColor.withOpacity(0.7),
                        fontSize: 20,
                        fontWeight: FontWeight.normal,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: SizedBox(
                      height: 60,
                      width: (width * 2) / 3,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: AppColor.primaryColor,
                            shape: RoundedRectangleBorder(
                              side: const BorderSide(
                                  width: 2, color: AppColor.primaryColor),
                              borderRadius: BorderRadius.circular(10),
                            )),
                        onPressed: () {
                          sendVerificationEmail();
                        },
                        child: const Text(
                          'Resend',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 25),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: SizedBox(
                      height: 60,
                      width: (width * 2) / 3,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: Colors.white,
                            shape: RoundedRectangleBorder(
                              side: const BorderSide(
                                  width: 2, color: AppColor.primaryColor),
                              borderRadius: BorderRadius.circular(10),
                            )),
                        onPressed: () async {
                          
                          if (user != null) {
                            await user!.delete();
                            Navigator.pop(context);
                          }
                        },
                        child: const Text(
                          'Cancel',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 25,
                              color: AppColor.primaryColor),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
