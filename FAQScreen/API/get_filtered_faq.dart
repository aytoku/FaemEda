import 'package:flutter_app/Screens/FAQScreen/Model/FAQ.dart';
import 'package:flutter_app/Screens/HomeScreen/Model/FilteredStores.dart';
import 'package:flutter_app/data/api.dart';
import 'package:flutter_app/data/globalVariables.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

import '../../../data/globalVariables.dart';
import '../../../data/refreshToken.dart';


Future<FAQData> getFilteredFaq() async {
  await SendRefreshToken.sendRefreshToken();
  FAQData faq;
  var url = '${apiUrl}faq/filter?application=$header&page=1&limit=10';
  var response = await http.get(Uri.parse(url), headers: <String, String>{
    'Content-Type': 'application/json; charset=UTF-8',
    'Authorization':'Bearer ' + authCodeData.token,
  });
  if (response.statusCode == 200) {
    var jsonResponse = convert.jsonDecode(response.body);
    faq = new FAQData.fromJson(jsonResponse);
  } else {
    print('Request failed with status: ${response.statusCode}.');
  }
  print(response.body);
  return faq;
}