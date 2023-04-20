
import 'package:flutter/material.dart';
import 'package:together/utils/colors.dart';

Future<dynamic> customDevelopmentShowDialog(BuildContext context, String msg) {
  return showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
              side: const BorderSide(color: AppColor.primaryColor)),
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  width: 4,
                  color: AppColor.primaryColor,
                ),
                color: Colors.white),
            height: 350,
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: [
                const SizedBox(
                  height: 20,
                ),
                Image.asset(
                  'assets/images/repair.png',
                  height: 70,
                  width: 70,
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    left: 20,
                    right: 20,
                    top: 20.0,
                  ),
                  child: Text(
                    msg,
                    style: const TextStyle(fontSize: 18),
                    textAlign: TextAlign.center,
                  ),
                ),
                const Spacer(),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  child: Container(
                    padding: const EdgeInsets.only(left: 10),
                    height: 60,
                    width: 200,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          primary: AppColor.primaryColor,
                          shape: RoundedRectangleBorder(
                            side: const BorderSide(
                                width: 2, color: AppColor.primaryColor),
                            borderRadius: BorderRadius.circular(10),
                          )),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text(
                        'OK',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      });
}
