import 'package:flutter/material.dart';

Widget flash(context, type, message) {
  showDialog(context: context,
      builder:  (context) {
        return Dialog(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Icon(Icons.check_circle_outline,color: type == 1 ? Colors.green : Colors.red,),
                SizedBox(height: 10,),
                Text(message)
              ],
            ),
          ),
        );
      }
  );
}