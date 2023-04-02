import 'package:flutter/material.dart';

PreferredSize myAppBar() {
  return PreferredSize(
      preferredSize: Size.fromHeight(60),
      child: AppBar(
        backgroundColor: Colors.white,
        leading: Align(
          alignment: Alignment.center,
          child: const Icon(
            Icons.arrow_back_ios_new,
            color: Colors.black,
          ),
        ),
        title: Align(
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
      ));
}
