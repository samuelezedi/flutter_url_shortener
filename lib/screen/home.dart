
import 'package:clipboard/clipboard.dart';
import 'package:feather_icons_flutter/feather_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uree/services/api/bitly.dart';
import 'package:uree/services/api/isgd.dart';
import 'package:uree/services/api/tinyurl.dart';
import 'package:uree/services/api/vgd.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TextEditingController longUrl = TextEditingController();
  TextEditingController api = TextEditingController();

  int _currentIndex = 0;

  _onTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  getUserData() async {
    SharedPreferences local = await SharedPreferences.getInstance();
    if(local.getString('user_api_option') != null){
      setState(() {
        api.text = local.getString('user_api_option');
      });
    }
  }

  saveUserApiOption(value) async {
    SharedPreferences local = await SharedPreferences.getInstance();
    local.setString('user_api_option', value);
  }
  
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      body: Container(
        child: Column(
          children: <Widget>[
            Container(
              height: 350,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    Color(0xFF5E35B1),
                    Color(0xFF9575CD),
                  ],
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(12),
                  bottomRight: Radius.circular(12)
                )
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: 80,
                    ),
                    Row(
                      children: <Widget>[
                        Text('Url Shortener',style: TextStyle(fontFamily: 'Rubik Bold',color: Colors.white,fontSize: 25),),
                      ],
                    ),
                    SizedBox(height: 30,),
                    TextFormField(
                      onChanged: (value){

                      },
                      readOnly: true,
                      controller: api,
                      style: TextStyle(fontSize: 25,color: Colors.grey[700]),
                      cursorColor: Colors.deepPurple,
                      decoration: InputDecoration(
                        suffixIcon: IconButton(
                          onPressed: (){
                            selectApiDialog(context);
                          },
                          icon: Icon(Icons.keyboard_arrow_down),
                        ),
                        fillColor: Colors.white,
                        filled: true,
                        contentPadding: EdgeInsets.all(10),
                        hintText: 'Api',
                        hintStyle: TextStyle(fontSize: 20, color: Colors.grey[400]),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white, width: 2),
                        ),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white, width: 2)),
                        labelStyle: TextStyle(color: Colors.black),
                        border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white, width: 2)),
                      ),
                    ),
                    SizedBox(
                      height: 12,
                    ),
                    TextFormField(
                      onChanged: (value){

                      },
                      controller: longUrl,
                      style: TextStyle(fontSize: 25,color: Colors.grey[700]),
                      cursorColor: Colors.deepPurple,
                      decoration: InputDecoration(
                        fillColor: Colors.white,
                        filled: true,
                        contentPadding: EdgeInsets.all(10),
                        hintText: 'Long url',
                        hintStyle: TextStyle(fontSize: 20, color: Colors.grey[400]),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white, width: 2),
                        ),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white, width: 2)),
                        labelStyle: TextStyle(color: Colors.black),
                        border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white, width: 2)),
                      ),
                    ),
                    SizedBox(
                      height: 12,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        RaisedButton(
                          onPressed: () async {
                            var data = await FlutterClipboard.paste();
                            longUrl.text = data.toString();
                          },
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5.0)),
                          padding: const EdgeInsets.all(0.0),
                          child: Ink(
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.all(Radius.circular(5.0)),
                            ),
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.white),
                                borderRadius: BorderRadius.circular(5.0),
                              ),
//                      constraints: const BoxConstraints(minWidth: 88.0, minHeight: 36.0),// min sizes for Material buttons
                              alignment: Alignment.center,
                              padding: EdgeInsets.all(10),
                              width: 100,
                              height: 45,
                              child: Text(
                                'PASTE',
                                textAlign: TextAlign.center,
                                style: TextStyle(color: Colors.deepPurple),
                              ),
                            ),
                          ),
                        ),
                        RaisedButton(
                          onPressed: () {
                            callApi();
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
                              ),
                              borderRadius: BorderRadius.all(Radius.circular(5.0)),
                            ),
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.white),
                                  borderRadius: BorderRadius.circular(5.0),
                              ),
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
            ),

//            Expanded(
//              child: ListView.builder(
//
//              ),
//            )

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
                title: Text('More'), icon: Icon(FeatherIcons.menu)),
          ]),
    );
  }

  void selectApiDialog(BuildContext context) {
    showDialog(context: context,
      builder: (context){
        return AnimatedContainer(
          duration: Duration(seconds: 2),
          curve: Curves.ease,
          child: Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15)
            ),
            child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  InkWell(
                    onTap: (){
                      setState(() {
                        api.text = 'Bit.ly';
                      });
                      //save user option to session
                      saveUserApiOption('Bit.ly');
                      Navigator.pop(context);
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text('Bit.ly'),
                        ],
                      ),
                    ),
                  ),
                  Divider(height: 1,),
                  InkWell(
                    onTap: (){
                      setState(() {
                        api.text = 'Tinyurl.com';
                      });
                      //save user option to session
                      saveUserApiOption('Tinyurl.com');
                      Navigator.pop(context);
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text('Tinyurl.com'),
                        ],
                      ),
                    ),
                  ),
                  Divider(height: 1,),
                  InkWell(
                    onTap: (){
                      setState(() {
                        api.text = 'shorte.st';
                      });
                      //save user option to session
                      saveUserApiOption('Shorte.st');
                      Navigator.pop(context);
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text('shorte.st'),
                        ],
                      ),
                    ),
                  ),
                  Divider(height: 1,),
                  InkWell(
                    onTap: (){
                      setState(() {
                        api.text = 'is.gd';
                      });
                      //save user option to session
                      saveUserApiOption('is.gd');
                      Navigator.pop(context);
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text('is.gd'),
                        ],
                      ),
                    ),
                  ),
                  Divider(height: 1,),
                  InkWell(
                    onTap: (){
                      setState(() {
                        api.text = 'v.gd';
                      });
                      //save user option to session
                      saveUserApiOption('v.gd');
                      Navigator.pop(context);
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text('v.gd'),
                        ],
                      ),
                    ),
                  ),
                ],

            ),
          ),
        );
      }
    );
  }

  callApi() {
    switch(api.text.toString()) {
      case 'Bit.ly': {
        Bitly.shorten(longUrl.text);
      }
      break;

      case 'Tinyurl.com': {
        TinyURL.shorten(longUrl.text);
      }
      break;

      case 'is.gd': {
        IsGd.shorten(longUrl.text);
      }
      break;

      case 'v.gd': {
        VGd.shorten(longUrl.text);
      }
      break;
      case 'shorte.st': {

      }
      break;

      default: { print("Invalid choice"); }
      break;

    }
  }
}
