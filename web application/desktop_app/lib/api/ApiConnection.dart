import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:desktop_app/people/Hospital.dart';

class HttpLoader {
  Future<String> httpGET(String userID, String password) async {
    var url = Uri.https(
        'rrne8k3me4.execute-api.ap-northeast-1.amazonaws.com',
        '/prod/passwordlist',
        {'q': '{http}', 'UserID': userID, 'Password': password});

    var response = await http.get(url);

    print(response.body);
    print(response.statusCode);
    log(response.toString());

    if (response.statusCode == 200) {
      print("retrived from AWS" + response.body);
      return response.body;
    } else {
      print("req failed with code{$response.statusCode}");
      return "cant load";
    }
  }

  Future<List<Hospital>> getHospitals() async {
    var url = Uri.https('scrkjt8p76.execute-api.ap-northeast-1.amazonaws.com',
        '/prod/wholehospitallist', {'q': '{http}'});

    var response = await http.get(url);
    var hospitalObjsJson = jsonDecode(response.body)['hospitals'] as List;

    List<Hospital> hospitals =
        hospitalObjsJson.map((h) => Hospital.fromJson(h)).toList();
    return hospitals;
  }
}
