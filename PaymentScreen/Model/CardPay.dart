class CardPay {
  CardPay({
    this.errorCode,
    this.errorMessage,
    this.formUrl,
    this.orderId,
  });

  final String errorCode;
  final String errorMessage;
  final String formUrl;
  final String orderId;

  factory CardPay.fromJson(Map<String, dynamic> json) => CardPay(
    errorCode: json["errorCode"] == null ? null : json["errorCode"],
    errorMessage: json["errorMessage"] == null ? null : json["errorMessage"],
    formUrl: json["formUrl"] == null ? null : json["formUrl"],
    orderId: json["orderId"] == null ? null : json["orderId"],
  );

  Map<String, dynamic> toJson() => {
    "errorCode": errorCode == null ? null : errorCode,
    "errorMessage": errorMessage == null ? null : errorMessage,
    "formUrl": formUrl == null ? null : formUrl,
    "orderId": orderId == null ? null : orderId,
  };
}