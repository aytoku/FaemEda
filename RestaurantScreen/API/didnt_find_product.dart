import 'dart:convert';
import 'package:flutter_app/Screens/InviteScreen/Model/InviteFriend.dart';
import 'package:flutter_app/Screens/RestaurantScreen/Model/DidntFindProduct.dart';
import 'package:flutter_app/data/api.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

Future<DidntFindProduct> didntFindProduct(String text) async {
  DidntFindProduct didntFindProduct = null;
  var json_request = jsonEncode({
    "text": text,
  });
  var url = '${apiUrl}products/didnt_find';
  var response = await http.post(Uri.parse(url), body: json_request, headers: <String, String>{
    'Content-Type': 'application/json; charset=UTF-8',
    "Application": "eda/pomidor"
  });
  print(response.body);
  try{
    var jsonResponse = convert.jsonDecode(response.body);
    didntFindProduct = new DidntFindProduct.fromJson(jsonResponse);
  }catch(e){
    return null;
  }

  return didntFindProduct;
}