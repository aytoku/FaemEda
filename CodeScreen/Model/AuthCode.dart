import 'dart:convert';

import 'package:jwt_decoder/jwt_decoder.dart';

AuthCodeData authCodeDataFromJson(String str) => AuthCodeData.fromJson(json.decode(str));

String authCodeDataToJson(AuthCodeData data) => json.encode(data.toJson());

class AuthCodeData {
  AuthCodeData({
    this.clientUuid,
    this.token,
    this.service,
    this.refreshToken,
    this.userUUID
  });

  final String clientUuid;
  String token;
  final String service;
  final RefreshToken refreshToken;
  String userUUID;

  factory AuthCodeData.fromJson(Map<String, dynamic> json){

    return AuthCodeData(
      clientUuid: json["client_uuid"] == null ? null : json["client_uuid"],
      token: json["token"] == null ? null : json["token"],
      service: json["service"] == null ? null : json["service"],
      refreshToken: json["refresh_token"] == null ? null : RefreshToken.fromJson(json["refresh_token"]),
      userUUID: json["token"] == null ? null : JwtDecoder.decode(json["token"])['uuid']
    );
  }

  Map<String, dynamic> toJson() => {
    "client_uuid": clientUuid == null ? null : clientUuid,
    "token": token == null ? null : token,
    "service": service == null ? null : service,
    "refresh_token": refreshToken == null ? null : refreshToken.toJson(),
  };
}

class RefreshToken {
  RefreshToken({
    this.value,
    this.createdAt,
    this.expired,
  });

  String value;
  final DateTime createdAt;
  final int expired;

  factory RefreshToken.fromJson(Map<String, dynamic> json) => RefreshToken(
    value: json["value"] == null ? null : json["value"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    expired: json["expired"] == null ? null : json["expired"],
  );

  Map<String, dynamic> toJson() => {
    "value": value == null ? null : value,
    "created_at": createdAt == null ? null : createdAt.toIso8601String(),
    "expired": expired == null ? null : expired,
  };
}
