import 'package:flutter/material.dart';
import 'package:flutter_app/Config/config.dart';
import 'package:flutter_app/Screens/AuthScreen/Model/Auth.dart';
import 'package:flutter_app/Screens/ChatScreen/View/chat_screen.dart';
import 'package:flutter_app/Screens/CityScreen/Model/FilteredCities.dart';
import 'package:flutter_app/Screens/CodeScreen/Model/AuthCode.dart';
import 'package:flutter_app/Screens/HomeScreen/View/home_screen.dart';
import 'package:flutter_app/Screens/HomeScreen/Widgets/OrderChecking.dart';
import 'package:flutter_app/Screens/MyAddressesScreen/Model/my_addresses_model.dart';
import 'package:flutter_app/Screens/OrdersScreen/View/orders_details.dart';
import 'package:flutter_app/Screens/RestaurantScreen/Model/FilteredProductCategories.dart';

import '../Screens/HomeScreen/Model/Stock.dart';

Map<String,GlobalKey<OrderCheckingState>> orderCheckingStates = new Map<String,GlobalKey<OrderCheckingState>>();
GlobalKey<HomeScreenState>homeScreenKey = new GlobalKey<HomeScreenState>(debugLabel: 'homeScreenKey');
GlobalKey<OrdersDetailsScreenState>orderDetailsScreenKey = new GlobalKey<OrdersDetailsScreenState>(debugLabel: 'orderDetailsScreenKey');
GlobalKey<ChatContentState>chatContentKey = new GlobalKey<ChatContentState>();
AuthCodeData authCodeData = null;
AuthData authData = null;
String FCMToken = '';
int code = 0;
NecessaryDataForAuth necessaryDataForAuth = new NecessaryDataForAuth(phone_number: null, refresh_token: null, device_id: null, name: null);
FilteredCities selectedCity;
String header = 'eda/pomidor';
FilteredProductCategories selectedCategoriesUuid;
String tempClientUuid = '';
AssetImage assetImage = AssetImage('assets/images/tomato_preloader.png');
bool lock = false;
bool closeDialog = false;
Stock savedPromo = new Stock();
GlobalKey<NavigatorState> navigatorKey = new GlobalKey();
Map<String, String> codeErrors = {
  ". error creating validation code: [СМС отправлено, попробуйте запросить новый код авторизации позже]":
  "                           СМС отправлено.\nПовторно запросить код можно через 60 сек",
  'error validating phone number: [invalid phone number]':'Указан неверный номер',
  'error validating code: [Wrong verification code]':'Вы ввели неверный смс код'
};