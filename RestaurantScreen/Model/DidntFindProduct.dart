class DidntFindProduct {
  DidntFindProduct({
    this.id,
    this.text,
    this.images,
    this.application,
    this.createdAt,
  });

  final String id;
  final String text;
  final dynamic images;
  final String application;
  final DateTime createdAt;

  factory DidntFindProduct.fromJson(Map<String, dynamic> json) => DidntFindProduct(
    id: json["id"] == null ? null : json["id"],
    text: json["text"] == null ? null : json["text"],
    images: json["images"],
    application: json["application"] == null ? null : json["application"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "text": text == null ? null : text,
    "images": images,
    "application": application == null ? null : application,
    "created_at": createdAt == null ? null : createdAt.toIso8601String(),
  };
}
