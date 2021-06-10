import 'package:flutter_app/Screens/RestaurantScreen/Model/ProductDataModel.dart';
import 'package:flutter_app/Screens/RestaurantScreen/Model/ProductsWithCategories.dart';
import 'package:flutter_app/data/api.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;


Future<ProductsWithCategories> getProductsWithCateogies(String store_uuid, String product_category_uuid) async {
  ProductsWithCategories productWithCategories = null;
  var url = '${apiUrl}products_and_categories?store_uuid=${store_uuid}&product_category_uuid=${product_category_uuid}&limit=99999';
  var response = await http.get(Uri.parse(url), headers: <String, String>{
    'Content-Type': 'application/json; charset=UTF-8',
    'Accept': 'application/json',
    'Source':'ios_client_app_1',
    "ServiceName": 'faem_food',
  });
  if (response.statusCode == 200) {
    var jsonResponse = convert.jsonDecode(response.body);
    productWithCategories = new ProductsWithCategories.fromJson(jsonResponse);
  } else {
    print('Request failed with status: ${response.statusCode}.');
  }
  print(response.body);
  return productWithCategories;
}