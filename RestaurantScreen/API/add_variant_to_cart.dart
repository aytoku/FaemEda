import 'dart:convert';
import 'dart:io';
import 'package:flutter_app/Screens/CartScreen/Model/CartModel.dart';
import 'package:flutter_app/data/api.dart';
import 'package:flutter_app/data/globalVariables.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

import '../../../data/data.dart';
import '../../../data/refreshToken.dart';
import '../Model/ProductDataModel.dart';

Future<CartModel> addVariantToCart(ProductsDataModel product, String device_id, int count) async {
  CartModel cartModel = null;
  var json_request = jsonEncode(product.toServerJson(count));
  var url = '${apiUrl}orders/carts/${device_id}';
  var response = await http.put(Uri.parse(url), body: json_request, headers: <String, String>{
    'Content-Type': 'application/json; charset=UTF-8',
    'Application': header,
    'Source': (Platform.isIOS) ? "ios" : "android",

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
