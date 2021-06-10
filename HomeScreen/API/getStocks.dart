import 'package:flutter_app/Screens/HomeScreen/Model/Stock.dart';
import 'package:flutter_app/data/api.dart';
import 'package:flutter_app/data/globalVariables.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

Future<List<Stock>> getStocks(String cityUuid) async {
  List<Stock> stocks = [];
  var url = '${apiUrl}promotions/$cityUuid';
  var response = await http.get(Uri.parse(url), headers: <String, String>{
    'Content-Type': 'application/json; charset=UTF-8',
    'Application': header
  });
  if (response.statusCode == 200) {
    var jsonResponse = json.decode(response.body) as List;
    stocks = jsonResponse.map((stock) => Stock.fromJson(stock)).toList();
  } else {
    print('Request stocks failed with status: ${response.statusCode}.');
  }
  print(response.body);
  return stocks;
}
