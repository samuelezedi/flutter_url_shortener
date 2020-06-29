import 'package:clipboard_manager/clipboard_manager.dart';
import 'package:feather_icons_flutter/feather_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:uree/utils/config.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _currentIndex = 0;

  _onTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  static const MethodChannel _channel =
  const MethodChannel('clipboard_manager');
  
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _channel.invokeMethod(method);
    ClipboardData().
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
//      appBar: AppBar(
//        elevation: 0,
//        backgroundColor: Colors.white,
//        iconTheme: IconThemeData(color: Colors.grey),
//        title: Text('Uree',style: TextStyle(fontFamily: 'Rubik-Bold', fontWeight: FontWeight.bold,color: Colors.deepPurple),),
//        actions: <Widget>[
//          IconButton(
//            icon: Icon(FeatherIcons.moreHorizontal),
//            onPressed: () {},
//          ),
//
//        ],
//      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 150,
            ),
            TextFormField(
              style: TextStyle(fontSize: 25),
              cursorColor: Colors.deepPurple,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.all(10),
                hintText: 'Long url',
                hintStyle: TextStyle(fontSize: 20, color: Colors.grey[400]),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.deepPurple, width: 2),
                ),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.deepPurple, width: 2)),
                labelStyle: TextStyle(color: Colors.black),
                border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.deepPurple, width: 2)),
              ),
            ),
            SizedBox(
              height: 12,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                RaisedButton(
                  onPressed: () {
                    ClipboardManager.copyToClipBoard('hello').then((value) => {null});
                  },
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0)),
                  padding: const EdgeInsets.all(0.0),
                  child: Ink(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [
                          Color(0xFF5E35B1),
                          Color(0xFF9575CD),
                        ],
                        stops: [0.1, 0.4],
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
                    ),
                    child: Container(
//                      constraints: const BoxConstraints(minWidth: 88.0, minHeight: 36.0),// min sizes for Material buttons
                      alignment: Alignment.center,
                      padding: EdgeInsets.all(10),
                      width: 100,
                      height: 45,
                      child: Text(
                        'PASTE',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
                RaisedButton(
                  onPressed: () {},
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0)),
                  padding: const EdgeInsets.all(0.0),
                  child: Ink(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [
                          Color(0xFF5E35B1),
                          Color(0xFF9575CD),
                        ],
                        stops: [0.1, 0.4],
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
                    ),
                    child: Container(
//                      constraints: const BoxConstraints(minWidth: 88.0, minHeight: 36.0),// min sizes for Material buttons
                      alignment: Alignment.center,
                      padding: EdgeInsets.all(10),
                      width: 100,
                      height: 45,
                      child: Text(
                        'SHORTEN',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          type: BottomNavigationBarType.fixed,
          fixedColor: Colors.deepPurple,
          onTap: _onTapped,
          items: [
            BottomNavigationBarItem(
                title: Text('Home'), icon: Icon(FeatherIcons.home)),
            BottomNavigationBarItem(
                title: Text('Favourite'), icon: Icon(FeatherIcons.star)),
          ]),
    );
  }
}
