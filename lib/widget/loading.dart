import 'package:flutter/material.dart';

Widget loading(context, text) {
  showDialog(context: context,
    builder: (context) {
      return Center(
        child: CircularProgressIndicator(
        ),
      );
    }
  );
}