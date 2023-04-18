import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:together/components/appbar.dart';
import 'package:together/components/bottom_navigation_bar.dart';
import 'package:together/components/snack_bar.dart';
import 'package:together/models/event_model.dart';
import 'package:together/models/user_model.dart';
import 'package:together/screens/auth/signin.dart';
import 'package:together/screens/pending_events.dart';
import 'package:together/screens/publish_event.dart';
import 'package:together/screens/publish_event/publish_event_first_screen.dart';
import 'package:together/screens/user_details.dart';
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
      await FirebaseAuth.instance.signOut();
      Navigator.of(context, rootNavigator: true).pushReplacement(
          MaterialPageRoute(builder: (context) => new SignInScreen()));
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
      print(e);
      setState(() {
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: myAppBar(context, true),
          body: loading
              ? Center(
                  child: SpinKitWave(
                    color: AppColor.primaryColor,
                    size: 50,
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
                      return SpinKitCircle(
                        color: AppColor.primaryColor,
                        size: 30,
                      );
                    } else {
                      List<UserModel> _dbUser =
                          (snapshot.data! as QuerySnapshot)
                              .docs
                              .map((doc) => UserModel.fromFirestore(doc))
                              .toList();
                      print(user?.uid);
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
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                    ),
                                    child: CircleAvatar(
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
                                                        PublishEventFirstScreen()));
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
                                              UserDetailsScreen()));
                                },
                                child: myListTile(
                                    'Change Profile Settings', null)),
                            myListTile('Manage Reminders', null),
                            myListTile('Change Preferred Categories', null),
                            myListTile('Select Home Location', null),
                            _dbUser[0].is_admin
                                ? myListTile('Pending Events', () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                PendingEventScreen()));
                                  })
                                : Container(),
                            myListTile('Logout', () {
                              _signOut(context);
                            }),
                          ],
                        ),
                      );
                    }
                  }))),
    );
  }

  InkWell myListTile(String listTitle, var onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(
          vertical: 6.0,
          horizontal: 20.0,
        ),
        child: ListTile(
          contentPadding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 20.0),
          shape: RoundedRectangleBorder(
            side: BorderSide(
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
