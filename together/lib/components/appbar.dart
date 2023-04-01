import 'package:flutter/material.dart';

PreferredSizeWidget myAppBar(){
  return AppBar(
    backgroundColor: Colors.white,
    leading: const Icon(
      Icons.arrow_back_ios_new,
      color: Colors.black,
    ),
    title: const Center(
      child: Image(
        image: AssetImage(
          'Assets/Images/AppBar_Logo.png',
        ),
        height: 150,
        width: 140,
      ),
    ),
    actions: const [
      SizedBox(width: 50),
    ],
  );
}