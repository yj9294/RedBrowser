import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppUtil {
  static final shared = AppUtil._internal();

  factory AppUtil() {
    return shared;
  }

  AppUtil._internal();

  var isEnterbackground = false;

  var appID = 414478124;

  static alert(BuildContext context, String message) {
    showDialog(
        context: context,
        builder: (context) {
          return FutureBuilder(
              future: Future.delayed(const Duration(seconds: 2))
                  .then((value) => true),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  Navigator.of(context).pop();
                }
                return CupertinoAlertDialog(
                  content: Text(message),
                );
              });
        });
  }
}