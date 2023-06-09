import 'package:flutter/material.dart';

class ShowSnackBar {
  void showSnackaBar(BuildContext context, String msg, Color? color) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        padding: const EdgeInsets.symmetric(vertical: 20),
        backgroundColor: color ?? Colors.red,
        content: Text(
          msg,
          style: const TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
          textAlign: TextAlign.center,
        )));
  }
}
