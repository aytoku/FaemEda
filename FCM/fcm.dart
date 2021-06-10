import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/FCM/API/sendFcmToken.dart';
import 'package:flutter_app/Screens/ChatScreen/View/chat_screen.dart';
import 'package:flutter_app/Screens/OrdersScreen/Model/OrdersDetailsModel.dart';
import 'package:flutter_app/data/data.dart';
import 'package:flutter_app/data/globalVariables.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:convert' as convert;

import 'package:flutter_vibrate/flutter_vibrate.dart';

class FirebaseNotifications {
  static FirebaseMessaging _firebaseMessaging;
  static FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  new FlutterLocalNotificationsPlugin();

  Future setUpFirebase() async{
    _firebaseMessaging = FirebaseMessaging();
    await firebaseCloudMessaging_Listeners();
  }

  // ignore: missing_return
  static Future<dynamic> myBackgroundMessageHandler(Map<String, dynamic> message) {
    print(message);
    showNotification(message);
    Vibrate.vibrate();
    print('EXPLOOOOSION');
  }


  static Future<void> OrderCheckingUpdater(String order_uuid, String order_state, Map<String, dynamic> data) async {
    if(homeScreenKey.currentState != null && homeScreenKey.currentState.orderList != null
        && !DeliveryStates.contains(order_state)){
      homeScreenKey.currentState.orderList.removeWhere((element) => element.ordersDetailsItem.uuid == order_uuid);
      // if(homeScreenKey.currentState.orderList.length == 0)
      //   homeScreenKey.currentState.setState(() { });
      // Navigator.push(
      //   homeScreenKey.currentContext,
      //   MaterialPageRoute(builder: (_) {
      //     return CompletedOrderScreen();
      //   }),
      // );
    }
    if(orderCheckingStates.containsKey(order_uuid)) {
      if(orderCheckingStates[order_uuid].currentState != null) {
        orderCheckingStates[order_uuid].currentState.ordersStoryModelItem = OrderDetailsModelItem.fromJson(data['payload']['order']);
        orderCheckingStates[order_uuid].currentState.setState(() {
//          orderCheckingStates[order_uuid].currentState.ordersStoryModelItem
//              .state = order_state;
        });
      } else {
        if(homeScreenKey.currentState != null && homeScreenKey.currentState.orderList != null) {
          homeScreenKey.currentState.orderList.forEach((element) async {
            if(element.ordersDetailsItem.uuid == order_uuid) {
              element.ordersDetailsItem =OrderDetailsModelItem.fromJson(data['payload']['order']);
//              element.ordersStoryModelItem.state = order_state;
              return;
            }
          });
        }
      }
    }
  }


  static void messageHandler(Map<String, dynamic> message) async {

    //ios fix
    print(message);
    if(!message.containsKey('data') && (message.containsKey('payload') || message.containsKey('tag'))){
      print('arturia saber');
      message['data'] = new Map<String, dynamic>();
      if(message.containsKey('payload')){
        message['data']['payload'] = message['payload'];
        print('arturia lancer');
      }
      if(message.containsKey('tag')){
        message['data']['tag'] = message['tag'];
        print('arturia kartyojnik');
      }
      if(message.containsKey('notification_message')){
        message['data']['notification_message'] = message['notification_message'];
        print('arturia gopnik');
      }
    }
    print(message);


    var data =  message;
    if(data.containsKey('tag')) {
      switch (data['tag']){
        case 'order-state' :
          String order_state = data['payload']['state'];
          String order_uuid = data['payload']['order']['uuid'];
          OrderCheckingUpdater(order_uuid, order_state, data);
          break;
      }
    }
  }


  void firebaseCloudMessaging_Listeners() async{
    if (Platform.isIOS) iOS_Permission();

    var token = await _firebaseMessaging.getToken();
    FCMToken = token;
    await sendFCMToken(token, necessaryDataForAuth.device_id);
    print('DAITE MNE TOKEN   ' + token);
    print(necessaryDataForAuth.device_id);
    var android = new AndroidInitializationSettings('@mipmap/faem');
    var ios = new IOSInitializationSettings(
        defaultPresentAlert: true,
        defaultPresentSound: true,
        requestAlertPermission: true,
        requestSoundPermission: true
    );
    var platform = new InitializationSettings(android: android, iOS: ios);
    // flutterLocalNotificationsPlugin.initialize(platform);
    flutterLocalNotificationsPlugin.initialize(platform, onSelectNotification: (tag) async{
      if(tag == 'message'){
        return navigatorKey.currentState.push(new MaterialPageRoute(
          builder: (context) => new ChatScreen(),
        ),);
      }
      return true;
    });


    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print('on message $message');

        await showNotification(message);
        Vibrate.vibrate();
      },
      onBackgroundMessage: myBackgroundMessageHandler,
      onResume: (Map<String, dynamic> message) async {
        print('on resume $message');
        await showNotification(message);
        Vibrate.vibrate();
      },
      onLaunch: (Map<String, dynamic> message) async {
        print('on launch $message');
        await showNotification(message);
        Vibrate.vibrate();
      },
    );
  }

  void iOS_Permission() {
    _firebaseMessaging.requestNotificationPermissions(
        IosNotificationSettings(sound: true, badge: true, alert: true, provisional: false,));
    _firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings settings) {
      print("Settings registered: $settings");
    });

  }

  static Future<void> showNotification(Map<String, dynamic> message) async {
    String title = message['notification']['title'];
    String body = message['notification']['body'];
    if(Platform.isIOS){
      if(message['aps']['alert'] != null){
        title = message['aps']['alert']['title'];
        body = message['aps']['alert']['body'];
      }
    }
    // if(message['notification'] != null){
    //   title = message['notification']['title'];
    //   body = message['notification']['body'];
    // }
    if(Platform.isIOS){
      body = '';
    }
    if(title == null)
      return;
    var androidChannelSpecifics = AndroidNotificationDetails(
      'CHANNEL_ID',
      'CHANNEL_NAME',
      "CHANNEL_DESCRIPTION",
      importance: Importance.high,
      priority: Priority.high,
      playSound: true,
      sound: message['notification']['sound'],
      timeoutAfter: 5000,
      enableVibration: true,
      enableLights: true,
      styleInformation: DefaultStyleInformation(true, true),
    );
    var iosChannelSpecifics = IOSNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
        sound: message['aps']['alert']['sound'],
    );
    var platformChannelSpecifics =
    NotificationDetails(android: androidChannelSpecifics, iOS: iosChannelSpecifics);
    IOSFlutterLocalNotificationsPlugin();
    await flutterLocalNotificationsPlugin.show(
      0,
      title,
      body,
      platformChannelSpecifics,
      payload: 'New Payload', // Notification Payload
    );
  }
}
