
import 'package:uree/services/api/api.dart';

class TinyURL {

  static String _baseUrl = 'https://tinyurl.com/api-create.php';

  static Future<String> shorten(String longUrl) async {
    var data = {
      'url' : longUrl
    };
    API.post(_baseUrl, data).then((value) => {

    });
  }

}