import 'package:flutter_app/Screens/RestaurantScreen/Model/BaseProductModel.dart';

class ProductsByStoreUuidData{
  List<ProductsByStoreUuid> productsByStoreUuidList;

  ProductsByStoreUuidData( {
    this.productsByStoreUuidList,
  });

  factory ProductsByStoreUuidData.fromJson(List<dynamic> parsedJson){
    List<ProductsByStoreUuid> productsList = null;
    if(parsedJson != null){
      productsList = parsedJson.map((i) => ProductsByStoreUuid.fromJson(i)).toList();
    }

    return ProductsByStoreUuidData(
      productsByStoreUuidList:productsList,
    );
  }
}


class ProductsByStoreUuid extends BaseProductModel{
  ProductsByStoreUuid({
    String uuid,
    String name,
    this.storeUuid,
    List<BaseProductCategory> productCategories,
    this.comment,
    this.url,
    this.deleted,
    this.available,
    this.stopList,
    this.defaultSet,
    this.priority,
    this.openable,
    String type,
    double price,
    this.weight,
    this.weightMeasurement,
    this.meta,
    this.externalId,
    this.variantGroups,
    String image,
    String description,
    double old_price
  }): super(
    uuid: uuid,
    name: name,
    type: type,
    price: price,
    image: image,
    old_price: old_price,
    description: description,
    productCategories: productCategories
  );

  String storeUuid;
  String comment;
  String url;
  bool deleted;
  bool available;
  bool stopList;
  bool defaultSet;
  int priority;
  bool openable;
  int weight;
  String weightMeasurement;
  ProductsByStoreUuidMeta meta;
  String externalId;
  dynamic variantGroups;

  factory ProductsByStoreUuid.fromJson(Map<String, dynamic> json) {

    List<ProductCategory> cats = [];
    if(json["product_categories"] != null)
      cats = List<ProductCategory>.from(
          json["product_categories"].map((x) => ProductCategory.fromJson(x)));
    if(cats.isEmpty){
      cats.add(new ProductCategory(
          uuid: ' ',
          name: 'Категория',
          comment: ' ',
          priority: -1,
          url: ' '
      ));
    }


    print('AAAAUUUUU0');
    ProductsByStoreUuidMeta productsByStoreUuidMeta = ProductsByStoreUuidMeta.fromJson(json["meta"]);

    print('AAAAUUUUU');
    String image = '';
    print('AAAAUUUUU1');
    if(productsByStoreUuidMeta.images != null && productsByStoreUuidMeta.images.isNotEmpty){
      image = productsByStoreUuidMeta.images[0];
    }
    print('AAAAUUUUU2');
    String description = productsByStoreUuidMeta.description;
    print('AAAAUUUUU3');
    double oldPrice = productsByStoreUuidMeta.oldPrice;


    print('AAAAUUUUU4');
    return ProductsByStoreUuid(
      uuid: json["uuid"],
      name: json["name"],
      storeUuid: json["store_uuid"],
      productCategories: cats,
      comment: json["comment"],
      image: image,
      description: description,
      old_price: oldPrice,
      url: json["url"],
      deleted: json["deleted"],
      available: json["available"],
      stopList: json["stop_list"],
      defaultSet: json["default_set"],
      priority: json["priority"],
      openable: json["openable"],
      type: json["type"],
      price: json["price"] * 1.0,
      weight: json["weight"],
      weightMeasurement: json["weight_measurement"],
      meta: productsByStoreUuidMeta,
      externalId: json["external_id"],
      variantGroups: json["variant_groups"],
    );
  }

  Map<String, dynamic> toJson() => {
    "uuid": uuid,
    "name": name,
    "store_uuid": storeUuid,
    "product_categories": List<dynamic>.from(productCategories.map((x) => x.toJson())),
    "comment": comment,
    "url": url,
    "deleted": deleted,
    "available": available,
    "stop_list": stopList,
    "default_set": defaultSet,
    "priority": priority,
    "openable": openable,
    "type": type,
    "price": price,
    "weight": weight,
    "weight_measurement": weightMeasurement,
    "meta": meta.toJson(),
    "external_id": externalId,
    "variant_groups": variantGroups,
  };
}

class ProductsByStoreUuidMeta {
  ProductsByStoreUuidMeta({
    this.description,
    this.shortDescription,
    this.composition,
    this.weight,
    this.oldPrice,
    this.weightMeasurement,
    this.images,
    this.energyValue,
  });

  String description;
  String shortDescription;
  String composition;
  double oldPrice;
  double weight;
  String weightMeasurement;
  List<String> images;
  EnergyValue energyValue;

  factory ProductsByStoreUuidMeta.fromJson(Map<String, dynamic> json) => ProductsByStoreUuidMeta(
    description: json["description"],
    shortDescription: json["short_description"],
    composition: json["composition"],
    oldPrice: json["old_price"] * 1.0,
    weight: json["weight"] * 1.0,
    weightMeasurement: json["weight_measurement"],
    images: (json["images"] == null) ? null : List<String>.from(json["images"].map((x) => x)),
    energyValue: EnergyValue.fromJson(json["energy_value"]),
  );

  Map<String, dynamic> toJson() => {
    "description": description,
    "short_description": shortDescription,
    "composition": composition,
    "old_price": oldPrice,
    "weight": weight,
    "weight_measurement": weightMeasurement,
    "images": List<dynamic>.from(images.map((x) => x)),
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
  double calories;

  factory EnergyValue.fromJson(Map<String, dynamic> json) => EnergyValue(
    protein: json["protein"],
    fat: json["fat"],
    carbohydrates: json["carbohydrates"],
    calories: json["calories"]*1.0,
  );

  Map<String, dynamic> toJson() => {
    "protein": protein,
    "fat": fat,
    "carbohydrates": carbohydrates,
    "calories": calories,
  };
}

class ProductCategory extends BaseProductCategory{
  ProductCategory({
    String uuid,
    String name,
    double priority,
    this.comment,
    this.url,
    this.meta,
  }) : super(
    uuid: uuid,
    name: name,
    priority: priority
  );

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