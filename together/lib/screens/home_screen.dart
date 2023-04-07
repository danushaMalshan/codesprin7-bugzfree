import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List trending = [
    ['Music', 'assets/images/james-barbosa-qOWjDs-77cM-unsplash.jpg'],
    ['Politics', 'assets/images/Politics.jpg'],
  ];

  List you_may_like = [
    [
      'Volunteering',
      'assets/images/Happy volunteer looking at donation box on a sunny day-1.jpeg'
    ],
    ['Seasonal Special', 'assets/images/NewYear.jpg'],
  ];

  List preferred = [
    ['Education', 'assets/images/Education Cat.jpg'],
    ['Dancing', 'assets/images/Dancing.jpg'],
  ];

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    
    return Scaffold(
      appBar: myAppBar(),
      body: SizedBox(
        width: width,
        height: height,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SearchBar(),
                TrendingList(width),
                YouMayLikeList(width),
                PreferredList(width)
              ],
            ),
          ),
        ),
      ),
    );
  }

  Column PreferredList(double width) {
    return Column(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 20, left: 0),
                      child: Text(
                        'Preferred',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  Container(
                    width: width,
                    height: (preferred.length) * 216,
                    child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: preferred.length,
                      itemBuilder: ((context, index) => Stack(
                            children: [
                              Container(
                                margin: EdgeInsets.all(8),
                                width: width - 50,
                                height: 200,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    image: DecorationImage(
                                      fit: BoxFit.cover,
                                      image: AssetImage(preferred[index][1]),
                                    )),
                              ),
                              Positioned(
                                bottom: 0,
                                child: Container(
                                  margin: EdgeInsets.all(8),
                                  width: width - 55,
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
                                  bottom: 10,
                                  left: 30,
                                  child: Align(
                                    alignment: Alignment.bottomLeft,
                                    child: Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 10),
                                      child: Text(
                                        preferred[index][0],
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
                  ),
                ],
              );
  }

  Column YouMayLikeList(double width) {
    return Column(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 20, left: 0),
                      child: Text(
                        'You may Like',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  Container(
                    width: width,
                    height: 140,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: you_may_like.length,
                      itemBuilder: ((context, index) => Stack(
                            children: [
                              Container(
                                margin: EdgeInsets.all(8),
                                width: 200,
                                height: 140,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    image: DecorationImage(
                                      fit: BoxFit.cover,
                                      image:
                                          AssetImage(you_may_like[index][1]),
                                    )),
                              ),
                              Positioned(
                                bottom: 0,
                                child: Container(
                                  margin: EdgeInsets.all(8),
                                  width: 200,
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
                                  bottom: 10,
                                  left: 30,
                                  child: Align(
                                    alignment: Alignment.bottomLeft,
                                    child: Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 10),
                                      child: Text(
                                        you_may_like[index][0],
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
                  ),
                ],
              );
  }

  Column TrendingList(double width) {
    return Column(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 20, left: 0),
                      child: Text(
                        'Trending',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  Container(
                    width: width,
                    height: 180,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: trending.length,
                      itemBuilder: ((context, index) => Stack(
                            children: [
                              Container(
                                margin: EdgeInsets.all(8),
                                width: 230,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    image: DecorationImage(
                                      fit: BoxFit.cover,
                                      image: AssetImage(trending[index][1]),
                                    )),
                              ),
                              Positioned(
                                bottom: 0,
                                child: Container(
                                  margin: EdgeInsets.all(8),
                                  width: 230,
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
                                  bottom: 10,
                                  left: 30,
                                  child: Align(
                                    alignment: Alignment.bottomLeft,
                                    child: Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 10),
                                      child: Text(
                                        trending[index][0],
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
                  ),
                ],
              );
  }

  TextField SearchBar() {
    return TextField(
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
    );
  }
}

//AppBar goes here...

PreferredSize myAppBar() {
  return PreferredSize(
    preferredSize: const Size.fromHeight(60),
    child: AppBar(
      backgroundColor: Colors.white,
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
      actions: const [
        SizedBox(width: 50),
      ],
    ),
  );
}

//TextStyles for home page goes here...

TextStyle homeTextStyle() {
  return const TextStyle(
    fontSize: 25.0,
    fontWeight: FontWeight.bold,
  );
}
