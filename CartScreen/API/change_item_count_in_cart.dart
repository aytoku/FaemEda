import 'package:flutter_app/Screens/CartScreen/Model/CartModel.dart';
import 'package:flutter_app/data/api.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

import '../Model/CartModel.dart';


Future<CartModel> changeItemCountInCart(String device_id, int item_id, int count) async {

  CartModel cartModelItems = null;
  var url = '${apiUrl}orders/carts/$device_id/$item_id/$count';
  var response = await http.put(Uri.parse(url), headers: <String, String>{
    'Content-Type': 'application/json; charset=UTF-8',
  });
  if (response.statusCode == 200) {
    var jsonResponse = convert.jsonDecode(response.body);
    if(jsonResponse != null){
      cartModelItems = new CartModel.fromJson(jsonResponse);
    }
  } else {
    print('Request failed with status: ${response.statusCode}.');
  }
  print(response.body + 'vah');
  return cartModelItems;
}