import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:together/components/appbar.dart';

class CategoryEventsScreen extends StatefulWidget {
  const CategoryEventsScreen({Key? key}) : super(key: key);

  @override
  State<CategoryEventsScreen> createState() => _CategoryEventsScreenState();
}

class _CategoryEventsScreenState extends State<CategoryEventsScreen> {
  List events = [
    ['Bentota Beach Fiesta w', 'assets/images/bentota_Event_Banner.jpg'],
    ['Sanketha Live in Kandy', 'assets/images/Sankyatha.jpg'],
    ['Sarasavi Gee Sara', 'assets/images/sarasavi event.jpg'],
  ];

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: myAppBar(),
      body: Stack(children: [
        BannerImage(width, height),
        Positioned(
          bottom: 0,
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: width,
              height: (height / 10) * 7.1,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                ),
              ),
              child: SizedBox(
                width: width,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
                  child: Column(
                    children: [
                      SearchBar(),
                      Expanded(child: EventsListView(width)),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ]),
    );
  }

  Container EventsListView(double width) {
    return Container(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.vertical,
        itemCount: events.length,
        itemBuilder: ((context, index) => Stack(
              children: [
                Container(
                  margin: EdgeInsets.symmetric(vertical: 8),
                  width: width - 60,
                  height: 150,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: AssetImage(events[index][1]),
                      )),
                ),
                Positioned(
                  bottom: 0,
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 8),
                    width: width - 60,
                    height: 80,
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
                    bottom: 10,
                    left: 30,
                    child: Align(
                      alignment: Alignment.bottomLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Text(
                          events[index][0],
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ))
              ],
            )),
      ),
    );
  }

  Positioned BannerImage(double width, double height) {
    return Positioned(
      top: 0,
      child: Container(
        width: width,
        height: (height / 10) * 2.3,
        decoration: BoxDecoration(
          image: DecorationImage(
              colorFilter: new ColorFilter.mode(
                  Colors.black.withOpacity(0.5), BlendMode.darken),
              image: AssetImage('assets/images/Music.jpg'),
              fit: BoxFit.cover),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 40),
            child: Text('MUSIC',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 50)),
          ),
        ),
      ),
    );
  }

  Widget SearchBar() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 40),
      child: TextField(
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide(color: Color(0xFF142867), width: 1),
          ),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide(color: Color(0xFF142867), width: 1)),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide(color: Color(0xFF142867), width: 1)),
          fillColor: Colors.white.withOpacity(0.7),
          filled: true,
          contentPadding: EdgeInsets.only(left: 20, top: 15, bottom: 15),
          suffixIcon: Icon(
            Icons.tune,
            color: Color(0xFF142867).withOpacity(0.4),
            size: 30,
          ),
          prefixIcon: Icon(
            Icons.search,
            color: Color(0xFF142867).withOpacity(0.4),
            size: 30,
          ),
          hintText: 'Search any Event',
          hintStyle: TextStyle(
            fontSize: 20,
            color: Color(0xFF142867).withOpacity(0.4),
          ),
        ),
        cursorColor: Colors.black,
      ),
    );
  }
}
