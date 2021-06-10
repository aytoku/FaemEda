import 'package:flutter_app/Screens/ChatScreen/Model/CreateMessage.dart';
import 'package:flutter_app/data/api.dart';
import 'package:flutter_app/data/globalVariables.dart';
import 'package:flutter_app/data/refreshToken.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;


Future<ChatData> getFilteredMessage() async {
  await SendRefreshToken.sendRefreshToken();
  ChatData chatData = null;
  var url = '${apiUrl}clients/messages/filter';
  var response = await http.get(Uri.parse(url), headers: <String, String>{
    'Content-Type': 'application/json; charset=UTF-8',
    'Accept': 'application/json',
    "Application": header,
    'Authorization':'Bearer ' + authCodeData.token
  });
  if (response.statusCode == 200) {
    var jsonResponse = convert.jsonDecode(response.body);
    chatData = new ChatData.fromJson(jsonResponse);
  } else {
    print('Request failed with status: ${response.statusCode}.');
  }
  print(response.body);
  return chatData;
}

Future<String> getChatUuid() async{
  var filteredMessages = await getFilteredMessage();
  if(filteredMessages == null || filteredMessages.chat.length == 0){
    return '';
  }else{
    return filteredMessages.chat[0].chatUuid;
  }
}