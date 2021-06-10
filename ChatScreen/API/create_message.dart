import 'dart:convert';

import 'package:flutter_app/Screens/ChatScreen/Model/CreateMessage.dart';

import '../../../data/api.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

import '../../../data/globalVariables.dart';
import '../../../data/refreshToken.dart';

Future<Chat> createMessage(String message) async {

  Chat createMessage = null;
  var json_request = jsonEncode({
    "message": message
  });
  await SendRefreshToken.sendRefreshToken();
  var url = '${apiUrl}clients/messages';
  var response = await http.post(Uri.parse(url), body: json_request, headers: <String, String>{
    'Content-Type': 'application/json; charset=UTF-8',
    'Accept': 'application/json',
    "Application": header,
    'Authorization':'Bearer ' + authCodeData.token
  });
  if (response.statusCode == 200) {
    var jsonResponse = convert.jsonDecode(response.body);
    createMessage = new Chat.fromJson(jsonResponse);
  } else {
    print('Request failed with status: ${response.statusCode}.');
  }
  print(response.body);
  return createMessage;
}