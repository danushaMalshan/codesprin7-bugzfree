import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:together/components/appbar.dart';

class SelectCategoryScreen extends StatefulWidget {
  const SelectCategoryScreen({Key? key}) : super(key: key);

  @override
  State<SelectCategoryScreen> createState() => _SelectCategoryScreenState();
}

class _SelectCategoryScreenState extends State<SelectCategoryScreen> {
  var category = [
    ['Art &\nCulture', 'assets/images/art.jpg'],
    ['Music', 'assets/images/james-barbosa-qOWjDs-77cM-unsplash.jpg'],
    ['Education', 'assets/images/istock_000042111248_full.jpg'],
    ['Sports', 'assets/images/sports.jpg'],
    ['Religious & Spirituality', 'assets/images/Religious.jpeg'],
    ['Pet & Animals', 'assets/images/Pet.jpg'],
    ['Hobbies & Passions', 'assets/images/Hobbies.png'],
    ['Dancing', 'assets/images/Dancing.jpg'],
    ['Charity', 'assets/images/Charity.jpg'],
    ['Politics', 'assets/images/Politics.jpg'],
    ['Fitness Workshops', 'assets/images/Fitness.jpg'],
    ['Technology Workshops', 'assets/images/Technology.jpg'],
    ['Consulting', 'assets/images/Consult.jpg'],
    [
      'Volunteering',
      'assets/images/Happy volunteer looking at donation box on a sunny day-1.jpeg'
    ],
    ['Seasonal Events', 'assets/images/NewYear.jpg'],
  ];

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
        appBar: myAppBar(),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 0, bottom: 0),
                child: Text(
                  'SELECT CATEGORIES',
                  style: TextStyle(
                      color: Color(0xFF142867),
                      fontWeight: FontWeight.w600,
                      fontSize: 25),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 15),
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
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        childAspectRatio: 3 / 4,
                        crossAxisSpacing: 15,
                        mainAxisSpacing: 15,
                        crossAxisCount: 3),
                    itemBuilder: (context, index) => CategoryCard(
                        width, category[index][1], category[index][0])),
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

  Stack CategoryCard(double width, String image, String title) {
    return Stack(
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
                stops: [
                  0.2,
                  0.8,
                ],
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [
                  Color(0xFF142867).withOpacity(0.8),
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
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                  textAlign: TextAlign.center,
                ),
              ),
            ))
      ],
    );
  }
}
