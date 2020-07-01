import 'package:flutter/material.dart';

Widget loading(context, text) {
  showDialog(context: context,
    builder: (context) {
      return Dialog(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Center(
                child: CircularProgressIndicator(
                ),
              )
            ],
          ),
        )
      );
    }
  );
}