
import 'dart:async';
import 'package:flutter/material.dart';

import '../colors.dart';


Future<void> showAlertDialog(
        {required BuildContext context,
        required String title,
        required String description,
        required bool status}) =>
    showDialog<void>(
        context: context,
        barrierDismissible: true,
        builder: (context) => AlertDialog(
              title: Column(
                children: [
                  Image(
                    height: 50,
                    width: 50,
                    image: status
                        ? AssetImage("assets/sucessIcon.png")
                        : AssetImage("assets/failIcon.png"),
                    color: status ? mainButtonColor : Color.fromARGB(255, 17, 0, 255),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Text(
                    title,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
              content: SingleChildScrollView(
                child: Column(
                  children: [
                    Text(
                      description,
                      style: TextStyle(color: Colors.grey),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              actions: <Widget>[],
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20.0))),
            ));
