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

    log(response.body);
    log(response.statusCode.toString());
    log(response.toString());

    if (response.statusCode == 200) {
      log("retrived from AWS${response.body}");
      return response.body;
    } else {
      log("req failed with code{$response.statusCode}");
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

  Future<int> putHospital(String hospitalID, String hospitalName, String lat,
      String long, String contactNo) async {
    var url = Uri.https('scrkjt8p76.execute-api.ap-northeast-1.amazonaws.com',
        '/prod/hospitallist', {
      'q': '{http}',
      'HospitalID': hospitalID,
      'HospitalName': hospitalName,
      'Lattitude': lat,
      'Longitude': long,
      'ContactNo': contactNo
    });

    var response = await http.put(url);
    log(response.body);
    return response.statusCode;
  }

  Future<int> deleteHospital(String hospitalID) async {
    var url = Uri.https('scrkjt8p76.execute-api.ap-northeast-1.amazonaws.com',
        '/prod/hospitallist', {'q': '{http}', 'HospitalID': hospitalID});

    var response = await http.delete(url);
    log(response.body);
    return response.statusCode;
  }

  Future<int> putUser(String userID, String password) async {
    var url = Uri.https(
        'rrne8k3me4.execute-api.ap-northeast-1.amazonaws.com',
        '/prod/passwordlist',
        {'q': '{http}', 'UserID': userID, 'Password': password});

    var response = await http.put(url);
    log(response.body);
    return response.statusCode;
  }

  Future<int> deleteUser(String userID) async {
    var url = Uri.https('rrne8k3me4.execute-api.ap-northeast-1.amazonaws.com',
        '/prod/passwordlist', {'q': '{http}', 'UserID': userID});

    var response = await http.delete(url);
    log(response.body);
    return response.statusCode;
  }
}
