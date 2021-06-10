import 'dart:convert';
import 'package:flutter_app/Screens/CartScreen/Model/CartModel.dart';
import 'package:flutter_app/Screens/CodeScreen/Model/AuthCode.dart';
import 'package:flutter_app/data/api.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;


Future<CartModel> incrementCartItemCount(String device_id, int item_id) async {

  CartModel cartModel = null;
  var url = '${apiUrl}orders/carts/${device_id}/items/${item_id}';
  var response = await http.put(Uri.parse(url), headers: <String, String>{
    'Content-Type': 'application/json; charset=UTF-8',
  });
  if (response.statusCode == 200) {
    var jsonResponse = convert.jsonDecode(response.body);
    cartModel = new CartModel.fromJson(jsonResponse);
  } else {
    print('Request failed with status: ${response.statusCode}.');
  }
  print(response.body);
  return cartModel;
}
