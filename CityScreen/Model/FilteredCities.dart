class FilteredCitiesData{
  List<FilteredCities> filteredCitiesList;

  FilteredCitiesData( {
    this.filteredCitiesList,
  });

  factory FilteredCitiesData.fromJson(List<dynamic> parsedJson){

    List<FilteredCities> citiesList = null;
    if(parsedJson != null){
      citiesList = parsedJson.map((i) => FilteredCities.fromJson(i)).toList();
    }

    return FilteredCitiesData(
      filteredCitiesList:citiesList,
    );
  }
}

class FilteredCities {
  FilteredCities({
    this.uuid,
    this.name,
    this.url,
    this.meta,
  });

  String uuid;
  String name;
  String url;
  Meta meta;

  factory FilteredCities.fromJson(Map<String, dynamic> json) => FilteredCities(
    uuid: json["uuid"],
    name: json["name"],
    url: json["url"],
    meta: Meta.fromJson(json["meta"]),
  );

  Map<String, dynamic> toJson() => {
    "uuid": uuid,
    "name": name,
    "url": url,
    "meta": meta.toJson(),
  };
}

class Meta {
  Meta({
    this.description,
  });

  String description;

  factory Meta.fromJson(Map<String, dynamic> json) => Meta(
    description: json["description"],
  );

  Map<String, dynamic> toJson() => {
    "description": description,
  };
}
