
import 'package:uree/services/api/api.dart';

class isGd {

  static String _baseUrl = 'https://is.gd/create.php?format=simple';

  static Future<String> shorten(String longUrl) {
    print(longUrl);
    var baseUrl = "$_baseUrl&url=$longUrl";

    API.get(baseUrl).then((value) => {

    });

  }
}