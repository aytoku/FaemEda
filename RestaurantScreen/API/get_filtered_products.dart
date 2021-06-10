import 'package:flutter_app/Screens/HomeScreen/Model/FilteredStores.dart';
import 'package:flutter_app/data/api.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

import '../Model/ProductsByStoreUuid.dart';


Future<ProductsByStoreUuidData> getFilteredProduct(String product_category_uuid, String store_uuid) async {
  ProductsByStoreUuidData productByStoreUuidData = null;
  var url;
  if(product_category_uuid == ''){
    url = '${apiUrl}products/filter?store_uuid=$store_uuid';
  }else{
    url = '${apiUrl}products/filter?product_categories_uuid=$product_category_uuid&store_uuid=$store_uuid';
  }
  print('STORECATEGORYYY');
  var response = await http.get(Uri.parse(url), headers: <String, String>{
    'Content-Type': 'application/json; charset=UTF-8',
    'Accept': 'application/json'
  });

  print(response.body + 'STORECATEGORYYY');
  if (response.statusCode == 200) {
    var jsonResponse = convert.jsonDecode(response.body);
    productByStoreUuidData = new ProductsByStoreUuidData.fromJson(jsonResponse);
  } else {
    print('Request failed with status: ${response.statusCode}.');
  }
  print(response.body);
  return productByStoreUuidData;
}


Future<ProductsByStoreUuidData> getSortedProductsByStoreUuid(String product_category_uuid, FilteredStores store) async{
  ProductsByStoreUuidData productsByStoreUuid = await getFilteredProduct(product_category_uuid, store.uuid);
  // Если была передана конкретная категория для получения
  if(product_category_uuid != '' && product_category_uuid != null)
    return productsByStoreUuid;
  // Если что-то пошло не так
  if(productsByStoreUuid == null || productsByStoreUuid.productsByStoreUuidList == null)
    return productsByStoreUuid;


  store.productCategoriesUuid = [];
  productsByStoreUuid.productsByStoreUuidList.forEach((element) {
    int k = store.productCategoriesUuid.indexWhere((storeProductUuid) =>
    storeProductUuid.name == element.productCategories[0].name);
    if(k == -1)
      if(element.productCategories != null &&  element.productCategories.length > 0)
        store.productCategoriesUuid.add(new CategoriesUuid(
            uuid: element.productCategories[0].uuid,
            name: element.productCategories[0].name,
            comment: (element.productCategories[0] is ProductCategory) ?
            (element.productCategories[0] as ProductCategory).comment : '',
            priority: element.productCategories[0].priority.toDouble(),
            url: (element.productCategories[0] is ProductCategory) ?
            (element.productCategories[0] as ProductCategory).url : '',
        ));
  });

  productsByStoreUuid.productsByStoreUuidList.sort((ProductsByStoreUuid a, ProductsByStoreUuid b) {
    int ind1 = store.productCategoriesUuid.indexWhere((element) {
      return (element.uuid == a.productCategories[0].uuid);
    });

    int ind2 = store.productCategoriesUuid.indexWhere((element) {
      return (element.uuid == b.productCategories[0].uuid);
    });
    if(ind1 == ind2)
      return 0;
    return (ind1 > ind2) ? 1 : -1;
  });
  return productsByStoreUuid;
}