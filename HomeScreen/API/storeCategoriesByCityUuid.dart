import 'package:flutter_app/data/globalVariables.dart';
import 'package:flutter_app/data/refreshToken.dart';
import 'package:flutter_app/data/api.dart';
import 'package:flutter_app/data/data.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

import '../../CityScreen/Model/StoreCategoriesByCItyUuid.dart';


Future<StoreCategoriesByCItyUuid> getCategoriesByCityUuid() async {
  await SendRefreshToken.sendRefreshToken();
  StoreCategoriesByCItyUuid storeCategoriesByCityUuid = null;
  var url = '${apiUrl}stores/categories';
  var response = await http.get(Uri.parse(url), headers: <String, String>{
    'Content-Type': 'application/json; charset=UTF-8',
    'Accept': 'application/json',
    'Source':'ios_client_app_1',
    "ServiceName": 'faem_food',
    'Authorization':'Bearer ' + authCodeData.token
  });
  if (response.statusCode == 200) {
    var jsonResponse = convert.jsonDecode(response.body);
    storeCategoriesByCityUuid = new StoreCategoriesByCItyUuid.fromJson(jsonResponse);
  } else {
    print('Request failed with status: ${response.statusCode}.');
  }
  print(response.body);
  return storeCategoriesByCityUuid;
}