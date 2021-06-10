// To parse this JSON data, do
//
//     final cartModel = cartModelFromJson(jsonString);

import 'dart:convert';

import 'package:flutter_app/Screens/HomeScreen/Model/FilteredStores.dart';
import 'package:flutter_app/Screens/RestaurantScreen/Model/BaseProductModel.dart';
import 'package:flutter_app/Screens/RestaurantScreen/Model/ProductsByStoreUuid.dart';
import 'package:flutter_app/data/data.dart';

List<CartModel> cartModelFromJson(String str) => List<CartModel>.from(json.decode(str).map((x) => CartModel.fromJson(x)));

String cartModelToJson(List<CartModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));


class CartModelData{
  List<CartModel> cartModelList;

  CartModelData( {
    this.cartModelList,
  });

  factory CartModelData.fromJson(List<dynamic> parsedJson){
    List<CartModel> cartList = null;
    if(parsedJson != null){
      cartList = parsedJson.map((i) => CartModel.fromJson(i)).toList();
    }

    return CartModelData(
      cartModelList:cartList,
    );
  }
}

class CartModel {
  CartModel({
    this.uuid,
    this.id,
    this.storeUuid,
    this.storeData,
    this.deviceId,
    this.clientUuid,
    this.clientData,
    this.source,
    this.state,
    this.callbackPhone,
    this.comment,
    this.cancel,
    this.items,
    this.paymentType,
    this.totalPrice,
    this.productsPrice,
    this.ownDelivery,
    this.withoutDelivery,
    this.eatInStore,
    this.cookingTime,
    this.cookingTimeFinish,
    this.lastUpdateUuid,
    this.lastUpdateRole,
    this.cancelReason,
    this.deliveryData,
    this.cancelComment,
    this.createdAt,
    this.promotion
  });

  final String uuid;
  final String id;
  final String storeUuid;
  final StoreData storeData;
  final String deviceId;
  final String clientUuid;
  final ClientData clientData;
  final String source;
  final String state;
  final String callbackPhone;
  final String comment;
  final Cancel cancel;
  final List<Item> items;
  final String paymentType;
  final double totalPrice;
  final double productsPrice;
  final bool ownDelivery;
  final bool withoutDelivery;
  final bool eatInStore;
  final DeliveryData deliveryData;
  final int cookingTime;
  final DateTime cookingTimeFinish;
  final String lastUpdateUuid;
  final String lastUpdateRole;
  final String cancelReason;
  final String cancelComment;
  final DateTime createdAt;
  final Promotion promotion;

  factory CartModel.fromJson(Map<String, dynamic> json) => CartModel(
    uuid: json["uuid"] == null ? null : json["uuid"],
    id: json["id"] == null ? null : json["id"],
    storeUuid: json["store_uuid"] == null ? null : json["store_uuid"],
    storeData: json["store_data"] == null ? null : StoreData.fromJson(json["store_data"]),
    deviceId: json["device_id"] == null ? null : json["device_id"],
    clientUuid: json["client_uuid"] == null ? null : json["client_uuid"],
    clientData: json["client_data"] == null ? null : ClientData.fromJson(json["client_data"]),
    source: json["source"] == null ? null : json["source"],
    state: json["state"] == null ? null : json["state"],
    callbackPhone: json["callback_phone"] == null ? null : json["callback_phone"],
    comment: json["comment"] == null ? null : json["comment"],
    cancel: json["cancel"] == null ? null : Cancel.fromJson(json["cancel"]),
    items: json["items"] == null ? null : List<Item>.from(json["items"].map((x) => Item.fromJson(x))),
    paymentType: json["payment_type"] == null ? null : json["payment_type"],
    totalPrice: json["total_price"] == null ? null : json["total_price"] * 1.0,
    productsPrice: json["products_price"] == null ? null : json["products_price"] * 1.0,
    ownDelivery: json["own_delivery"] == null ? null : json["own_delivery"],
    withoutDelivery: json["without_delivery"] == null ? null : json["without_delivery"],
    deliveryData: json["delivery_data"] == null ? null : DeliveryData.fromJson(json["delivery_data"]),
    eatInStore: json["eat_in_store"] == null ? null : json["eat_in_store"],
    cookingTime: json["cooking_time"] == null ? null : json["cooking_time"],
    cookingTimeFinish: json["cooking_time_finish"] == null ? null : DateTime.parse(json["cooking_time_finish"]),
    lastUpdateUuid: json["last_update_uuid"] == null ? null : json["last_update_uuid"],
    lastUpdateRole: json["last_update_role"] == null ? null : json["last_update_role"],
    cancelReason: json["cancel_reason"] == null ? null : json["cancel_reason"],
    cancelComment: json["cancel_comment"] == null ? null : json["cancel_comment"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    promotion: json["promotion"] == null ? null : Promotion.fromJson(json["promotion"]),
  );

  Map<String, dynamic> toJson() => {
    "uuid": uuid == null ? null : uuid,
    "id": id == null ? null : id,
    "store_uuid": storeUuid == null ? null : storeUuid,
    "store_data": storeData == null ? null : storeData.toJson(),
    "device_id": deviceId == null ? null : deviceId,
    "client_uuid": clientUuid == null ? null : clientUuid,
    "client_data": clientData == null ? null : clientData.toJson(),
    "source": source == null ? null : source,
    "state": state == null ? null : state,
    "callback_phone": callbackPhone == null ? null : callbackPhone,
    "comment": comment == null ? null : comment,
    "cancel": cancel == null ? null : cancel.toJson(),
    "items": items == null ? null : List<dynamic>.from(items.map((x) => x.toJson())),
    "payment_type": paymentType == null ? null : paymentType,
    "total_price": totalPrice == null ? null : totalPrice,
    "products_price": productsPrice == null ? null : productsPrice,
    "own_delivery": ownDelivery == null ? null : ownDelivery,
    "without_delivery": withoutDelivery == null ? null : withoutDelivery,
    "eat_in_store": eatInStore == null ? null : eatInStore,
    "delivery_data": deliveryData == null ? null : deliveryData.toJson(),
    "cooking_time": cookingTime == null ? null : cookingTime,
    "cooking_time_finish": cookingTimeFinish == null ? null : cookingTimeFinish.toIso8601String(),
    "last_update_uuid": lastUpdateUuid == null ? null : lastUpdateUuid,
    "last_update_role": lastUpdateRole == null ? null : lastUpdateRole,
    "cancel_reason": cancelReason == null ? null : cancelReason,
    "cancel_comment": cancelComment == null ? null : cancelComment,
    "created_at": createdAt == null ? null : createdAt.toIso8601String(),
    "promotion": promotion == null ? null : promotion.toJson(),
  };

  Item findCartItem(BaseProductModel product){
    var item;
    try {
      item = currentUser.cartModel.items.firstWhere((element) => element.product.uuid == product.uuid);
    }catch(e){
      item = null;
    }
    return item;
  }
}

class DeliveryData {
  DeliveryData({
    this.price,
    this.estimatedTime,
    this.type,
    this.address,
    this.addressDetails,
  });

  final double price;
  final int estimatedTime;
  final String type;
  final Address address;
  final AddressDetails addressDetails;

  factory DeliveryData.fromJson(Map<String, dynamic> json) => DeliveryData(
    price: json["price"] == null ? null : json["price"] * 1.0,
    estimatedTime: json["estimated_time"] == null ? null : json["estimated_time"],
    type: json["type"] == null ? null : json["type"],
    address: json["address"] == null ? null : Address.fromJson(json["address"]),
    addressDetails: json["address_details"] == null ? null : AddressDetails.fromJson(json["address_details"]),
  );

  Map<String, dynamic> toJson() => {
    "price": price == null ? null : price,
    "estimated_time": estimatedTime == null ? null : estimatedTime,
    "type": type == null ? null : type,
    "address": address == null ? null : address.toJson(),
    "address_details": addressDetails == null ? null : addressDetails.toJson(),
  };
}

class AddressDetails {
  AddressDetails({
    this.entrance,
    this.floor,
    this.apartment,
    this.intercom,
  });

  final String entrance;
  final String floor;
  final String apartment;
  final String intercom;

  factory AddressDetails.fromJson(Map<String, dynamic> json) => AddressDetails(
    entrance: json["entrance"] == null ? null : json["entrance"],
    floor: json["floor"] == null ? null : json["floor"],
    apartment: json["apartment"] == null ? null : json["apartment"],
    intercom: json["intercom"] == null ? null : json["intercom"],
  );

  Map<String, dynamic> toJson() => {
    "entrance": entrance == null ? null : entrance,
    "floor": floor == null ? null : floor,
    "apartment": apartment == null ? null : apartment,
    "intercom": intercom == null ? null : intercom,
  };
}

class Promotion {
  Promotion({
    this.uuid,
    this.billingAccountUUID,
    this.discountPercentage,
    this.promoCode,
  });

  final String uuid;
  final String billingAccountUUID;
  final double discountPercentage;
  final String promoCode;

  factory Promotion.fromJson(Map<String, dynamic> json) => Promotion(
    uuid: json["uuid"] == null ? null : json["uuid"],
    billingAccountUUID: json["billing_account_uuid"] == null ? null : json["billing_account_uuid"],
    discountPercentage: (json["discount_percentage"] != null) ? json["discount_percentage"] * 1.0 :
    (json["amount"] != null) ? json['amount'] * 1.0 : null,
    promoCode: json["promo_code"] == null ? null : json["promo_code"],
  );

  Map<String, dynamic> toJson() => {
    "uuid": uuid == null ? null : uuid,
    "billing_account_uuid": billingAccountUUID == null ? null : billingAccountUUID,
    "discount_percentage": discountPercentage,
    "promo_code": promoCode == null ? null : promoCode,
  };
}

class Cancel {
  Cancel({
    this.uuid,
    this.role,
    this.reason,
    this.comment,
  });

  final String uuid;
  final String role;
  final String reason;
  final String comment;

  factory Cancel.fromJson(Map<String, dynamic> json) => Cancel(
    uuid: json["uuid"] == null ? null : json["uuid"],
    role: json["role"] == null ? null : json["role"],
    reason: json["reason"] == null ? null : json["reason"],
    comment: json["comment"] == null ? null : json["comment"],
  );

  Map<String, dynamic> toJson() => {
    "uuid": uuid == null ? null : uuid,
    "role": role == null ? null : role,
    "reason": reason == null ? null : reason,
    "comment": comment == null ? null : comment,
  };
}

class ClientData {
  ClientData({
    this.uuid,
    this.name,
    this.comment,
    this.mainPhone,
    this.devices,
    this.blocked,
    this.addresses,
    this.meta,
  });

  final String uuid;
  final String name;
  final String comment;
  final String mainPhone;
  final dynamic devices;
  final bool blocked;
  final dynamic addresses;
  final ClientDataMeta meta;

  factory ClientData.fromJson(Map<String, dynamic> json) => ClientData(
    uuid: json["uuid"] == null ? null : json["uuid"],
    name: json["name"] == null ? null : json["name"],
    comment: json["comment"] == null ? null : json["comment"],
    mainPhone: json["main_phone"] == null ? null : json["main_phone"],
    devices: json["devices"],
    blocked: json["blocked"] == null ? null : json["blocked"],
    addresses: json["addresses"],
    meta: json["meta"] == null ? null : ClientDataMeta.fromJson(json["meta"]),
  );

  Map<String, dynamic> toJson() => {
    "uuid": uuid == null ? null : uuid,
    "name": name == null ? null : name,
    "comment": comment == null ? null : comment,
    "main_phone": mainPhone == null ? null : mainPhone,
    "devices": devices,
    "blocked": blocked == null ? null : blocked,
    "addresses": addresses,
    "meta": meta == null ? null : meta.toJson(),
  };
}

class ClientDataMeta {
  ClientDataMeta();

  factory ClientDataMeta.fromJson(Map<String, dynamic> json) => ClientDataMeta(
  );

  Map<String, dynamic> toJson() => {
  };
}

class Item {
  Item({
    this.id,
    this.product,
    this.variantGroups,
    this.price,
    this.count,
    this.singleItemPrice,
    this.totalItemPrice
  });

  final int id;
  final Product product;
  final List<VariantGroup> variantGroups;
  final double price;
  int count;
  final double singleItemPrice;
  final double totalItemPrice;


  factory Item.fromJson(Map<String, dynamic> json) => Item(
    id: json["id"] == null ? null : json["id"],
    product: json["product"] == null ? null : Product.fromJson(json["product"]),
    variantGroups: json["variant_groups"] == null ? null : List<VariantGroup>.from(json["variant_groups"].map((x) => VariantGroup.fromJson(x))),
    price: json["price"] == null ? null : json["price"] * 1.0,
    count: json["count"] == null ? null : json["count"],
    singleItemPrice: json["single_item_price"] == null ? null : json["single_item_price"] * 1.0,
    totalItemPrice: json["total_item_price"] == null ? null : json["total_item_price"] * 1.0,
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "product": product == null ? null : product.toJson(),
    "variant_groups": variantGroups == null ? null : List<dynamic>.from(variantGroups.map((x) => x.toJson())),
    "price": price == null ? null : price,
    "count": count == null ? null : count,
  };

  String getUniqueUuid(){
    String result = product.uuid;
    if(variantGroups != null)
      variantGroups.forEach((element) {
        result+=element.uuid;
        if(element.variants != null)
          element.variants.forEach((element) {
            result+=element.uuid;
          });
      });
    return result;
  }

}

class Product {
  Product({
    this.uuid,
    this.name,
    this.storeUuid,
    this.type,
    this.price,
    this.weight,
    this.weightMeasurement,
    this.meta,
    this.productCategories,
  });

  final String uuid;
  final String name;
  final String storeUuid;
  final String type;
  final double price;
  final double weight;
  final String weightMeasurement;
  final ProductMeta meta;
  final dynamic productCategories;

  static String formatWeights (String input) {
    final nbsp = String.fromCharCode(0x00A0);
    final matches = RegExp(r'(\d{1,4}\,?\d{0,3}) (.{1,2})').allMatches(input);

    matches.forEach((match) {
      input = input.replaceRange(match.start, match.end, input.substring(match.start, match.end).replaceFirst(' ', nbsp));
    });
    return input;
  }

  factory Product.fromJson(Map<String, dynamic> json) => Product(
    uuid: json["uuid"] == null ? null : json["uuid"],
    name: json["name"] == null ? null : formatWeights(json["name"]),
    storeUuid: json["store_uuid"] == null ? null : json["store_uuid"],
    type: json["type"] == null ? null : json["type"],
    price: json["price"] == null ? null : json["price"] * 1.0,
    weight: json["weight"] == null ? null : json["weight"] * 1.0,
    weightMeasurement: json["weight_measurement"] == null ? null : json["weight_measurement"],
    meta: json["meta"] == null ? null : ProductMeta.fromJson(json["meta"]),
    productCategories: json["product_categories"],
  );

  Map<String, dynamic> toJson() => {
    "uuid": uuid == null ? null : uuid,
    "name": name == null ? null : name,
    "store_uuid": storeUuid == null ? null : storeUuid,
    "type": type == null ? null : type,
    "price": price == null ? null : price,
    "weight": weight == null ? null : weight,
    "weight_measurement": weightMeasurement == null ? null : weightMeasurement,
    "meta": meta == null ? null : meta.toJson(),
    "product_categories": productCategories,
  };
}

class ProductMeta {
  ProductMeta({
    this.description,
    this.composition,
    this.weight,
    this.weightMeasurement,
    this.images,
    this.energyValue,
  });

  final String description;
  final String composition;
  final double weight;
  final String weightMeasurement;
  final List<String> images;
  final EnergyValue energyValue;

  factory ProductMeta.fromJson(Map<String, dynamic> json) => ProductMeta(
    description: json["description"] == null ? null : json["description"],
    composition: json["composition"] == null ? null : json["composition"],
    weight: json["weight"] == null ? null : json["weight"] * 1.0,
    weightMeasurement: json["weight_measurement"] == null ? null : json["weight_measurement"],
    images: json["images"] == null ? null : List<String>.from(json["images"].map((x) => x)),
    energyValue: json["energy_value"] == null ? null : EnergyValue.fromJson(json["energy_value"]),
  );

  Map<String, dynamic> toJson() => {
    "description": description == null ? null : description,
    "composition": composition == null ? null : composition,
    "weight": weight == null ? null : weight,
    "weight_measurement": weightMeasurement == null ? null : weightMeasurement,
    "images": images == null ? null : List<dynamic>.from(images.map((x) => x)),
    "energy_value": energyValue == null ? null : energyValue.toJson(),
  };
}

class EnergyValue {
  EnergyValue({
    this.protein,
    this.fat,
    this.carbohydrates,
    this.calories,
  });

  final int protein;
  final int fat;
  final int carbohydrates;
  final int calories;

  factory EnergyValue.fromJson(Map<String, dynamic> json) => EnergyValue(
    protein: json["protein"] == null ? null : json["protein"],
    fat: json["fat"] == null ? null : json["fat"],
    carbohydrates: json["carbohydrates"] == null ? null : json["carbohydrates"],
    calories: json["calories"] == null ? null : json["calories"],
  );

  Map<String, dynamic> toJson() => {
    "protein": protein == null ? null : protein,
    "fat": fat == null ? null : fat,
    "carbohydrates": carbohydrates == null ? null : carbohydrates,
    "calories": calories == null ? null : calories,
  };
}

class VariantGroup {
  VariantGroup({
    this.uuid,
    this.name,
    this.productUuid,
    this.required,
    this.multiselect,
    this.description,
    this.meta,
    this.variants,
  });

  final String uuid;
  final String name;
  final String productUuid;
  final bool required;
  final bool multiselect;
  final String description;
  final ClientDataMeta meta;
  final List<Variant> variants;

  factory VariantGroup.fromJson(Map<String, dynamic> json) => VariantGroup(
    uuid: json["uuid"] == null ? null : json["uuid"],
    name: json["name"] == null ? null : json["name"],
    productUuid: json["product_uuid"] == null ? null : json["product_uuid"],
    required: json["required"] == null ? null : json["required"],
    multiselect: json["multiselect"] == null ? null : json["multiselect"],
    description: json["description"] == null ? null : json["description"],
    meta: json["meta"] == null ? null : ClientDataMeta.fromJson(json["meta"]),
    variants: json["variants"] == null ? null : List<Variant>.from(json["variants"].map((x) => Variant.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "uuid": uuid == null ? null : uuid,
    "name": name == null ? null : name,
    "product_uuid": productUuid == null ? null : productUuid,
    "required": required == null ? null : required,
    "multiselect": multiselect == null ? null : multiselect,
    "description": description == null ? null : description,
    "meta": meta == null ? null : meta.toJson(),
    "variants": variants == null ? null : List<dynamic>.from(variants.map((x) => x.toJson())),
  };
}

class Variant {
  Variant({
    this.uuid,
    this.name,
    this.productUuid,
    this.variantGroupUuid,
    this.price,
    this.description,
    this.variantDefault,
    this.meta,
  });

  final String uuid;
  final String name;
  final String productUuid;
  final String variantGroupUuid;
  final double price;
  final String description;
  final bool variantDefault;
  final VariantMeta meta;

  factory Variant.fromJson(Map<String, dynamic> json) => Variant(
    uuid: json["uuid"] == null ? null : json["uuid"],
    name: json["name"] == null ? null : json["name"],
    productUuid: json["product_uuid"] == null ? null : json["product_uuid"],
    variantGroupUuid: json["variant_group_uuid"] == null ? null : json["variant_group_uuid"],
    price: json["price"] == null ? null : json["price"]  * 1.0,
    description: json["description"] == null ? null : json["description"],
    variantDefault: json["default"] == null ? null : json["default"],
    meta: json["meta"] == null ? null : VariantMeta.fromJson(json["meta"]),
  );

  Map<String, dynamic> toJson() => {
    "uuid": uuid == null ? null : uuid,
    "name": name == null ? null : name,
    "product_uuid": productUuid == null ? null : productUuid,
    "variant_group_uuid": variantGroupUuid == null ? null : variantGroupUuid,
    "price": price == null ? null : price,
    "description": description == null ? null : description,
    "default": variantDefault == null ? null : variantDefault,
    "meta": meta == null ? null : meta.toJson(),
  };
}

class VariantMeta {
  VariantMeta({
    this.description,
    this.images,
  });

  final String description;
  final List<String> images;

  factory VariantMeta.fromJson(Map<String, dynamic> json) => VariantMeta(
    description: json["description"] == null ? null : json["description"],
    images: json["images"] == null ? null : List<String>.from(json["images"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "description": description == null ? null : description,
    "images": images == null ? null : List<dynamic>.from(images.map((x) => x)),
  };
}

class StoreData {
  StoreData({
    this.uuid,
    this.name,
    this.storeCategoriesUuid,
    this.productCategoriesUuid,
    this.paymentTypes,
    this.cityUuid,
    this.legalEntityUuid,
    this.parentUuid,
    this.available,
    this.type,
    this.workSchedule,
    this.address,
    this.contacts,
    this.priority,
    this.lat,
    this.lon,
    this.ownDelivery,
    this.url,
    this.meta,
  });

  final String uuid;
  final String name;
  final List<String> storeCategoriesUuid;
  final List<String> productCategoriesUuid;
  final List<String> paymentTypes;
  final String cityUuid;
  final String legalEntityUuid;
  final String parentUuid;
  final Available available;
  final String type;
  final WorkSchedule workSchedule;
  final Address address;
  final List<Contact> contacts;
  final int priority;
  final double lat;
  final double lon;
  final bool ownDelivery;
  final String url;
  final StoreDataMeta meta;

  factory StoreData.fromJson(Map<String, dynamic> json) => StoreData(
    uuid: json["uuid"] == null ? null : json["uuid"],
    name: json["name"] == null ? null : json["name"],
    storeCategoriesUuid: json["store_categories_uuid"] == null ? null : List<String>.from(json["store_categories_uuid"].map((x) => x)),
    productCategoriesUuid: json["product_categories_uuid"] == null ? null : List<String>.from(json["product_categories_uuid"].map((x) => x)),
    paymentTypes: json["payment_types"] == null ? null : List<String>.from(json["payment_types"].map((x) => x)),
    cityUuid: json["city_uuid"] == null ? null : json["city_uuid"],
    legalEntityUuid: json["legal_entity_uuid"] == null ? null : json["legal_entity_uuid"],
    parentUuid: json["parent_uuid"] == null ? null : json["parent_uuid"],
    available: json["available"] == null ? null : Available.fromJson(json["available"]),
    type: json["type"] == null ? null : json["type"],
    workSchedule: json["work_schedule"] == null ? null : WorkSchedule.fromJson(json["work_schedule"]),
    address: json["address"] == null ? null : Address.fromJson(json["address"]),
    contacts: json["contacts"] == null ? null : List<Contact>.from(json["contacts"].map((x) => Contact.fromJson(x))),
    priority: json["priority"] == null ? null : json["priority"],
    lat: json["lat"] == null ? null : json["lat"] * 1.0,
    lon: json["lon"] == null ? null : json["lon"] * 1.0,
    ownDelivery: json["own_delivery"] == null ? null : json["own_delivery"],
    url: json["url"] == null ? null : json["url"],
    meta: json["meta"] == null ? null : StoreDataMeta.fromJson(json["meta"]),
  );

  Map<String, dynamic> toJson() => {
    "uuid": uuid == null ? null : uuid,
    "name": name == null ? null : name,
    "payment_types": paymentTypes == null ? null : List<dynamic>.from(paymentTypes.map((x) => x)),
    "city_uuid": cityUuid == null ? null : cityUuid,
    "legal_entity_uuid": legalEntityUuid == null ? null : legalEntityUuid,
    "parent_uuid": parentUuid == null ? null : parentUuid,
    "available": available == null ? null : available.toJson(),
    "type": type == null ? null : type,
    "work_schedule": workSchedule == null ? null : workSchedule.toJson(),
    "address": address == null ? null : address.toJson(),
    "contacts": contacts == null ? null : List<dynamic>.from(contacts.map((x) => x.toJson())),
    "priority": priority == null ? null : priority,
    "lat": lat == null ? null : lat,
    "lon": lon == null ? null : lon,
    "own_delivery": ownDelivery == null ? null : ownDelivery,
    "url": url == null ? null : url,
    "meta": meta == null ? null : meta.toJson(),
  };
}

class StoreDataMeta {
  StoreDataMeta({
    this.images,
    this.rating,
    this.avgDeliveryTime,
    this.minOrderPrice,
    this.avgDeliveryPrice,
    this.description,
    this.confirmationTime,
    this.cookingTime,
  });

  final List<String> images;
  final double rating;
  final String avgDeliveryTime;
  final int minOrderPrice;
  final String avgDeliveryPrice;
  final String description;
  final int confirmationTime;
  final int cookingTime;

  factory StoreDataMeta.fromJson(Map<String, dynamic> json) => StoreDataMeta(
    images: json["images"] == null ? null : List<String>.from(json["images"].map((x) => x)),
    rating: json["rating"] == null ? null : json["rating"].toDouble(),
    avgDeliveryTime: json["delivery_time"] == null ? null : json["delivery_time"],
    minOrderPrice: json["min_order_price"] == null ? null : json["min_order_price"].toInt(),
    avgDeliveryPrice: json["delivery_price"] == null ? null : json["delivery_price"],
    description: json["description"] == null ? null : json["description"],
    confirmationTime: json["confirmation_time"] == null ? null : json["confirmation_time"],
    cookingTime: json["cooking_time"] == null ? null : json["cooking_time"],
  );

  Map<String, dynamic> toJson() => {
    "images": images == null ? null : List<dynamic>.from(images.map((x) => x)),
    "rating": rating == null ? null : rating,
    "delivery_time": avgDeliveryTime == null ? null : avgDeliveryTime,
    "min_order_price": minOrderPrice == null ? null : minOrderPrice,
    "delivery_price": avgDeliveryPrice == null ? null : avgDeliveryPrice,
    "description": description == null ? null : description,
    "confirmation_time": confirmationTime == null ? null : confirmationTime,
    "cooking_time": cookingTime == null ? null : cookingTime,
  };
}
