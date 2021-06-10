import 'dart:convert';
import 'package:flutter_app/data/api.dart';
import 'package:flutter_app/data/globalVariables.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import '../Config/config.dart';
import 'data.dart';
import '../Screens/CodeScreen/Model/AuthCode.dart';

class   SendRefreshToken {

  static Future<bool> sendRefreshToken({String refreshToken, String token, String device_id}) async {
    bool isSuccess = false;
    try{
      var url = '${authApiUrl}auth/clients/refresh';
      var response = await http.post(
          Uri.parse(url), body: jsonEncode({
        "refresh": (refreshToken != null)? refreshToken : authCodeData.refreshToken.value,
        "service": "eda",
        "device_id": (device_id != null) ? device_id : necessaryDataForAuth.device_id}),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization':'Bearer ' + ((token != null) ? token : authCodeData.token)
          });
      print('ТУТ КЕФРЕЭ ' + authCodeData.refreshToken.value);
      if (response.statusCode == 200) {
        isSuccess = true;
        var jsonResponse = convert.jsonDecode(response.body);
        authCodeData = AuthCodeData.fromJson(jsonResponse);
        necessaryDataForAuth.refresh_token = authCodeData.refreshToken.value;
        necessaryDataForAuth.token = authCodeData.token;
        await NecessaryDataForAuth.saveData();
        print(response.body);
      } else {
        print('Request failed with status: ${response.statusCode}.');
      }
    } catch(e){
      isSuccess = false;
    }

    return isSuccess;
  }
}