import 'dart:convert';

OrderDeposit orderRegistrationFromJson(String str) => OrderDeposit.fromJson(json.decode(str));

String orderRegistrationToJson(OrderDeposit data) => json.encode(data.toJson());

class OrderDeposit {
  OrderDeposit({
    this.errorCode,
  });

  final String errorCode;

  factory OrderDeposit.fromJson(Map<String, dynamic> json) => OrderDeposit(
    errorCode: !json.containsKey('errorCode') ? '' : json["errorCode"],
  );

  Map<String, dynamic> toJson() => {
    "errorCode": errorCode == null ? null : errorCode,
  };
}