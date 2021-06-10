import 'package:flutter/material.dart';
import 'package:flutter_app/Screens/HomeScreen/Model/FilteredStores.dart';
import 'package:flutter_app/Screens/RestaurantScreen/Model/ProductsByStoreUuid.dart';
import 'package:flutter_app/data/api.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;


Future<ProductsByStoreUuidData> getProductsByStoreUuid(String store_uuid) async {
  ProductsByStoreUuidData productsByStoreUuid = null;
  var url = '${apiUrl}products/store/${store_uuid}';
  var response = await http.get(Uri.parse(url), headers: <String, String>{
    'Content-Type': 'application/json; charset=UTF-8',
    'Accept': 'application/json',
    'Source':'ios_client_app_1',
    "ServiceName": 'faem_food',
  });
  if (response.statusCode == 200) {
    var jsonResponse = convert.jsonDecode(response.body);
    productsByStoreUuid = new ProductsByStoreUuidData.fromJson(jsonResponse);
  } else {
    print('Request failed with status: ${response.statusCode}.');
  }
  print(response.body);
  return productsByStoreUuid;
}

// Future<ProductsByStoreUuidData> getSortedProductsByStoreUuid(FilteredStores store) async{
//   ProductsByStoreUuidData productsByStoreUuid = await getProductsByStoreUuid(store.uuid);
//
//   if(productsByStoreUuid == null || productsByStoreUuid.productsByStoreUuidList == null)
//     return productsByStoreUuid;
//
//   store.productCategoriesUuid = new List<CategoriesUuid>();
//   productsByStoreUuid.productsByStoreUuidList.forEach((element) {
//     int k = store.productCategoriesUuid.indexWhere((storeProductUuid) =>
//               storeProductUuid.name == element.productCategories[0].name);
//     if(k == -1)
//       if(element.productCategories != null &&  element.productCategories.length > 0)
//         store.productCategoriesUuid.add(new CategoriesUuid(
//             uuid: element.productCategories[0].uuid,
//             name: element.productCategories[0].name,
//             comment: element.productCategories[0].comment,
//             priority: element.productCategories[0].priority.toDouble(),
//             url: element.productCategories[0].url
//         ));
//   });
//
//     productsByStoreUuid.productsByStoreUuidList.sort((ProductsByStoreUuid a, ProductsByStoreUuid b) {
//       int ind1 = store.productCategoriesUuid.indexWhere((element) {
//         return (element.uuid == a.productCategories[0].uuid);
//       });
//
//       int ind2 = store.productCategoriesUuid.indexWhere((element) {
//         return (element.uuid == b.productCategories[0].uuid);
//       });
//       if(ind1 == ind2)
//         return 0;
//       return (ind1 > ind2) ? 1 : -1;
//     });
//     return productsByStoreUuid;
// }