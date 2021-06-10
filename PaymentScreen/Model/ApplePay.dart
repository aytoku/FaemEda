import 'dart:convert';

class ApplePay {
  ApplePay({
    this.paymentData,
    this.transactionIdentifier,
    this.paymentMethod,
  });

  final PaymentData paymentData;
  final String transactionIdentifier;
  final PaymentMethod paymentMethod;

  factory ApplePay.fromJson(Map<String, dynamic> json) => ApplePay(
    paymentData: json["paymentData"] == null ? null : PaymentData.fromJson(json["paymentData"]),
    transactionIdentifier: json["transactionIdentifier"] == null ? null : json["transactionIdentifier"],
    paymentMethod: json["paymentMethod"] == null ? null : PaymentMethod.fromJson(json["paymentMethod"]),
  );

  Map<String, dynamic> toJson() => {
    "paymentData": paymentData == null ? null : paymentData.toJson(),
    "transactionIdentifier": transactionIdentifier == null ? null : transactionIdentifier,
    "paymentMethod": paymentMethod == null ? null : paymentMethod.toJson(),
  };
}

class PaymentData {
  PaymentData({
    this.data,
    this.signature,
    this.header,
    this.version,
  });

  final String data;
  final String signature;
  final Header header;
  final String version;

  factory PaymentData.fromJson(Map<String, dynamic> json) => PaymentData(
    data: json["data"] == null ? null : json["data"],
    signature: json["signature"] == null ? null : json["signature"],
    header: json["header"] == null ? null : Header.fromJson(json["header"]),
    version: json["version"] == null ? null : json["version"],
  );

  Map<String, dynamic> toJson() => {
    "data": data == null ? null : data,
    "signature": signature == null ? null : signature,
    "header": header == null ? null : header.toJson(),
    "version": version == null ? null : version,
  };
}

class Header {
  Header({
    this.publicKeyHash,
    this.ephemeralPublicKey,
    this.transactionId,
  });

  final String publicKeyHash;
  final String ephemeralPublicKey;
  final String transactionId;

  factory Header.fromJson(Map<String, dynamic> json) => Header(
    publicKeyHash: json["publicKeyHash"] == null ? null : json["publicKeyHash"],
    ephemeralPublicKey: json["ephemeralPublicKey"] == null ? null : json["ephemeralPublicKey"],
    transactionId: json["transactionId"] == null ? null : json["transactionId"],
  );

  Map<String, dynamic> toJson() => {
    "publicKeyHash": publicKeyHash == null ? null : publicKeyHash,
    "ephemeralPublicKey": ephemeralPublicKey == null ? null : ephemeralPublicKey,
    "transactionId": transactionId == null ? null : transactionId,
  };
}

class PaymentMethod {
  PaymentMethod({
    this.network,
    this.type,
    this.displayName,
  });

  final String network;
  final String type;
  final String displayName;

  factory PaymentMethod.fromJson(Map<String, dynamic> json) => PaymentMethod(
    network: json["network"] == null ? null : json["network"],
    type: json["type"] == null ? null : json["type"],
    displayName: json["displayName"] == null ? null : json["displayName"],
  );

  Map<String, dynamic> toJson() => {
    "network": network == null ? null : network,
    "type": type == null ? null : type,
    "displayName": displayName == null ? null : displayName,
  };
}