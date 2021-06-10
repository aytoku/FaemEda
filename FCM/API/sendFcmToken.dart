import 'dart:convert';
import 'package:flutter_app/data/api.dart';
import 'package:flutter_app/data/data.dart';
import 'package:flutter_app/data/globalVariables.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

Future sendFCMToken(String token, String device_id) async {

  var json_request = jsonEncode({
    "token": token,
    'client_device_id': device_id
  });
  var url = '${apiUrl}firebasetoken';
  var response = await http.post(Uri.parse(url), body: json_request, headers: <String, String>{
    'Content-Type': 'application/json; charset=UTF-8',
    'Accept': 'application/json',
    'Source':'ios_client_app_1',
    'Authorization':'Bearer ' + authCodeData.token
  });
  if (response.statusCode == 200) {
    var jsonResponse = convert.jsonDecode(response.body);
  } else {
    print('Request failed with status: ${response.statusCode}.');
  }
  print(response.body);
  return authCodeData;
}