
import 'package:uree/services/api/api.dart';

class isGd {

  static String _baseUrl = 'https://is.gd/create.php';

  static Future<String> shorten(String longUrl) {
    var data = {
      'url' : longUrl
    };
    API.post(_baseUrl, data).then((value) => {

    });
  }
}