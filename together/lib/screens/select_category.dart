import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class SelectCategoryScreen extends StatefulWidget {
  const SelectCategoryScreen({Key? key}) : super(key: key);

  @override
  State<SelectCategoryScreen> createState() => _SelectCategoryScreenState();
}

class _SelectCategoryScreenState extends State<SelectCategoryScreen> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar:
          PreferredSize(preferredSize: Size.fromHeight(70), child: AppBar()),
      body: GridView.count(
          childAspectRatio: 2 / 3,
          crossAxisCount: 3,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          padding: EdgeInsets.all(10),
          children: [
            Stack(
              children: [
                Container(
                  width: (width - 40) / 3,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: AssetImage('assets/images/art.jpg'),
                      )),
                ),
                Positioned(
                  bottom: 0,
                  child: Container(
                    width: (width - 40) / 3,
                    height: 60,
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
                          ]),
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                )
              ],
            ),
          ]),
    );
  }
}
