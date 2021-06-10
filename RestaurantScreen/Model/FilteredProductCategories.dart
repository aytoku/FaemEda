import 'package:flutter_app/Screens/RestaurantScreen/Model/BaseProductModel.dart';

class FilteredProductCategoriesData{

  List<FilteredProductCategories> filteredProductCategories;

  FilteredProductCategoriesData( {
    this.filteredProductCategories,
  });

  factory FilteredProductCategoriesData.fromJson(List<dynamic> parsedJson){
    List<FilteredProductCategories> filteredProductCategoriesList = null;
    if(parsedJson != null){
      filteredProductCategoriesList = parsedJson.map((i) => FilteredProductCategories.fromJson(i)).toList();
    }

    return FilteredProductCategoriesData(
      filteredProductCategories:filteredProductCategoriesList,
    );
  }
}


class FilteredProductCategories extends BaseProductCategory{
  FilteredProductCategories({
    String uuid,
    String name,
    double priority,
    this.parentUuid,
    this.count,
    this.meta,
  }): super(
    uuid: uuid,
    name: name,
    priority: priority
  );

  final String parentUuid;
  final int count;
  final Meta meta;

  factory FilteredProductCategories.fromJson(Map<String, dynamic> json) => FilteredProductCategories(
    uuid: json["uuid"] == null ? null : json["uuid"],
    name: json["name"] == null ? null : json["name"],
    priority: json["priority"] == null ? null : json["priority"] * 1.0,
    parentUuid: json["parent_uuid"] == null ? null : json["parent_uuid"],
    count: json["products_count"] == null ? null : json["products_count"],
    meta: json["meta"] == null ? null : Meta.fromJson(json["meta"]),
  );

  Map<String, dynamic> toJson() => {
    "uuid": uuid == null ? null : uuid,
    "name": name == null ? null : name,
    "priority": priority == null ? null : priority,
    "parent_uuid": parentUuid == null ? null : parentUuid,
    "products_count": count == null ? null : count,
    "meta": meta == null ? null : meta.toJson(),
  };
}

class Meta {
  Meta({
    this.images,
  });
  List<String> images;

  factory Meta.fromJson(Map<String, dynamic> json) => Meta(
    images: (json["images"] == null) ? null :  List<String>.from(json["images"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "images": (images != null) ? List<dynamic>.from(images.map((x) => x)) : null,
  };
}
