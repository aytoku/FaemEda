class BaseProductModel {
  BaseProductModel({
    this.uuid,
    this.name,
    this.image,
    this.old_price,
    this.price,
    this.type,
    this.description,
    this.productCategories
  });

  final String uuid;
  final String name;
  final String image;
  final double old_price;
  final double price;
  final String type;
  final String description;
  List<BaseProductCategory> productCategories;

  factory BaseProductModel.fromJson(Map<String, dynamic> json) => BaseProductModel(
    uuid: json["uuid"] == null ? null : json["uuid"],
    name: json["name"] == null ? null : json["name"],
    image: json["image"] == null ? null : json["image"],
    old_price: json["old_price"] == null ? null : json["old_price"] * 1.0,
    price: json["price"] == null ? null : json["price"] * 1.0,
    type: json["type"] == null ? null : json["type"],
    description: json["description"] == null ? null : json["description"],
  );

  Map<String, dynamic> toJson() => {
    "uuid": uuid == null ? null : uuid,
    "name": name == null ? null : name,
    "image": image == null ? null : image,
    "old_price": old_price == null ? null : old_price,
    "type": type == null ? null : type,
    "description": description == null ? null : description,
    "price": price == null ? null : price,
  };
}


class BaseProductCategory {
  BaseProductCategory({
    this.uuid,
    this.name,
    this.priority
  });

  String uuid;
  final String name;
  final double priority;

  factory BaseProductCategory.fromJson(Map<String, dynamic> json) => BaseProductCategory(
    uuid: json["uuid"] == null ? null : json["uuid"],
    name: json["name"] == null ? null : json["name"],
    priority: json["priority"] == null ? null : json["priority"] * 1.0,
  );

  Map<String, dynamic> toJson() => {
    "uuid": uuid == null ? null : uuid,
    "name": name == null ? null : name,
    "priority": priority == null ? null : priority,
  };
}