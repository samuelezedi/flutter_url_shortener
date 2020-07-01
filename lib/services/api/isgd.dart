
import 'package:uree/services/api/api.dart';

class IsGd {

  static String _baseUrl = 'https://is.gd/create.php?format=simple';

  static Future<dynamic> shorten(String longUrl) async {
    print(longUrl);
    var baseUrl = "$_baseUrl&url=$longUrl";

    var resp = API.get(baseUrl);
    return resp;

  }
}