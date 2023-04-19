import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:together/components/alert_dialog.dart';
import 'package:together/components/appbar.dart';
import 'package:together/components/snack_bar.dart';
import 'package:together/models/user_model.dart';
import 'package:together/screens/auth/signin.dart';
import 'package:together/screens/proflle/pending_events.dart';

import 'package:together/screens/publish_event/publish_event_first_screen.dart';
import 'package:together/screens/proflle/user_details.dart';
import 'package:together/utils/colors.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({Key? key}) : super(key: key);

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  User? user = FirebaseAuth.instance.currentUser;
  ShowSnackBar snackBar = ShowSnackBar();
  bool loading = false;
  bool isAdmin = false;

  @override
  void initState() {
    super.initState();
  }

  Future<void> _signOut(BuildContext context) async {
    try {
      setState(() {
        loading = true;
      });
      await FirebaseAuth.instance.signOut().then((value) {
        Navigator.of(context, rootNavigator: true).pushReplacement(
            MaterialPageRoute(builder: (context) => const SignInScreen()));
      });

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

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: myAppBar(context, false),
          body: loading
              ? const Center(
                  child: SpinKitWave(
                    color: AppColor.primaryColor,
                    size: 40,
                  ),
                )
              : StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('users')
                      .limit(1)
                      .where('user_id', isEqualTo: user?.uid ?? '')
                      .snapshots(),
                  builder: ((context, snapshot) {
                    if (snapshot.hasError) {
                      snackBar.showSnackaBar(
                          context, snapshot.error.toString(), null);
                      return Container();
                    } else if (snapshot.connectionState ==
                        ConnectionState.waiting) {
                      return const SpinKitWave(
                        color: AppColor.primaryColor,
                        size: 40,
                      );
                    } else {
                      List<UserModel> dbUser = (snapshot.data! as QuerySnapshot)
                          .docs
                          .map((doc) => UserModel.fromFirestore(doc))
                          .toList();

                      return SizedBox(
                        width: double.infinity,
                        child: Column(
                          children: <Widget>[
                            Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    clipBehavior: Clip.hardEdge,
                                    height: 140,
                                    margin: const EdgeInsets.symmetric(
                                        vertical: 10.0),
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                    ),
                                    child: CircleAvatar(
                                        backgroundColor: Colors.transparent,
                                        radius: 70,
                                        child: Image.network(user?.photoURL ??
                                            'https://firebasestorage.googleapis.com/v0/b/together-d1575.appspot.com/o/images%2Fpro_pic%2Fuser.jpg?alt=media&token=4086b98c-0d4c-4789-a216-038b89b6a08d')),
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    alignment: Alignment.topLeft,
                                    child: Column(
                                      children: <Widget>[
                                        Text(user?.displayName ?? 'Undefined'),
                                        Text(user?.email ?? 'Undefined'),
                                        ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            primary: AppColor.primaryColor,
                                          ),
                                          onPressed: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        const PublishEventFirstScreen()));
                                          },
                                          child: const Text('Publish an Event'),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            InkWell(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const UserDetailsScreen()));
                                },
                                child: myListTile(
                                    'Change Profile Settings', null)),
                            myListTile('Manage Reminders', () {
                              customDevelopmentShowDialog(context,
                                  'Sorry! This feature is under development and will be available in future updates');
                            }),
                            myListTile('Change Preferred Categories', () {
                              customDevelopmentShowDialog(context,
                                  'Sorry! This feature is under development and will be available in future updates');
                            }),
                            myListTile('Select Home Location', () {
                              customDevelopmentShowDialog(context,
                                  'Sorry! This feature is under development and will be available in future updates');
                            }),
                            dbUser[0].isAdmin
                                ? myListTile('Pending Events', () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const PendingEventScreen()));
                                  })
                                : Container(),
                            myListTile('Logout', () {
                              customShowDialog(context);
                            }),
                          ],
                        ),
                      );
                    }
                  }))),
    );
  }

  Future<dynamic> customShowDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (context, setState) {
              return Dialog(
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                    side: const BorderSide(color: AppColor.primaryColor)),
                //this right here
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        width: 4,
                        color: AppColor.primaryColor,
                      ),
                      color: Colors.white),
                  height: 230,
                  width: double.infinity,
                  child: Column(
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(
                          left: 20,
                          right: 20,
                          top: 20.0,
                        ),
                        child: Text(
                          'Are you sure you want to sign out?',
                          style: TextStyle(fontSize: 25),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const Spacer(),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 20),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: Container(
                                height: 60,
                                padding: const EdgeInsets.only(right: 10),
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      primary: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        side: const BorderSide(
                                            width: 2,
                                            color: AppColor.primaryColor),
                                        borderRadius: BorderRadius.circular(10),
                                      )),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: const Text(
                                    'NO',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                        color: AppColor.primaryColor),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Container(
                                padding: const EdgeInsets.only(left: 10),
                                height: 60,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      primary: AppColor.primaryColor,
                                      shape: RoundedRectangleBorder(
                                        side: const BorderSide(
                                            width: 2,
                                            color: AppColor.primaryColor),
                                        borderRadius: BorderRadius.circular(10),
                                      )),
                                  onPressed: () {
                                    _signOut(context);
                                  },
                                  child: const Text(
                                    'YES',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              );
            },
          );
        });
  }

  InkWell myListTile(String listTitle, var onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(
          vertical: 6.0,
          horizontal: 20.0,
        ),
        child: ListTile(
          contentPadding:
              const EdgeInsets.symmetric(vertical: 2.0, horizontal: 20.0),
          shape: RoundedRectangleBorder(
            side: const BorderSide(
              width: 2,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          title: Text(listTitle),
          trailing: const Icon(Icons.arrow_forward_ios),
        ),
      ),
    );
  }
}
