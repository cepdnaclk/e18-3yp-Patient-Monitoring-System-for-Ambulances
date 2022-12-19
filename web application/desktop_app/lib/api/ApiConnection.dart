import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;

class HttpLoader{
  Future<String> httpGET(String userID, String password) async{
    var url = Uri.https('rrne8k3me4.execute-api.ap-northeast-1.amazonaws.com', '/prod/passwordlist', {'q': '{http}', 'UserID':userID, 'Password':password});

    var response = await http.get(url);

    print(response.body);
    print(response.statusCode);
    log(response.toString());

    if(response.statusCode == 200){
      print("retrived from AWS"+ response.body);
      return response.body;
    }else{
      print("req failed with code{$response.statusCode}");
      return "cant load";
    }

  }


}