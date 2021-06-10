import 'dart:io';

import 'package:flutter_app/Screens/CartScreen/Model/CartModel.dart';
import 'package:flutter_app/data/api.dart';
import 'package:flutter_app/data/globalVariables.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

import '../Model/CartModel.dart';


Future<CartModel> getCartByDeviceId(String device_id) async {

  CartModel cartModelItems = null;
  var url = '${apiUrl}orders/device/${device_id}/last';
  var response = await http.get(Uri.parse(url), headers: <String, String>{
    'Content-Type': 'application/json; charset=UTF-8',
    'Application': header,
    'Source': (Platform.isIOS) ? "ios" : "android",
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