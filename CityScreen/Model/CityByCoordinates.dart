import 'dart:convert';

CityByCoordinates cityByCoordinatesFromJson(String str) => CityByCoordinates.fromJson(json.decode(str));

String cityByCoordinatesToJson(CityByCoordinates data) => json.encode(data.toJson());

class CityByCoordinates {
  CityByCoordinates({
    this.accuracyLevel,
    this.category,
    this.city,
    this.cityType,
    this.comment,
    this.country,
    this.frontDoor,
    this.house,
    this.houseType,
    this.lat,
    this.lon,
    this.outOfTown,
    this.pointType,
    this.radius,
    this.region,
    this.regionType,
    this.street,
    this.streetType,
    this.streetWithType,
    this.type,
    this.unrestrictedValue,
    this.uuid,
    this.value,
  });

  int accuracyLevel;
  String category;
  String city;
  String cityType;
  String comment;
  String country;
  int frontDoor;
  String house;
  String houseType;
  var lat;
  var lon;
  bool outOfTown;
  String pointType;
  int radius;
  String region;
  String regionType;
  String street;
  String streetType;
  String streetWithType;
  String type;
  String unrestrictedValue;
  String uuid;
  String value;

  factory CityByCoordinates.fromJson(Map<String, dynamic> json) => CityByCoordinates(
    accuracyLevel: json["accuracy_level"],
    category: json["category"],
    city: json["city"],
    cityType: json["city_type"],
    comment: json["comment"],
    country: json["country"],
    frontDoor: json["front_door"],
    house: json["house"],
    houseType: json["house_type"],
    lat: json["lat"].toDouble(),
    lon: json["lon"].toDouble(),
    outOfTown: json["out_of_town"],
    pointType: json["point_type"],
    radius: json["radius"],
    region: json["region"],
    regionType: json["region_type"],
    street: json["street"],
    streetType: json["street_type"],
    streetWithType: json["street_with_type"],
    type: json["type"],
    unrestrictedValue: json["unrestricted_value"],
    uuid: json["uuid"],
    value: json["value"],
  );

  Map<String, dynamic> toJson() => {
    "accuracy_level": accuracyLevel,
    "category": category,
    "city": city,
    "city_type": cityType,
    "comment": comment,
    "country": country,
    "front_door": frontDoor,
    "house": house,
    "house_type": houseType,
    "lat": lat,
    "lon": lon,
    "out_of_town": outOfTown,
    "point_type": pointType,
    "radius": radius,
    "region": region,
    "region_type": regionType,
    "street": street,
    "street_type": streetType,
    "street_with_type": streetWithType,
    "type": type,
    "unrestricted_value": unrestrictedValue,
    "uuid": uuid,
    "value": value,
  };
}
