
import 'package:http/http.dart' as http;

class API {

  static Future get(String url) async {
    var response = await http.get(url);
    if(response.statusCode == 200){
      print(response.body);
    } else {
      print(response.statusCode.toString()+': Status Code');
      print(response.body);
    }
  }

  static Future post(String url, data, {Map header}) async {
    var response = await http.post(url, headers: header, body: data);
    if(response.statusCode == 200) {
      print(response.body);
    } else {
      print(response.statusCode.toString()+': Status Code');
      print(response.body);
    }
  }
}