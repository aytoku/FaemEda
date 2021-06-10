import 'dart:convert';
import 'package:flutter_app/Screens/MyAddressesScreen/Model/AddressesModel.dart';
import 'package:flutter_app/Screens/MyAddressesScreen/Model/NecessaryAddressModel.dart';
import 'package:flutter_app/data/api.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

import '../../../data/data.dart';
import '../../../data/refreshToken.dart';


Future<NecessaryAddressData> getStreet(String name, String city_uuid) async {
  NecessaryAddressData cityByCoordinates = null;
  var json_request = jsonEncode({
    "name": name,
    "city_uuid": city_uuid
  });
  var url = '${apiUrl}addresses';
  var response = await http.post(Uri.parse(url), body: json_request, headers: <String, String>{
    'Content-Type': 'application/json; charset=UTF-8',
  });
  if (response.statusCode == 200) {
    var jsonResponse = convert.jsonDecode(response.body);
    cityByCoordinates = new NecessaryAddressData.fromJson(jsonResponse);
  } else {
    print('Request failed with status: ${response.statusCode}.');
  }
  print(response.body);
  return cityByCoordinates;
}