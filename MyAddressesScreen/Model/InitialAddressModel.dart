import 'package:flutter/foundation.dart';

class InitialAddressModel{
  InitialAddressModel({
    this.uuid,
    this.unrestrictedValue,
    this.value,
    this.country,
    this.region,
    this.regionType,
    this.city,
    this.cityType,
    this.street,
    this.streetType,
    this.streetWithType,
    this.house,
    this.outOfTown,
    this.houseType,
    this.accuracyLevel,
    this.radius,
    this.lat,
    this.lon,
    this.comment,
  });

  String unrestrictedValue;
  String uuid;
  String value;
  String country;
  String region;
  String regionType;
  String city;
  String cityType;
  String street;
  String streetType;
  String streetWithType;
  String house;
  bool outOfTown;
  String houseType;
  int accuracyLevel;
  int radius;
  var lat;
  var lon;
  String comment;
  String name; // Лишнее поле, для упрощения полиморфизма

  factory InitialAddressModel.fromJson(Map<String, dynamic> json) => InitialAddressModel(
      unrestrictedValue: json["unrestricted_value"],
      value: json["value"],
      uuid: json["uuid"],
      country: json["country"],
      region: json["region"],
      regionType: json["region_type"],
      city: json["city"],
      cityType: json["city_type"],
      street: json["street"],
      streetType: json["street_type"],
      streetWithType: json["street_with_type"],
      house: json["house"],
      outOfTown: json["out_of_town"],
      houseType: json["house_type"],
      accuracyLevel: json["accuracy_level"],
      radius: json["radius"],
      lat: json["lat"].toDouble(),
      lon: json["lon"].toDouble(),
      comment: json["comment"]
  );
  Map<String, dynamic> toJson() => {
    "unrestricted_value": unrestrictedValue,
    "value": value,
    "uuid": uuid,
    "country": country,
    "region": region,
    "region_type": regionType,
    "city": city,
    "city_type": cityType,
    "street": street,
    "street_type": streetType,
    "street_with_type": streetWithType,
    "house": house,
    "out_of_town": outOfTown,
    "house_type": houseType,
    "accuracy_level": accuracyLevel,
    "radius": radius,
    "lat": lat,
    "lon": lon,
    "comment": comment
  };
}