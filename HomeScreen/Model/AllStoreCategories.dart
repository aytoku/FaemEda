class AllStoreCategoriesData{
  static List<AllStoreCategories> selectedStoreCategories = new List<AllStoreCategories>();

  List<AllStoreCategories> allStoreCategoriesList;

  AllStoreCategoriesData( {
    this.allStoreCategoriesList,
  });

  factory AllStoreCategoriesData.fromJson(List<dynamic> parsedJson){
    List<AllStoreCategories> categoriesList = null;
    if(parsedJson != null){
      categoriesList = parsedJson.map((i) => AllStoreCategories.fromJson(i)).toList();
    }

    return AllStoreCategoriesData(
      allStoreCategoriesList:categoriesList,
    );
  }
}

class AllStoreCategories {
  AllStoreCategories({
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

  factory AllStoreCategories.fromJson(Map<String, dynamic> json) => AllStoreCategories(
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
