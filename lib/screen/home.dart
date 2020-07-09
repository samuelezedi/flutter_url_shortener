import 'dart:convert';
import 'dart:io';

import 'package:clipboard/clipboard.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:feather_icons_flutter/feather_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uree/models/links_model.dart';
import 'package:uree/services/api/bitly.dart';
import 'package:uree/services/api/isgd.dart';
import 'package:uree/services/api/tinyurl.dart';
import 'package:uree/services/api/vgd.dart';
import 'package:uree/utils/toast.dart';
import 'package:uree/widget/flash.dart';
import 'package:uree/widget/loading.dart';
import 'package:url_launcher/url_launcher.dart';

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
    if (local.getString('user_api_option') != null) {
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
              height: 320,
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
                      bottomRight: Radius.circular(12))),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: 60,
                    ),
                    Row(
                      children: <Widget>[
                        Text(
                          'Url Shortener',
                          style: TextStyle(
                              fontFamily: 'Rubik Bold',
                              color: Colors.white,
                              fontSize: 25),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    textFieldApi(context),
                    SizedBox(
                      height: 12,
                    ),
                    textFieldLongURL(),
                    SizedBox(
                      height: 12,
                    ),
                    buildButtons(context)
                  ],
                ),
              ),
            ),
            Expanded(
              child: StreamBuilder(
                  stream: Firestore.instance.collection('links').orderBy('date_created', descending: true).snapshots(),
                  builder: (context, snapshot) {
                    if(snapshot.hasData){
                      if(snapshot.data.documents.length > 0){
                        return ListView.builder(
                          itemCount: snapshot.data.documents.length,
                            itemBuilder: (context, index){
                              var data = snapshot.data.documents[index];
                              return Card(
                                child:
                                      Padding(
                                        padding: const EdgeInsets.only(top:12.0,left: 12.0,right: 12.0),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Padding(
                                              padding: const EdgeInsets.symmetric(vertical: 8.0),
                                              child: Text(data['short'],style: TextStyle(fontSize: 17,fontWeight: FontWeight.bold),),
                                            ),
                                            Container(width: MediaQuery.of(context).size.width * 0.80, child: Text(data['long'],overflow: TextOverflow.ellipsis,)),
                                            Divider(height: 1,),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: <Widget>[
                                                InkWell(onTap: (){
                                                  Share.share(data['short']);
                                                },child: Padding(
                                                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                                                  child: Icon(FeatherIcons.share2),

                                                )),
                                                InkWell(onTap:(){
                                                  FlutterClipboard.copy(data['short']);
                                                }, child: Padding(
                                                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                                                  child: Icon(FeatherIcons.copy),
                                                )),
                                                InkWell(onTap:(){
                                                  launch(data['short']);
                                                }, child: Padding(
                                                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                                                  child: Icon(FeatherIcons.link),
                                                )),
                                                InkWell(onTap:(){
                                                  Firestore.instance.collection('links').document(data.documentID).delete();
                                                }, child: Padding(
                                                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                                                  child: Icon(FeatherIcons.trash2),
                                                )),
                                                InkWell(onTap:(){
                                                  showDialog(context: context,
                                                    builder: (context){
                                                    return Dialog(
                                                      shape: RoundedRectangleBorder(
                                                        borderRadius: BorderRadius.circular(12)
                                                      ),
                                                      child: Padding(
                                                        padding: const EdgeInsets.all(12.0),
                                                        child: Column(
                                                          mainAxisSize: MainAxisSize.min,
                                                          children: <Widget>[
                                                            Container(
                                                              width: 150,
                                                              height: 150,
                                                              decoration: BoxDecoration(
                                                                image: DecorationImage(
                                                                  image: NetworkImage('https://api.qrserver.com/v1/create-qr-code/?size=150x150&data='+ data['short']),
                                                                  fit: BoxFit.cover,
                                                                )
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                    );
                                                    }

                                                  );
                                                }, child: Padding(
                                                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                                                  child: Text('Qr Code'),
                                                ))
                                              ],
                                            )
                                          ],
                                        ),
                                      ),

                              );
                        });
                      } else {
                        return Center(
                          child: Text('No Short Links created yet!',style: TextStyle(fontWeight: FontWeight.bold),),
                        );
                      }
                    } else {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  }),
            )
          ],
        ),
      ),
    );
  }

  buildButtons(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        RaisedButton(
          onPressed: () async {
            var data = await FlutterClipboard.paste();
            longUrl.text = data.toString();
          },
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
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
            callApi(context);
          },
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
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
                'SHORTEN',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.deepPurple),
              ),
            ),
          ),
        )
      ],
    );
  }

  TextFormField textFieldLongURL() {
    return TextFormField(
      onChanged: (value) {},
      controller: longUrl,
      style: TextStyle(fontSize: 22, color: Colors.grey[700]),
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
    );
  }

  TextFormField textFieldApi(BuildContext context) {
    return TextFormField(
      onChanged: (value) {},
      readOnly: true,
      controller: api,
      style: TextStyle(fontSize: 21, color: Colors.grey[700]),
      cursorColor: Colors.deepPurple,
      decoration: InputDecoration(
        suffixIcon: IconButton(
          onPressed: () {
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
    );
  }

  void selectApiDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return AnimatedContainer(
            duration: Duration(seconds: 2),
            curve: Curves.ease,
            child: Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  InkWell(
                    onTap: () {
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
                  Divider(
                    height: 1,
                  ),
                  InkWell(
                    onTap: () {
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
                  Divider(
                    height: 1,
                  ),
                  InkWell(
                    onTap: () {
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
                  Divider(
                    height: 1,
                  ),
                  InkWell(
                    onTap: () {
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
        });
  }

  callApi(context) {
    loading(context, 'Shortening...');
    switch (api.text.toString()) {
      case 'Bit.ly':
        {
          Bitly.shorten(longUrl.text).then((value) {
            Navigator.pop(context);
            if (value['type'] == 1) {
              var data = jsonDecode(value['data']);
              completedShortenen(context, data['link']);
              saveToDatabase('bit.ly', longUrl.text, data['link']);
            } else {
              flash(context, 2, value['message']);
            }
          });
        }
        break;

      case 'Tinyurl.com':
        {
          TinyURL.shorten(longUrl.text).then((value) {
            Navigator.pop(context);
            if (value['type'] == 1) {
              completedShortenen(context, value['data']);
              saveToDatabase('tinyurl.com', longUrl.text, value['data']);
            } else {
              flash(context, 2, value['message']);
            }
          });
        }
        break;

      case 'is.gd':
        {
          IsGd.shorten(longUrl.text).then((value) {
            Navigator.pop(context);
            if (value['type'] == 1) {
              completedShortenen(context, value['data']);
              saveToDatabase('is.gd', longUrl.text, value['data']);
            } else {
              flash(context, 2, value['message']);
            }
          });
        }
        break;

      case 'v.gd':
        {
          VGd.shorten(longUrl.text).then((value) {
            Navigator.pop(context);
            if (value['type'] == 1) {
              completedShortenen(context, value['data']);
              saveToDatabase('v.gd', longUrl.text, value['data']);
            } else {
              flash(context, 2, value['message']);
            }
          });
        }
        break;
      case 'shorte.st':
        {}
        break;

      default:
        {
          print("Invalid choice");
        }
        break;
    }
  }

  void completedShortenen(context, link) {
    showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                    'Shortened',
                    style: TextStyle(color: Colors.green),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: InkWell(
                    onTap: () {
                      launch(link);
                    },
                    child: Text(
                      link,
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ),
                ),
                Divider(
                  height: 1,
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: InkWell(
                          onTap: () {
                            FlutterClipboard.copy(link).then((value) {
                              Flash().show(context, 2, 'Copied', Colors.green,
                                  16, null, null);
                            });
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10.0),
                            child: Text(
                              'Copy',
                              textAlign: TextAlign.center,
                            ),
                          )),
                    ),
                    Container(
                      width: 0.5,
                      color: Colors.grey[300],
                      height: 35,
                    ),
                    Expanded(
                      child: InkWell(
                          onTap: () {
                            Share.share(link);
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10.0),
                            child: Text(
                              'Share',
                              textAlign: TextAlign.center,
                            ),
                          )),
                    )
                  ],
                ),
              ],
            ),
          );
        });
  }

  saveToDatabase(api, long, short) {
    Links links = Links(
        api: api, long: long, short: short, created: Timestamp.now());
    Firestore.instance.collection('links').add(links.toMap());
  }
}
