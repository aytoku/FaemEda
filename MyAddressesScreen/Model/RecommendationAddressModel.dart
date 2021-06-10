import 'package:flutter_app/Screens/MyAddressesScreen/Model/my_addresses_model.dart';
import 'package:flutter_app/data/data.dart';
import 'package:flutter_app/data/globalVariables.dart';

import '../../../data/refreshToken.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class RecommendationAddress {
  static Future<List<RecommendationAddressModel>> getRecommendations(String destination) async{
    List<RecommendationAddressModel> addressesList;
    // Обновляем токен
    await SendRefreshToken.sendRefreshToken();
    // Получаем данные с сервера
    var url = 'https://client.apis.stage.faem.pro/api/v2/addresses/recommended/$destination';
    var response = await http.get(Uri.parse(url), headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Accept': 'application/json',
      'Source':'ios_client_app_1',
      'Authorization':'Bearer ' + authCodeData.token
    });
    var jsonResponse;
    if (response.statusCode == 200) {
      jsonResponse = convert.jsonDecode(response.body) as List;
    } else {
      print('Request failed with status: ${response.statusCode}.');
    }
    // Если что-то пошло не так, возвращаем пустой список
    if(jsonResponse == null)
      return addressesList;
    // иначе возвращаем заполненный
    addressesList = jsonResponse.map<RecommendationAddressModel>((i) {
      RecommendationAddressModel item = RecommendationAddressModel.fromJson(i);
      item.address.name = item.name; // Передаем имя в родительский класс (будет проще в плане полиморфизма)
      return item;
    }).toList();
    print("ваываыва");
    return addressesList;
  }
}

class RecommendationAddressModel {
  static const List<String> MyAddressesTags = ["work","house","study", null];
  DestinationPoints address;
  String name;
  String tag;

  RecommendationAddressModel( {
    this.address,
    this.name,
    this.tag,
  });

  Map<String, dynamic> toJson() => {
    "name": name,
    "tag": tag,
    "address": address.toJson(),
  };

  factory RecommendationAddressModel.fromJson(Map<String, dynamic> parsedJson){
    return RecommendationAddressModel(
        name: parsedJson["name"],
        tag: parsedJson["tag"],
        address: DestinationPoints.fromJson(parsedJson["address"])
    );
  }
}