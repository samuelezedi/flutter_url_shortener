
import 'package:flutter/material.dart';

class Config {
  LinearGradient appGradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [
      Color(0xFF5E35B1),
      Color(0xFF9575CD),
    ],
    stops: [0.1, 0.4],
  );

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
}