
import 'dart:convert';

import 'package:uree/services/api/api.dart';

class Bitly {

  static String _baseUrl = 'https://api-ssl.bitly.com/v4/shorten';

  static String _groupUid = 'Bi3vl5dhjVW';

  static String _accessToken = '575c31bb268dc279a9c7f3918fcabee379681629';

  static String _host = 'api-ssl.bitly.com';

  static Future<String> shorten (String longUrl) async {
    var url = "$_baseUrl";
    var headers = {
      'Content-Type' : 'application/json',
      'Authorization' : '$_accessToken',
      'Host' : '$_host',
    };
    var jsonData = {
      'long_url' : longUrl,
      'group_guid' : _groupUid
    };

    API.post(url, jsonEncode(jsonData), headers).then((value) => {

    });
  }



}