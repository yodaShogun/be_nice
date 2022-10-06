import 'dart:convert';

import 'package:http/http.dart' as request;

class Query{

  static Future<dynamic>auth(Map<String, String> formData) async{
    var response = await request.post(Uri.parse("https://fakestoreapi.com/auth/login"), body:formData);
    if(response.statusCode == 200){
      return json.decode(utf8.decode(response.bodyBytes));
    }else{
      return false;
    }
  }

  static Future<dynamic>fetch({required String url}) async{
    var response = await request.get(Uri.parse(url));
    if(response.statusCode == 200){
      return json.decode(utf8.decode(response.bodyBytes));
    }else{
      return false;
    }
  }
  
}