// To parse this JSON data, do
//
//     final productsDataModel = productsDataModelFromJson(jsonString);

import 'dart:convert';

import 'dart:io';

ProductsDataModel productsDataModelFromJson(String str) => ProductsDataModel.fromJson(json.decode(str));

String productsDataModelToJson(ProductsDataModel data) => json.encode(data.toJson());

class ProductsDataModel {
  ProductsDataModel({
    this.product,
    this.variantGroups,
  });

  Product product;
  List<VariantGroup> variantGroups;

  factory ProductsDataModel.fromJson(Map<String, dynamic> json) => ProductsDataModel(
    product: Product.fromJson(json["product"]),
    variantGroups: List<VariantGroup>.from(json["variant_groups"].map((x) => VariantGroup.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "product": product.toJson(),
    "variant_groups": List<dynamic>.from(variantGroups.map((x) => x.toJson())),
  };

  Map<String, dynamic> toServerJson(int count){
    List<dynamic> variantGroupsList = new List<dynamic>();
    variantGroups.forEach((element) {
      variantGroupsList.add(element.toServerJson());
    });
    Map<String, dynamic> request = {
      "source": (Platform.isIOS) ? "ios" : "android",
      "item": {
        "product_uuid": product.uuid,
        "variant_groups": variantGroupsList,
        "count": count
      }
    };
    return request;
  }
}

class Product {
  Product({
    this.uuid,
    this.externalId,
    this.name,
    this.storeUuid,
    this.productCategories,
    this.comment,
    this.url,
    this.available,
    this.stopList,
    this.defaultSet,
    this.priority,
    this.type,
    this.leftover,
    this.price,
    this.meta,
  });

  String uuid;
  String externalId;
  String name;
  String storeUuid;
  List<ProductCategory> productCategories;
  String comment;
  String url;
  bool available;
  bool stopList;
  bool defaultSet;
  int priority;
  String type;
  double leftover;
  double price;
  ProductMeta meta;

  factory Product.fromJson(Map<String, dynamic> json) => Product(
    uuid: json["uuid"],
    externalId: json["external_id"],
    name: json["name"],
    storeUuid: json["store_uuid"],
    productCategories: List<ProductCategory>.from(json["product_categories"].map((x) => ProductCategory.fromJson(x))),
    comment: json["comment"],
    url: json["url"],
    available: json["available"],
    stopList: json["stop_list"],
    defaultSet: json["default_set"],
    priority: json["priority"],
    type: json["type"],
    leftover: json["leftover"] * 1.0,
    price: json["price"] * 1.0,
    meta: ProductMeta.fromJson(json["meta"]),
  );

  Map<String, dynamic> toJson() => {
    "uuid": uuid,
    "external_id": externalId,
    "name": name,
    "store_uuid": storeUuid,
    "product_categories": List<dynamic>.from(productCategories.map((x) => x.toJson())),
    "comment": comment,
    "url": url,
    "available": available,
    "stop_list": stopList,
    "default_set": defaultSet,
    "priority": priority,
    "type": type,
    "leftover": leftover,
    "price": price,
    "meta": meta.toJson(),
  };
}

class ProductMeta {
  ProductMeta({
    this.description,
    this.composition,
    this.weight,
    this.oldPrice,
    this.weightMeasurement,
    this.images,
    this.energyValue,
  });

  String description;
  String composition;
  double weight;
  var oldPrice;
  String weightMeasurement;
  List<String> images;
  EnergyValue energyValue;

  factory ProductMeta.fromJson(Map<String, dynamic> json) => ProductMeta(
    description: json["description"],
    composition: json["composition"],
    weight: json["weight"] * 1.0,
    oldPrice: json["old_price"] == null ? null : json["old_price"],
    weightMeasurement: json["weight_measurement"],
    images: (json["images"] == null) ? null :  List<String>.from(json["images"].map((x) => x)),
    energyValue: EnergyValue.fromJson(json["energy_value"]),
  );

  Map<String, dynamic> toJson() => {
    "description": description,
    "composition": composition,
    "weight": weight,
    "old_price": oldPrice == null ? null : oldPrice,
    "weight_measurement": weightMeasurement,
    "images": (images != null) ? List<dynamic>.from(images.map((x) => x)) : null,
    "energy_value": energyValue.toJson(),
  };
}

class EnergyValue {
  EnergyValue({
    this.protein,
    this.fat,
    this.carbohydrates,
    this.calories,
  });

  int protein;
  int fat;
  int carbohydrates;
  int calories;

  factory EnergyValue.fromJson(Map<String, dynamic> json) => EnergyValue(
    protein: json["protein"],
    fat: json["fat"],
    carbohydrates: json["carbohydrates"],
    calories: json["calories"],
  );

  Map<String, dynamic> toJson() => {
    "protein": protein,
    "fat": fat,
    "carbohydrates": carbohydrates,
    "calories": calories,
  };
}

class ProductCategory {
  ProductCategory({
    this.uuid,
    this.name,
    this.priority,
    this.comment,
    this.url,
    this.meta,
  });

  String uuid;
  String name;
  double priority;
  String comment;
  String url;
  ProductCategoryMeta meta;

  factory ProductCategory.fromJson(Map<String, dynamic> json) => ProductCategory(
    uuid: json["uuid"],
    name: json["name"],
    priority: json["priority"] * 1.0,
    comment: json["comment"],
    url: json["url"],
    meta: ProductCategoryMeta.fromJson(json["meta"]),
  );

  Map<String, dynamic> toJson() => {
    "uuid": uuid,
    "name": name,
    "priority": priority,
    "comment": comment,
    "url": url,
    "meta": meta.toJson(),
  };
}

class ProductCategoryMeta {
  ProductCategoryMeta();

  factory ProductCategoryMeta.fromJson(Map<String, dynamic> json) => ProductCategoryMeta(
  );

  Map<String, dynamic> toJson() => {
  };
}

class VariantGroup {
  VariantGroup({
    this.uuid,
    this.name,
    this.productUuid,
    this.required,
    this.meta,
    this.variants,
  });

  String uuid;
  String name;
  String productUuid;
  bool required;
  ProductCategoryMeta meta;
  List<Variant> variants;

  factory VariantGroup.fromJson(Map<String, dynamic> json) => VariantGroup(
    uuid: json["uuid"],
    name: json["name"],
    productUuid: json["product_uuid"],
    required: json["required"],
    meta: ProductCategoryMeta.fromJson(json["meta"]),
    variants: List<Variant>.from(json["variants"].map((x) => Variant.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "uuid": uuid,
    "name": name,
    "product_uuid": productUuid,
    "required": required,
    "meta": meta.toJson(),
    "variants": List<dynamic>.from(variants.map((x) => x.toJson())),
  };

  Map<String, dynamic> toServerJson(){
    List<String> variantList = new List<String>();
    variants.forEach((element) {
      variantList.add(element.uuid);
    });
    Map<String, dynamic> request = {
      "variant_group_uuid": uuid,
      "variants_uuid": variantList
    };

    return request;
  }
}

class Variant {
  Variant({
    this.uuid,
    this.name,
    this.productUuid,
    this.variantGroupUuid,
    this.price,
    this.variantDefault,
    this.available,
    this.stopList,
    this.meta,
  });

  String uuid;
  String name;
  String productUuid;
  String variantGroupUuid;
  double price;
  bool variantDefault;
  bool available;
  bool stopList;
  VariantMeta meta;

  factory Variant.fromJson(Map<String, dynamic> json) => Variant(
    uuid: json["uuid"],
    name: json["name"],
    productUuid: json["product_uuid"],
    variantGroupUuid: json["variant_group_uuid"],
    price: json["price"] * 1.0,
    variantDefault: json["default"],
    available: json["available"],
    stopList: json["stop_list"],
    meta: VariantMeta.fromJson(json["meta"]),
  );

  Map<String, dynamic> toJson() => {
    "uuid": uuid,
    "name": name,
    "product_uuid": productUuid,
    "variant_group_uuid": variantGroupUuid,
    "price": price,
    "default": variantDefault,
    "available": available,
    "stop_list": stopList,
    "meta": meta.toJson(),
  };
}

class VariantMeta {
  VariantMeta({
    this.description,
  });

  String description;

  factory VariantMeta.fromJson(Map<String, dynamic> json) => VariantMeta(
    description: json["description"],
  );

  Map<String, dynamic> toJson() => {
    "description": description,
  };
}
