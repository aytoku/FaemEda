import 'dart:convert';
import 'package:flutter_app/Screens/AuthScreen/Model/Auth.dart';
import 'package:flutter_app/data/api.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

Future<AuthData> loadAuthData(String device_id, String phone) async {
  AuthData authData = null;
  var json_request = jsonEncode({
    "device_id": device_id,
    "phone": phone,
  });
  var url = '${authApiUrl}clients/new';
  var response = await http.post(Uri.parse(url), body: json_request, headers: <String, String>{
    'Content-Type': 'application/json; charset=UTF-8',
    "Source": "eda/faem"
  });
  print(response.body);
  try{
    var jsonResponse = convert.jsonDecode(response.body);
    authData = new AuthData.fromJson(jsonResponse);
  }catch(e){
    return null;
  }

  return authData;
}