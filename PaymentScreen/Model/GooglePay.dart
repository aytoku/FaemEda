import 'dart:convert' as convert;

class GooglePay {
  GooglePay({
    this.token,
  });

  final Token token;

  factory GooglePay.fromJson(Map<String, String> json) => GooglePay(
    token: Token.fromJson(convert.jsonDecode(json["token"])),
  );

  Map<String, dynamic> toJson() => {
    "token": token == null ? null : token.toJson(),
  };
}

class Token {
  Token({
    this.signature,
    this.protocolVersion,
    this.signedMessage
  });

  final String signature;
  final String protocolVersion;
  final SignedMessage signedMessage;

  factory Token.fromJson(Map<String, dynamic> json) => Token(
    signature: !json.containsKey('signature') ? '' : json["signature"],
    protocolVersion: !json.containsKey('protocolVersion') ? '' : json["protocolVersion"],
    signedMessage: SignedMessage.fromJson(convert.jsonDecode(json["signedMessage"])),
  );

  Map<String, dynamic> toJson() => {
    "signature": signature == null ? null : signature,
    "protocolVersion": protocolVersion == null ? null : protocolVersion,
    "signedMessage": signedMessage == null ? null : signedMessage.toJson(),
  };
}

class SignedMessage {
  SignedMessage({
    this.encryptedMessage,
    this.ephemeralPublicKey,
    this.tag,
  });

  final String encryptedMessage;
  final String ephemeralPublicKey;
  final String tag;

  factory SignedMessage.fromJson(Map<String, dynamic> json) => SignedMessage(
    encryptedMessage: !json.containsKey('encryptedMessage') ? '' : json["encryptedMessage"],
    ephemeralPublicKey: !json.containsKey('ephemeralPublicKey') ? '' : json["ephemeralPublicKey"],
    tag: !json.containsKey('tag') ? '' : json["tag"],
  );

  Map<String, dynamic> toJson() => {
    "encryptedMessage": encryptedMessage == null ? null : encryptedMessage,
    "ephemeralPublicKey": ephemeralPublicKey == null ? null : ephemeralPublicKey,
    "tag": tag == null ? null : tag,
  };
}