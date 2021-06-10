import 'dart:convert';
import 'package:flutter_app/Screens/CodeScreen/Model/AuthCode.dart';
import 'package:flutter_app/Screens/PaymentScreen/Model/CardPay.dart';
import 'package:flutter_app/data/api.dart';
import 'package:flutter_app/data/globalVariables.dart';
import 'package:flutter_app/data/refreshToken.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

Future<CardPay> cardPay(String uuid) async {
  await SendRefreshToken.sendRefreshToken();

  CardPay cardPay = null;

  var url = '${apiUrl}card/${uuid}';
  var response = await http.post(Uri.parse(url), headers: <String, String>{
    'Content-Type': 'application/json; charset=UTF-8',
    "Application": "eda/pomidor",
    'Authorization':'Bearer ' + authCodeData.token,
  });
  if (response.statusCode == 200) {
    var jsonResponse = convert.jsonDecode(response.body);
    cardPay = new CardPay.fromJson(jsonResponse);
  } else {
    print('Request failed with status: ${response.statusCode}.');
  }
  print(response.body + "CARDPAY");
  return cardPay;
}