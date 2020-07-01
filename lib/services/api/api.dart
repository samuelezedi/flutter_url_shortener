
import 'package:http/http.dart' as http;

class API {

  static Future get(String url) async {
    var response = await http.get(url);
    if(response.statusCode == 200){
      return {'type': 1 , 'message' : 'failed', 'data' :response.body};
    } else {
      print(response.statusCode.toString()+': Status Code');
      return {'type': 2 , 'message' : 'failed', 'data' :response.body};
    }
  }

  static Future post(String url, data, {Map header}) async {
    var response = await http.post(url, headers: header, body: data);
    if(response.statusCode == 200) {
      return {'type': 1 , 'message' : 'failed', 'data' :response.body};
    } else {
      print(response.statusCode.toString()+': Status Code');
      return {'type': 2 , 'message' : 'failed', 'data' :response.body};
    }
  }
}