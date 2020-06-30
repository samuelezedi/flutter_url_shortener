import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:uree/screen/favourite.dart';
import 'package:uree/screen/home.dart';

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
        primarySwatch: Colors.deepPurple,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Home(),
    );
  }
}
