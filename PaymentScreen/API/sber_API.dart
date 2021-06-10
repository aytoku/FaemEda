import 'dart:convert';
import 'package:flutter_app/Screens/PaymentScreen/Model/GooglePay.dart';
import 'package:flutter_app/Screens/PaymentScreen/Model/OrderDeposit.dart';
import 'package:flutter_app/Screens/PaymentScreen/Model/OrderRefund.dart';
import 'package:flutter_app/Screens/PaymentScreen/Model/OrderRegistration.dart';
import 'package:flutter_app/Screens/PaymentScreen/Model/OrderReverse.dart';
import 'package:flutter_app/Screens/PaymentScreen/Model/OrderStatus.dart';
import 'package:flutter_app/Screens/PaymentScreen/Model/SberApplePayment.dart';
import 'package:flutter_app/Screens/PaymentScreen/Model/SberGooglePayment.dart';
import 'package:flutter_app/data/api.dart';
import 'package:flutter_app/data/data.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

import '../../../data/api.dart';
import '../../../data/globalVariables.dart';

class SberAPI{

  static String sberToken = 'h1ed6cv2f93cm8teci2b63aeeg';
  static String returnUrl = 'https://mail.ru/';
  static String failUrl = 'https://yandex.ru/';
  static String language = 'ru';
  static String clientId = '11';
  static String pageView = 'MOBILE';
  static String orderNumber = '';
  static int amount = 0;


  static Future<SberGooglePayment> googlePay(Map<String, String> googlePay, String uuid) async {
    SberGooglePayment sberGooglePayment = null;
    var request = convert.jsonEncode({
      'merchant': 'P1513081007',
      'orderNumber': orderNumber,
      'paymentToken': convert.base64Encode(utf8.encode(googlePay['token'])),
      'amount': amount,
      'phone': currentUser.phone,
      'returnUrl': returnUrl,
      'failUrl': failUrl,
    });
    var url = '${apiUrl}googlepay/$uuid';
    var response = await http.post(Uri.parse(url), body: request, headers: <String, String>{
      'Content-Type': 'application/json',
      'Authorization':'Bearer ' + authCodeData.token
    });
    print(response.body);
    if (response.statusCode == 200) {
      var jsonResponse = convert.jsonDecode(response.body);
      sberGooglePayment = new SberGooglePayment.fromJson(jsonResponse);
    } else {
      print('Request failed with status: ${response.statusCode}.');
    }

    print(response.body);
    return sberGooglePayment;
  }


  static Future<SberGooglePayment> applePay(Map<String, String> applePay, String uuid) async {
    SberGooglePayment applePaymentSuccess = null;
    var request = convert.jsonEncode({
      'merchant': 'P1513081007',
      'orderNumber': orderNumber,
      'paymentToken': convert.base64Encode(utf8.encode(applePay['token'])),
    });
    var url = '${apiUrl}applepay/$uuid';
    var response = await http.post(Uri.parse(url), body: request, headers: <String, String>{
      'Content-Type': 'application/json',
      'Authorization':'Bearer ' + authCodeData.token
    });
    print(response.body);
    if (response.statusCode == 200) {
      var jsonResponse = convert.jsonDecode(response.body);
      applePaymentSuccess = new SberGooglePayment.fromJson(jsonResponse);
    } else {
      print('Request failed with status: ${response.statusCode}.');
    }

    print(response.body);
    return applePaymentSuccess;
  }
}