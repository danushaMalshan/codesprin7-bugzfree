import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:together/components/snack_bar.dart';
import 'package:together/utils/colors.dart';

class SelectCategoryScreen extends StatefulWidget {
  const SelectCategoryScreen({Key? key}) : super(key: key);

  @override
  State<SelectCategoryScreen> createState() => _SelectCategoryScreenState();
}

class _SelectCategoryScreenState extends State<SelectCategoryScreen> {
  ShowSnackBar snackBar = ShowSnackBar();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  User? user = FirebaseAuth.instance.currentUser;
  bool loading = false;
  List<String> selectedCategories = [];
  List<dynamic> category = [
    ['Art &\nCulture', 'assets/images/art.jpg', 1, false],
    ['Music', 'assets/images/james-barbosa-qOWjDs-77cM-unsplash.jpg', 2, false],
    ['Education', 'assets/images/istock_000042111248_full.jpg', 3, false],
    ['Sports', 'assets/images/sports.jpg', 4, false],
    ['Religious & Spirituality', 'assets/images/Religious.jpeg', 5, false],
    ['Pet & Animals', 'assets/images/Pet.jpg', 6, false],
    ['Hobbies & Passions', 'assets/images/Hobbies.png', 7, false],
    ['Dancing', 'assets/images/Dancing.jpg', 8, false],
    ['Charity', 'assets/images/Charity.jpg', 9, false],
    ['Politics', 'assets/images/Politics.jpg', 10, false],
    ['Fitness Workshops', 'assets/images/Fitness.jpg', 11, false],
    ['Technology Workshops', 'assets/images/Technology.jpg', 12, false],
    ['Consulting', 'assets/images/Consult.jpg', 13, false],
    [
      'Volunteering',
      'assets/images/Happy volunteer looking at donation box on a sunny day-1.jpeg',
      14,
      false
    ],
    ['Seasonal Events', 'assets/images/NewYear.jpg', 15, false],
  ];

  Future<void> _addSelectedCategories() async {
    for (int i = 0; i < category.length; i++) {
      if (category[i][3]) {
        selectedCategories.add(category[i][2]);
        DocumentReference docRef = FirebaseFirestore.instance
            .collection('categories')
            .doc('${category[i][2]}');
        docRef.update({'value': FieldValue.increment(1)});
      }
    }
    try {
      setState(() {
        loading = true;
      });

      await _firestore
          .collection('users')
          .doc(user!.uid)
          .update({'categories': selectedCategories}).then((value) {
        Navigator.pushReplacementNamed(context, '/home');
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
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: AppBar(
            backgroundColor: Colors.white,
            leading: const Align(
              alignment: Alignment.center,
              child: Icon(
                Icons.arrow_back_ios_new,
                color: Colors.black,
              ),
            ),
            title: const Align(
              alignment: Alignment.center,
              child: Image(
                image: AssetImage(
                  'assets/images/Logo & Name__1.png',
                ),
                height: 40,
                // width: 140,
              ),
            ),
            actions: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                child: SizedBox(
                  width: 80,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: AppColor.primaryColor,
                    ),
                    onPressed: () async {
                      await _addSelectedCategories();
                    },
                    child: const Text(
                      'Done',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.only(top: 0, bottom: 0),
                child: Text(
                  'SELECT CATEGORIES',
                  style: TextStyle(
                      color: AppColor.primaryColor,
                      fontWeight: FontWeight.w600,
                      fontSize: 25),
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(bottom: 15),
                child: Text(
                  'Please select a minimum of 3 categories',
                  style: TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.normal,
                      fontSize: 20),
                ),
              ),
              Expanded(
                child: GridView.builder(
                    itemCount: category.length,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        childAspectRatio: 3 / 4,
                        crossAxisSpacing: 15,
                        mainAxisSpacing: 15,
                        crossAxisCount: 3),
                    itemBuilder: (context, index) => categoryCard(
                            width, category[index][1], category[index][0], () {
                          setState(() {
                            if (category[index][3] == true) {
                              category[index][3] = false;
                            } else {
                              category[index][3] = true;
                            }
                          });
                        }, category[index][3])),
              ),
            ],
          ),
        )
        //  GridView.count(
        // childAspectRatio: 2 / 3,
        // crossAxisCount: 3,
        // crossAxisSpacing: 10,
        // mainAxisSpacing: 10,
        // padding: EdgeInsets.all(10),
        //     children: [
        //       CategoryCard(width),
        //     ]),
        );
  }

  InkWell categoryCard(
      double width, String image, String title, var onTap, bool tapped) {
    return InkWell(
      onTap: onTap,
      child: Stack(
        children: [
          Container(
            width: (width - 60) / 3,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: AssetImage(image),
                )),
          ),
          Positioned(
            bottom: 0,
            child: Container(
              width: (width - 70) / 3,
              height: 100,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  stops: const [
                    0.2,
                    0.8,
                  ],
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    tapped
                        ? Colors.black.withOpacity(0.8)
                        : AppColor.primaryColor.withOpacity(0.8),
                    Colors.white.withOpacity(0.1),
                  ],
                ),
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
          Positioned.fill(
              bottom: 0,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Text(
                    title,
                    style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                ),
              ))
        ],
      ),
    );
  }
}
