import 'package:flutter_app/Screens/RestaurantScreen/Model/SearchProductModel.dart';
import 'package:flutter_app/data/api.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;


Future<SearchProductModelData> searchProducts(String city_uuid, String store_uuid, String name, int page, int limit) async {
  SearchProductModelData productDataModelItem = null;
  var url = '${apiUrl}products/search?name=$name&city_uuid=$city_uuid&store_uuid=$store_uuid&page=$page&limit=$limit';
  var response = await http.get(Uri.parse(url), headers: <String, String>{
    'Content-Type': 'application/json; charset=UTF-8',
    'Accept': 'application/json',
  });
  if (response.statusCode == 200) {
    var jsonResponse = convert.jsonDecode(response.body);
    productDataModelItem = new SearchProductModelData.fromJson(jsonResponse);
  } else {
    print('Request failed with status: ${response.statusCode}.');
  }
  print(response.body);
  return productDataModelItem;
}