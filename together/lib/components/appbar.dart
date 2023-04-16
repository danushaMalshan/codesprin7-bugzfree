import 'package:flutter/material.dart';

PreferredSize myAppBar(BuildContext context, bool isBackButtonAvailable) {
  return PreferredSize(
    preferredSize: const Size.fromHeight(60),
    child: AppBar(
      backgroundColor: Colors.white,
      leading: isBackButtonAvailable
          ? Align(
              alignment: Alignment.center,
              child: IconButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: Icon(
                    Icons.arrow_back_ios_new,
                    color: Colors.black,
                  )))
          : Container(),
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
