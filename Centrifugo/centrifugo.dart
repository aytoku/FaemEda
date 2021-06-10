import 'dart:convert';
import 'dart:typed_data';

import 'package:centrifuge/centrifuge.dart' as centrifuge;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/Screens/ChatScreen/Model/CreateMessage.dart';
import 'package:flutter_app/Screens/ChatScreen/View/chat_screen.dart';
import 'package:flutter_app/Screens/OrdersScreen/Model/OrdersDetailsModel.dart';
import 'package:flutter_app/data/api.dart';
import 'package:flutter_app/data/globalVariables.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'API/centrifugo.dart';
import 'package:flutter_app/data/data.dart';
import 'dart:convert' as convert;

import 'dart:io' show Platform;
import 'package:flutter_app/Screens/ChatScreen/Widgets/ChatCloud.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class Centrifugo{
  static centrifuge.Client client;
  static FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  new FlutterLocalNotificationsPlugin();
  static var subscription;
  static var chat_subscription;


  static Future<void> connectToServer() async {
    client = centrifuge.createClient(centrifugoClientApi);

    var android = new AndroidInitializationSettings('@mipmap/faem');
    var ios = new IOSInitializationSettings();
    var mac = new MacOSInitializationSettings();
    var platform = new InitializationSettings(android: android, iOS: ios, macOS: mac);
    // flutterLocalNotificationsPlugin.initialize(platform);
    flutterLocalNotificationsPlugin.initialize(platform, onSelectNotification: (tag) async{
      if(tag == 'message'){
        return navigatorKey.currentState.push(new MaterialPageRoute(
          builder: (context) => new ChatScreen(),
        ),);
      }
      return true;
    });


    String token = await getCentrifugoToken();
    client.setToken(token);
    client.connectStream.listen((event) {
      print('Centrifugo connected');
    });
    client.disconnectStream.listen((event) {
      print('Centrifugo disconnected');
    });
    client.connect();

    statusSubscription();

  }

  static statusSubscription(){
    subscription = client.getSubscription('eda/orderstates/client/${authCodeData.userUUID}');
    print('eda/orderstates/client/${authCodeData.userUUID}');

    subscription.publishStream.listen((event){
      print("STATUS TUT" + utf8.decode(event.data));
      var parsedJson = convert.jsonDecode(utf8.decode(event.data));
      showNotification(parsedJson);
      Vibrate.vibrate();
      statusHandler(parsedJson);
    });

    subscription.subscribe();
  }

  static chatSubscription(String client_uuid){
    if(client_uuid == ''){
      return;
    }
    chat_subscription = client.getSubscription('eda/order/message/${authCodeData.userUUID}');
    print('eda/order/message/${authCodeData.userUUID}');
    chat_subscription.publishStream.listen((event){
      print("CHAT TUT" + utf8.decode(event.data));
      var parsedJson = convert.jsonDecode(utf8.decode(event.data));
      var chat = Chat.fromJson(parsedJson['payload']);
      if(chat.operatorUuid != ''){
        showNotification(parsedJson);
        Vibrate.vibrate();
        messageHandler(parsedJson);
      }
    });

    chat_subscription.subscribe();
  }

  static Future<void> OrderCheckingUpdater(String order_uuid, String order_state, Map<String, dynamic> data) async {
    if(homeScreenKey.currentState != null && homeScreenKey.currentState.orderList != null
        && !DeliveryStates.contains(order_state)){
      homeScreenKey.currentState.orderList.removeWhere((element) => element.ordersDetailsItem.uuid == order_uuid);
      if(homeScreenKey.currentState.orderList.length == 0)
        homeScreenKey.currentState.setState(() { });
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

    if(orderDetailsScreenKey.currentState != null){
      print('why krashit');
      if(orderDetailsScreenKey.currentState.ordersDetailsModelItem.uuid == order_uuid){
        print('why krashit 1');
        orderDetailsScreenKey.currentState.setState(() {
          print('why krashit 2');
          orderDetailsScreenKey.currentState.ordersDetailsModelItem
          = OrderDetailsModelItem.fromJson(data['payload']['order']);
        });
        print('why krashit 3');
      }
    }
  }

  static void messageHandler(Map<String, dynamic> message) async{
    var data =  message;
    if(data.containsKey('tag')) {
      switch (data['tag']){
        case 'message' :
          var chat = Chat.fromJson(message['payload']);
          if(chatContentKey != null && chatContentKey.currentState != null){
            if(chatContentKey.currentState.chatClouds != null){
              chatContentKey.currentState.chatClouds.add(
                ChatCloud(chat, key: GlobalKey(),)
              );
              // ignore: invalid_use_of_protected_member
              chatContentKey.currentState.setState(() {

              });
            }
          }
          break;
      }
    }
  }

  static void statusHandler(Map<String, dynamic> message) async {

    //ios fix
    print(message);
    if(!message.containsKey('data') && (message.containsKey('payload') || message.containsKey('tag'))){
      message['data'] = new Map<String, dynamic>();
      if(message.containsKey('payload')){
        message['data']['payload'] = message['payload'];
      }
      if(message.containsKey('tag')){
        message['data']['tag'] = message['tag'];
      }
      if(message.containsKey('notification_message')){
        message['data']['notification_message'] = message['notification_message'];
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

        // case 'chat_message' :
        //   var payload = data['payload'];
        //   var message = ChatMessage.fromJson(payload);
        //   if(chatKey.currentState != null){
        //     chatKey.currentState.setState(() {
        //       chatKey.currentState.chatMessageList.insert(0, new ChatMessageScreen(chatMessage: message, key: new ObjectKey(message)));
        //     });
        //   }
        //   String order_uuid = message.order_uuid;
        //   if(orderCheckingStates.containsKey(order_uuid)) {
        //     if(orderCheckingStates[order_uuid].currentState != null) {
        //       orderCheckingStates[order_uuid].currentState.setState(() {
        //       });
        //     }
        //   }
        //   break;
        //
        // case 'chat_messages_read' :
        //   var payload = data['payload'];
        //   List<dynamic> messagesUuid = payload['messages_uuid'];
        //   if(chatKey.currentState != null && chatKey.currentState.order_uuid == payload['order_uuid']){
        //     messagesUuid.forEach((element) {
        //       if(chatMessagesStates.containsKey(element)){
        //         // ignore: invalid_use_of_protected_member
        //         if(chatMessagesStates[element].currentState != null) {
        //           chatMessagesStates[element].currentState.setState(() {
        //             chatMessagesStates[element].currentState.chatMessage.ack = true;
        //           });
        //         } else {
        //           chatKey.currentState.chatMessageList.forEach((message) {
        //             if(message.chatMessage.uuid == element) {
        //               message.chatMessage.ack = true;
        //               return;
        //             }
        //           });
        //         }
        //       }
        //     });
        //   }
        //   break;
      }
    }
  }

  static Future<void> showNotification(Map<String, dynamic> message) async {

    // String title = message['title'];
    String body = message['message'];
    print(message);
    // if(Platform.isIOS){
    //   body = '';
    // }
    // if(title == null || title == '')
    //   return;
    var androidChannelSpecifics = AndroidNotificationDetails(
      'CHANNEL_ID',
      'CHANNEL_NAME',
      "CHANNEL_DESCRIPTION",
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
      enableLights: true,
      enableVibration: true,
      styleInformation: DefaultStyleInformation(true, true),
    );
    var iosChannelSpecifics = IOSNotificationDetails();
    var macOS = MacOSNotificationDetails();
    var platformChannelSpecifics =
    NotificationDetails(android: androidChannelSpecifics, iOS: iosChannelSpecifics, macOS: macOS);
    print(message['tag']);
    await flutterLocalNotificationsPlugin.show(
      0,  // Notification ID
      '',
      body, // Notification Body, set as null to remove the body
      //for ios change body on empty field
//      title_ios,
//      '',
      platformChannelSpecifics,
      payload: message['tag'] ?? '', // Notification Payload
    );
  }
}