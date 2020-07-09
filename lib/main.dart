import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_info/device_info.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uree/screen/favourite.dart';
import 'package:uree/screen/home.dart';

//device varibles
String deviceName; //pname
String deviceId; //puid
String deviceBoard; //pboard
String deviceModelId; //pmodel

String currentUser;


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Uree',
      debugShowCheckedModeBanner: false,
      routes: <String, WidgetBuilder>{
        '/favourite': (BuildContext context) => Favourites(),
      },
      theme: ThemeData(
        fontFamily: 'Rubik',
        primarySwatch: Colors.deepPurple,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Launcher(),
    );
  }
}

class Launcher extends StatefulWidget {
  @override
  _LauncherState createState() => _LauncherState();
}

class _LauncherState extends State<Launcher> {
  FirebaseMessaging _messaging = FirebaseMessaging();
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

  String user;

  @override
  void initState() {
    super.initState();
    getDeviceDetails().then((value) {

    });
  }


  Future getDeviceDetails() async {
    SharedPreferences local = await SharedPreferences.getInstance();
    _messaging.getToken().then((token) async {
      if (Platform.isIOS) {
        iosDevice().then((uid) {
          setState(() {
            this.user = "$deviceId-$deviceName";
          });
          Firestore.instance
              .collection('users')
              .where('puid', isEqualTo: deviceId)
              .where('pname', isEqualTo: deviceName)
              .where('pboard', isEqualTo: deviceBoard)
              .where('pmodel', isEqualTo: deviceModelId)
              .getDocuments()
              .then((checking) {
            if (checking.documents.length > 0) {
              //update the token always


              Firestore.instance
                  .collection('users')
                  .document(checking.documents[0].documentID)
                  .updateData({
                'ptoken': token.toString(),
              });
            } else {
              Firestore.instance.collection('users').add({
                'puid': deviceId,
                'pname': deviceName,
                'pboard': deviceBoard,
                'pmodel': deviceModelId,
                'ptoken': token.toString(),
                'time_joined': Timestamp.now(),
                'email': '',
                'id' : "$deviceId-$deviceName"
              });
            }
          });
        });
      } else {
        androidDevice().then((uid) {
          setState(() {
            this.user = "$deviceId-$deviceName";
          });
          Firestore.instance
              .collection('users')
              .where('puid', isEqualTo: deviceId)
              .where('pname', isEqualTo: deviceName)
              .where('pboard', isEqualTo: deviceBoard)
              .where('pmodel', isEqualTo: deviceModelId)
              .getDocuments()
              .then((checking) {

            if (checking.documents.length > 0) {
              //check if blocked


              Firestore.instance
                  .collection('users')
                  .document(checking.documents[0].documentID)
                  .updateData({
                'ptoken': token.toString(),
              });
            } else {

              Firestore.instance.collection('users').add({
                'puid': deviceId,
                'pname': deviceName,
                'pboard': deviceBoard,
                'pmodel': deviceModelId,
                'ptoken': token.toString(),
                'time_joined': Timestamp.now(),
                'email': '',
                'id' : "$deviceId-$deviceName"
              });
            }
          });
        });
      }
    });
    //save uid in cloud and messaging token
  }

  Future<bool> androidDevice() async {
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    deviceName = androidInfo.model;
    deviceId = androidInfo.androidId; //UUID for Android
    deviceModelId = androidInfo.id;
    deviceBoard = androidInfo.board;
    currentUser = "$deviceId-$deviceName";
    return true;
  }

  Future<bool> iosDevice() async {
    IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
    deviceName = iosInfo.name;
    deviceBoard = iosInfo.systemVersion;
    deviceId = iosInfo.identifierForVendor;
    deviceModelId = iosInfo.localizedModel;
    currentUser = "$deviceId-$deviceName";
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Home(this.user);
  }
}



