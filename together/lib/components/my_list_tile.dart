import 'package:flutter/material.dart';

Container myListTile(String listTitle) {
  return Container(
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
  );
}
