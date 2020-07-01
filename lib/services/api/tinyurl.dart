
import 'package:uree/services/api/api.dart';

class TinyURL {

  static String _baseUrl = 'https://tinyurl.com/api-create.php';

  static Future<dynamic> shorten(String longUrl) async {
    var data = {
      'url' : longUrl
    };
    var resp = await API.post(_baseUrl, data);
    return resp;
  }

}