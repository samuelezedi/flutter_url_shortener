
import 'package:uree/services/api/api.dart';

class VGd {

  static String _baseUrl = 'https://v.gd/create.php?format=simple';

  static Future<String> shorten(String longUrl)async {
    print(longUrl);
    var baseUrl = "$_baseUrl&url=$longUrl";

    var resp = await API.get(baseUrl);
    return resp;
  }
}