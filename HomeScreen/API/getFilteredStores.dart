import 'package:flutter_app/Screens/HomeScreen/Model/FilteredStores.dart';
import 'package:flutter_app/data/api.dart';
import 'package:flutter_app/data/globalVariables.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;


Future<FilteredStoresData> getFilteredStores(String city_uuid, bool only_parents) async {
  FilteredStoresData filteredStores = null;
  var url = '${apiUrl}stores/filter?city_uuid=${city_uuid}&only_parents=$only_parents';
  var response = await http.get(Uri.parse(url), headers: <String, String>{
    'Content-Type': 'application/json; charset=UTF-8',
    'Accept': 'application/json',
    "ServiceName": 'faem_food',
    "Application": header,
  });
  if (response.statusCode == 200) {
    var jsonResponse = convert.jsonDecode(response.body);
    filteredStores = new FilteredStoresData.fromJson(jsonResponse);
  } else {
    print('Request failed with status: ${response.statusCode}.');
  }
  print("HOME" + response.body);
  return filteredStores;
}