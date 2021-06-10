import 'package:flutter_app/Screens/RestaurantScreen/Model/BaseProductModel.dart';
import 'package:flutter_app/Screens/RestaurantScreen/Model/FilteredProductCategories.dart';

class ProductsWithCategories {
  ProductsWithCategories({
    this.categories,
    this.products,
    this.productsCount
  });

  final List<Category> categories;
  final List<Product> products;
  int productsCount;

  factory ProductsWithCategories.fromJson(Map<String, dynamic> json) {
    // Список категорий
    List<Category> categories = json["categories"] == null ? null :  List<Category>.from(json["categories"].map((x) => Category.fromJson(x)));

    // Список продуктов
    List<Product> products = json["products"] == null ? null : List<Product>.from(json["products"].map((x) {
      // Генерируем продукт
      Product product = Product.fromJson(x);

      // Добавляем в него полноценную категорию
      if(categories.isNotEmpty){
        int catIndex = categories.indexWhere((element) => element.uuid == product.productCategoriesUuid?.first);
        if(catIndex == -1)
          print('ARA PERE PLS ' + product.productCategoriesUuid?.first);
        product.productCategories = [catIndex != -1 ? categories[catIndex] : categories[0]];
      }

      return product;
    }));


    return ProductsWithCategories(
      categories: categories,
      products: products,
      productsCount: json['products_count']
    );
  }

  Map<String, dynamic> toJson() => {
    "categories": categories == null ? null : List<dynamic>.from(categories.map((x) => x.toJson())),
    "products": products == null ? null : List<dynamic>.from(products.map((x) => x.toJson())),
    'products_count': productsCount == null ? null : productsCount
  };
}

class Category extends FilteredProductCategories{
  Category({
    String uuid,
    String name,
    double priority,
    String parentUuid,
    this.storeUuid,
    this.comment,
    int count,
    this.hash,
    Meta meta,
  }) : super(
    uuid: uuid,
    name: name,
    priority: priority,
    parentUuid: parentUuid,
    count: count,
    meta: meta
  );


  final String storeUuid;
  final String comment;
  final String hash;

  factory Category.fromJson(Map<String, dynamic> json) => Category(
    uuid: json["uuid"] == null ? null : json["uuid"],
    name: json["name"] == null ? null : json["name"],
    priority: json["priority"] == null ? null : json["priority"] * 1.0,
    parentUuid: json["parent_uuid"] == null ? null : json["parent_uuid"],
    storeUuid: json["store_uuid"] == null ? null : json["store_uuid"],
    comment: json["comment"] == null ? null : json["comment"],
    count: json["products_count"] == null ? null : json["products_count"],
    hash: json["hash"] == null ? null : json["hash"],
    meta: json["meta"] == null ? null : Meta.fromJson(json["meta"]),
  );

  Map<String, dynamic> toJson() => {
    "uuid": uuid == null ? null : uuid,
    "name": name == null ? null : name,
    "priority": priority == null ? null : priority,
    "parent_uuid": parentUuid == null ? null : parentUuid,
    "store_uuid": storeUuid == null ? null : storeUuid,
    "comment": comment == null ? null : comment,
    "products_count": count == null ? null : count,
    "hash": hash == null ? null : hash,
    "meta": meta == null ? null : meta.toJson(),
  };
}


class Product extends BaseProductModel{
  Product({
    List<BaseProductCategory> productCategories,
    String uuid,
    String name,
    this.storeUuid,
    String type,
    double price,
    String image,
    this.leftover,
    this.productCategoriesUuid,
    this.meta,
  }) : super(
    uuid: uuid,
    name: name,
    type: type,
    price: price,
    image: image
  );

  final String storeUuid;
  final int leftover;
  final List<String> productCategoriesUuid;
  final ProductMeta meta;

  static String formatWeights (String input) {
    final nbsp = String.fromCharCode(0x00A0);
    final matches = RegExp(r'(\d{1,4}\,?\d{0,3}) (.{1,2})').allMatches(input);

    matches.forEach((match) {
      input = input.replaceRange(match.start, match.end, input.substring(match.start, match.end).replaceFirst(' ', nbsp));
    });
    return input;
  }

  factory Product.fromJson(Map<String, dynamic> json){
    String image = '';
    ProductMeta meta = json["meta"] == null ? null : ProductMeta.fromJson(json["meta"]);
    if(meta != null && meta.images != null && meta.images.isNotEmpty){
      image = meta.images[0];
    }

    return Product(
      uuid: json["uuid"] == null ? null : json["uuid"],
      name: json["name"] == null ? null : formatWeights(json["name"]),
      storeUuid: json["store_uuid"] == null ? null : json["store_uuid"],
      type: json["type"] == null ? null : json["type"],
      price: json["price"] == null ? null : json["price"] * 1.0,
      leftover: json["leftover"] == null ? null : json["leftover"],
        productCategoriesUuid: List<String>.from(json["product_categories_uuid"]?.map((var e)=> e) ?? [""]) ,
      meta: meta,
      image: image
    );
  }

  Map<String, dynamic> toJson() => {
    "uuid": uuid == null ? null : uuid,
    "name": name == null ? null : name,
    "store_uuid": storeUuid == null ? null : storeUuid,
    "type": type == null ? null : type,
    "price": price == null ? null : price,
    "leftover": leftover == null ? null : leftover,
    "product_category_uuid": productCategoriesUuid == null ? null : productCategoriesUuid,
    "meta": meta == null ? null : meta.toJson(),
  };
}

class ProductMeta {
  ProductMeta({
    this.shortDescription,
    this.description,
    this.composition,
    this.weight,
    this.weightMeasurement,
    this.discount,
    this.images,
  });

  final String shortDescription;
  final String description;
  final String composition;
  final double weight;
  final String weightMeasurement;
  final double discount;
  final List<String> images;

  factory ProductMeta.fromJson(Map<String, dynamic> json) => ProductMeta(
    shortDescription: json["short_description"] == null ? null : json["short_description"],
    description: json["description"] == null ? null : json["description"],
    composition: json["composition"] == null ? null : json["composition"],
    weight: json["weight"] == null ? null : json["weight"] * 1.0,
    weightMeasurement: json["weight_measurement"] == null ? null : json["weight_measurement"],
    discount: json["discount"] == null ? null : json["discount"] * 1.0,
    images: json["images"] == null ? null : List<String>.from(json["images"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "short_description": shortDescription == null ? null : shortDescription,
    "description": description == null ? null : description,
    "composition": composition == null ? null : composition,
    "weight": weight == null ? null : weight,
    "weight_measurement": weightMeasurement == null ? null : weightMeasurement,
    "discount": discount == null ? null : discount,
    "images": images == null ? null : List<dynamic>.from(images.map((x) => x)),
  };
}