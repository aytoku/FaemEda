import 'dart:convert';
import 'dart:io';
import 'package:device_id/device_id.dart';
import 'package:flutter_app/Application/API/get_color_scheme.dart';
import 'package:flutter_app/Screens/CityScreen/View/city_screen.dart';
import 'package:flutter_app/Screens/CodeScreen/Model/AuthCode.dart';
import 'package:flutter_app/Screens/MyAddressesScreen/Model/my_addresses_model.dart';
import 'package:flutter_app/Screens/OrderConfirmationScreen/Model/PaymentMethod.dart';
import 'package:flutter_app/VersionControl/API/getCurrentVersion.dart';
import 'package:flutter_app/data/data.dart';
import 'package:flutter_app/data/globalVariables.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

import '../Centrifugo/centrifugo.dart';
import '../Screens/CityScreen/Model/FilteredCities.dart';
import '../data/api.dart';
import '../data/data.dart';

class NecessaryDataForAuth{
  String device_id;
  String phone_number;
  String refresh_token;
  String name;
  String token;
  MyFavouriteAddressesModel address;
 // FilteredCities city;
  PaymentMethod selectedPaymentMethod;
  Map<String, String> nameList = {};
  bool vis;
  static NecessaryDataForAuth _necessaryDataForAuth;

  NecessaryDataForAuth({
    this.device_id,
    this.phone_number,
    this.token,
    this.address,
    this.nameList,
    //this.city,
    this.refresh_token,
    this.selectedPaymentMethod,
    this.name,
    this.vis
  });

  static Future<NecessaryDataForAuth> getData() async{
    if(_necessaryDataForAuth != null)
      return _necessaryDataForAuth;
    String device_id = await DeviceId.getID;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String phone_number = prefs.getString('phone_number');
    String refresh_token = prefs.getString('refresh_token');
    String name = prefs.getString('name');
    String nameListJson = prefs.getString('nameList');
    //String cityJson = prefs.getString('city');
    String addressJson = prefs.getString('address');
    String selectedPaymentMethodJSON = prefs.getString('selected_payment_method') ?? jsonEncode({
      "name": (Platform.isIOS) ? "Apple Pay" : "Google Pay",
      "image": (Platform.isIOS) ? "assets/svg_images/apple_pay.svg"
          : "assets/svg_images/google_pay.svg",
      "tag": "virtualCardPayment",
      "outputTag": "card"
    });
    String token = prefs.getString('token');
    bool vis = prefs.getBool('vis') ?? true;


    FilteredCities city;
    MyFavouriteAddressesModel address;
    PaymentMethod selectedPaymentMethod;
    Map<String, dynamic> tempNameList = {};
    Map<String, String> nameList = {};

    // if(cityJson != null){
    //   city = FilteredCities.fromJson(convert.jsonDecode(cityJson));
    // }
    if(addressJson != null){
      address = MyFavouriteAddressesModel.fromJson(convert.jsonDecode(addressJson));
    } else {
      address = new MyFavouriteAddressesModel();
    }

    if(selectedPaymentMethodJSON != null){
      selectedPaymentMethod = PaymentMethod.fromJson(convert.jsonDecode(selectedPaymentMethodJSON));
    }

    if(nameListJson != null){
      tempNameList = jsonDecode(nameListJson);
      tempNameList.keys.forEach((key) {
        nameList[key] = tempNameList[key].toString();
      });
    }

    await getColorScheme(header);
    await getAppInfo();


    NecessaryDataForAuth result = new NecessaryDataForAuth(
        device_id: device_id,
        phone_number: phone_number,
        refresh_token: refresh_token,
        name: name,
        token: token,
        selectedPaymentMethod: selectedPaymentMethod,
        nameList: nameList ?? {},
        //city: city,
        address: address,
        vis: vis
    );

    refresh_token = await refreshToken(refresh_token, token, device_id);

    result.refresh_token = refresh_token;
    _necessaryDataForAuth = result;
    if(refresh_token != null){
      result.token = authCodeData.token;
      await saveData();
    }

    return result;
  }

  static Future saveData() async{
    String phone_number = _necessaryDataForAuth.phone_number;
    String refresh_token = _necessaryDataForAuth.refresh_token;
    String name = _necessaryDataForAuth.name;
    String nameList = convert.jsonEncode(_necessaryDataForAuth.nameList);
    //String city = convert.jsonEncode(_necessaryDataForAuth.city.toJson());
    String address = convert.jsonEncode(_necessaryDataForAuth.address.toJson());
    String selectedPaymentMethod = convert.jsonEncode(_necessaryDataForAuth.selectedPaymentMethod.toJson());
    String token = _necessaryDataForAuth.token;
    bool vis = _necessaryDataForAuth.vis;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('phone_number', phone_number);
    prefs.setString('refresh_token',refresh_token);
    prefs.setString('name',name);
    prefs.setString('nameList', nameList);
    //prefs.setString('city',city);
    prefs.setString('address', address);
    prefs.setString('selected_payment_method',selectedPaymentMethod);
    prefs.setString('token',token);
    prefs.setBool('vis', vis);
  }

  static Future<String> refreshToken(String refresh_token, String token, String device_id) async {
    String result = null;
    var url = '${authApiUrl}auth/clients/refresh';
    print(refresh_token);
    print('--------');
    print(token);
    if(refresh_token == null || token == null){
      return null;
    }
    var response = await http.post(Uri.parse(url), body: jsonEncode({
      "device_id": device_id,
      "service": "eda",
      "refresh": refresh_token
      }),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization':'Bearer ' + token
        });
    print(response.body);
    if (response.statusCode == 200) {
      var jsonResponse = convert.jsonDecode(response.body);
      authCodeData = AuthCodeData.fromJson(jsonResponse);
      result = authCodeData.refreshToken.value;
    } else {
      print('Request failed with status SERV: ${response.statusCode}.');
    }
    return result;
  }

  static Future clear() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    _necessaryDataForAuth = null;
    necessaryDataForAuth = null;
  }
}