import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Flash{
  var message;
  var backGroundColor = Colors.black54;
  double fontSize = 13;
  var fontColor = Colors.white;
  var duration = 5;

  var scaffoldKey;

  Flash({this.scaffoldKey});

  removeSnackBar(context) {
//    return Scaffold.of(context).hideCurrentSnackBar();
    scaffoldKey.currentState.removeCurrentSnackBar();
  }


  show(BuildContext context, int type, String message, Color bgc, double fs, Color fc, int dur){
    this.message = message == null ? '' : message;
    this.backGroundColor = bgc == null ? this.backGroundColor : bgc;
    this.fontSize = fs == null ? this.fontSize : fs;
    this.fontColor = fc == null ? this.fontColor : fc;
    this.duration = dur == null ? this.duration : dur;

    if(type == 1){
      //snackbar
      return Scaffold.of(context).showSnackBar(
          SnackBar(
            key: scaffoldKey,
            content: Text(
              this.message,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: this.fontSize,
                color: fontColor,

              ),
            ),
            backgroundColor: this.backGroundColor,
            duration: Duration(seconds: this.duration),
          )
      );
    }

    if(type == 2){
      return Fluttertoast.showToast(
          msg: this.message,
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER,
          backgroundColor: this.backGroundColor,
          textColor: this.fontColor,
          fontSize: this.fontSize
      );
    }

    if(type==3){
      return '';
    }
  }
}