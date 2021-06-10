import 'package:flutter_app/Screens/RestaurantScreen/Model/BaseProductModel.dart';
import 'package:flutter_app/Screens/RestaurantScreen/Model/FilteredProductCategories.dart';

class SearchProductModelData{

  List<SearchProductModel> searchModel;

  SearchProductModelData( {
    this.searchModel,
  });

  factory SearchProductModelData.fromJson(List<dynamic> parsedJson){
    List<SearchProductModel> searchProductList = null;
    if(parsedJson != null){
      searchProductList = parsedJson.map((i) => SearchProductModel.fromJson(i)).toList();
    }

    return SearchProductModelData(
      searchModel:searchProductList,
    );
  }
}


class SearchProductModel {
  SearchProductModel({
    this.store,
    this.products,
  });

  final Store store;
  final List<Product> products;

  factory SearchProductModel.fromJson(Map<String, dynamic> json) => SearchProductModel(
    store: json["store"] == null ? null : Store.fromJson(json["store"]),
    products: json["products"] == null ? null : List<Product>.from(json["products"].map((x) => Product.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "store": store == null ? null : store.toJson(),
    "products": products == null ? null : List<dynamic>.from(products.map((x) => x.toJson())),
  };
}

class Product extends BaseProductModel{
  Product({
    String uuid,
    String name,
    String image,
    double price,
    List<BaseProductCategory> productCategories,
    this.productCategoryUuid,
    this.productCategoryName,
    this.productCategory,
    double old_price,
    String type,
    String description,
  }) : super(
    uuid: uuid,
    name: name,
    image: image,
    price: price,
    type: type,
    description: description,
    old_price: old_price,
    productCategories: productCategories
  );

  final String productCategoryUuid;
  final String productCategoryName;
  final FilteredProductCategories productCategory;

  factory Product.fromJson(Map<String, dynamic> json){

    FilteredProductCategories filteredProductCategories =
    json["product_category"] == null ? null :
    FilteredProductCategories.fromJson(json["product_category"]);


    return Product(
      uuid: json["uuid"] == null ? null : json["uuid"],
      name: json["name"] == null ? null : json["name"],
      image: json["image"] == null ? null : json["image"],
      price: json["price"] == null ? null : json["price"] * 1.0,
      productCategoryUuid: json["product_category_uuid"] == null ? null : json["product_category_uuid"],
      productCategoryName: json["product_category_name"] == null ? null : json["product_category_name"],
      productCategory: filteredProductCategories,
      old_price: json["old_price"] == null ? null : json["old_price"] * 1.0,
      type: json["type"] == null ? null : json["type"],
      description: json["description"] == null ? null : json["description"],
      productCategories: [filteredProductCategories]
    );
  }

  Map<String, dynamic> toJson() => {
    "uuid": uuid == null ? null : uuid,
    "name": name == null ? null : name,
    "image": image == null ? null : image,
    "price": price == null ? null : price,
    "product_category_uuid": productCategoryUuid == null ? null : productCategoryUuid,
    "product_category_name": productCategoryName == null ? null : productCategoryName,
    "product_category": productCategory == null ? null : productCategory.toJson(),
    "old_price": old_price == null ? null : old_price,
    "type": type == null ? null : type,
    "description": description == null ? null : description,
  };
}

class ProductCategory {
  ProductCategory({
    this.uuid,
    this.name,
    this.priority,
    this.parentUuid,
    this.storeUuid,
    this.productsCount,
    this.meta,
  });

  final String uuid;
  final String name;
  final int priority;
  final String parentUuid;
  final String storeUuid;
  final int productsCount;
  final Meta meta;

  factory ProductCategory.fromJson(Map<String, dynamic> json) => ProductCategory(
    uuid: json["uuid"] == null ? null : json["uuid"],
    name: json["name"] == null ? null : json["name"],
    priority: json["priority"] == null ? null : json["priority"],
    parentUuid: json["parent_uuid"] == null ? null : json["parent_uuid"],
    storeUuid: json["store_uuid"] == null ? null : json["store_uuid"],
    productsCount: json["products_count"] == null ? null : json["products_count"],
    meta: json["meta"] == null ? null : Meta.fromJson(json["meta"]),
  );

  Map<String, dynamic> toJson() => {
    "uuid": uuid == null ? null : uuid,
    "name": name == null ? null : name,
    "priority": priority == null ? null : priority,
    "parent_uuid": parentUuid == null ? null : parentUuid,
    "store_uuid": storeUuid == null ? null : storeUuid,
    "products_count": productsCount == null ? null : productsCount,
    "meta": meta == null ? null : meta.toJson(),
  };
}

class Meta {
  Meta({
    this.images,
  });

  final List<String> images;

  factory Meta.fromJson(Map<String, dynamic> json) => Meta(
    images: json["images"] == null ? null : List<String>.from(json["images"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "images": images == null ? null : List<dynamic>.from(images.map((x) => x)),
  };
}


class Store {
  Store({
    this.uuid,
    this.name,
    this.image,
  });

  final String uuid;
  final String name;
  final String image;

  factory Store.fromJson(Map<String, dynamic> json) => Store(
    uuid: json["uuid"] == null ? null : json["uuid"],
    name: json["name"] == null ? null : json["name"],
    image: json["image"] == null ? null : json["image"],
  );

  Map<String, dynamic> toJson() => {
    "uuid": uuid == null ? null : uuid,
    "name": name == null ? null : name,
    "image": image == null ? null : image,
  };
}

class EnumValues<T> {
  Map<String, T> map;
  Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    if (reverseMap == null) {
      reverseMap = map.map((k, v) => new MapEntry(v, k));
    }
    return reverseMap;
  }
}
