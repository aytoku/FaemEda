import 'package:flutter_app/VersionControl/Model/CurrentVersionModel.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'package:flutter_app/data/api.dart';
import 'package:flutter_app/data/globalVariables.dart';
import 'package:flutter_app/data/data.dart';


Future<CurrentVersionModel> getCurrentVersion() async {
  CurrentVersionModel currentVersion;
  var url = '${apiUrl}versions/last';
  var response = await http.get(Uri.parse(url), headers: <String, String>{
    'Content-Type': 'application/json; charset=UTF-8',
    'Accept': 'application/json',
  });
  print("Version ${response.body}");
  if (response.statusCode == 200) {
    var jsonResponse = convert.jsonDecode(response.body);
    currentVersion = new CurrentVersionModel.fromJson(jsonResponse);
    CheckVersion.fromJson(jsonResponse);
  } else {
    print('Request failed with status: ${response.statusCode}.');
  }
  print(response.body);
  return currentVersion;
}