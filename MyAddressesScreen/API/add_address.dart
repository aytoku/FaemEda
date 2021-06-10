import 'dart:convert';
import 'package:flutter_app/Screens/MyAddressesScreen/Model/AddressesModel.dart';
import 'package:flutter_app/data/globalVariables.dart';
import 'package:flutter_app/data/refreshToken.dart';
import 'package:flutter_app/data/api.dart';
import 'package:flutter_app/data/data.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

import '../Model/my_addresses_model.dart';


Future<AddressesModelData> addAddress(String type, bool favorite, DestinationPoints point) async {
  await SendRefreshToken.sendRefreshToken();
  AddressesModelData cityByCoordinates = null;
  var json_request = jsonEncode({
    "type": type,
    "favorite": favorite,
    "point": point,
  });
  var url = '${apiUrl}clients/addresses';
  var response = await http.post(Uri.parse(url), body: json_request, headers: <String, String>{
    'Content-Type': 'application/json; charset=UTF-8',
    'Authorization':'Bearer ' + authCodeData.token
  });
  if (response.statusCode == 200) {
    var jsonResponse = convert.jsonDecode(response.body);
    cityByCoordinates = new AddressesModelData.fromJson(jsonResponse);
  } else {
    print('Request failed with status: ${response.statusCode}.');
  }
  print(response.body);
  return cityByCoordinates;
}