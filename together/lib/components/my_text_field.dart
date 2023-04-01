import 'package:flutter/material.dart';

Widget myTextField(IconData icon, String eventName) {
  return Container(
    margin: const EdgeInsets.symmetric(horizontal: 30.0,vertical: 10.0),
    child: TextField(
      decoration: InputDecoration(
        labelText: eventName,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        icon: Icon(
          icon,
          color: Color(0xff142867),
        ),
      ),
    ),
  );
}
