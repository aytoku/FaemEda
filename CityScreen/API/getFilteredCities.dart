import 'package:flutter_app/Screens/CityScreen/Model/FilteredCities.dart';
import 'package:flutter_app/data/api.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;


Future<FilteredCitiesData> getFilteredCities() async {
  FilteredCitiesData filteredCities = null;
  var url = '${apiUrl}cities/filter';
  var response = await http.get(Uri.parse(url), headers: <String, String>{
    'Content-Type': 'application/json; charset=UTF-8',
    'Accept': 'application/json',
    'Source':'ios_client_app_1',
    "ServiceName": 'faem_food',
  });
  if (response.statusCode == 200) {
    var jsonResponse = convert.jsonDecode(response.body);
    filteredCities = new FilteredCitiesData.fromJson(jsonResponse);
  } else {
    print('Request failed with status: ${response.statusCode}.');
  }
  print(response.body);
  return filteredCities;
}