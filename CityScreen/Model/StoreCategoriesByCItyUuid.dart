// To parse this JSON data, do
//
//     final storeCategoriesByCItyUuid = storeCategoriesByCItyUuidFromJson(jsonString);

import 'dart:convert';

List<StoreCategoriesByCItyUuid> storeCategoriesByCItyUuidFromJson(String str) => List<StoreCategoriesByCItyUuid>.from(json.decode(str).map((x) => StoreCategoriesByCItyUuid.fromJson(x)));

String storeCategoriesByCItyUuidToJson(List<StoreCategoriesByCItyUuid> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class StoreCategoriesByCItyUuid {
  StoreCategoriesByCItyUuid({
    this.uuid,
    this.name,
    this.url,
    this.meta,
    this.priority,
  });

  String uuid;
  String name;
  String url;
  Meta meta;
  int priority;

  factory StoreCategoriesByCItyUuid.fromJson(Map<String, dynamic> json) => StoreCategoriesByCItyUuid(
    uuid: json["uuid"],
    name: json["name"],
    url: json["url"],
    meta: Meta.fromJson(json["meta"]),
    priority: json["priority"],
  );

  Map<String, dynamic> toJson() => {
    "uuid": uuid,
    "name": name,
    "url": url,
    "meta": meta.toJson(),
    "priority": priority,
  };
}

class Meta {
  Meta();

  factory Meta.fromJson(Map<String, dynamic> json) => Meta(
  );

  Map<String, dynamic> toJson() => {
  };
}
