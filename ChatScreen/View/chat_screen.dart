import 'package:flutter/material.dart';
import 'package:flutter_app/Screens/ChatScreen/API/create_message.dart';
import 'package:flutter_app/Screens/ChatScreen/API/get_filtered_messages.dart';
import 'package:flutter_app/Screens/ChatScreen/Model/CreateMessage.dart';
import 'package:flutter_app/Screens/ChatScreen/Widgets/ChatFieldButton.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

import '../../../data/data.dart';
import '../../../data/data.dart';
import '../../../data/data.dart';
import '../../../data/globalVariables.dart';
import '../../HomeScreen/Bloc/restaurant_get_bloc.dart';
import '../../HomeScreen/View/home_screen.dart';
import 'package:flutter_app/Screens/ChatScreen/Widgets/ChatCloud.dart';

class ChatScreen extends StatefulWidget {

  ChatScreen({Key key}) : super(key: key);

  @override
  ChatScreenState createState() {
    return new ChatScreenState();
  }
}

class ChatScreenState extends State<ChatScreen>  with WidgetsBindingObserver{

  ChatScreenState();
  TextEditingController messageField = new TextEditingController();
  GlobalKey<ChatFieldButtonState> chatFieldKey;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    chatContentKey = GlobalKey();
    chatFieldKey = GlobalKey();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if(state == AppLifecycleState.resumed){
      setState(() {

      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: Container(
          padding: EdgeInsets.all(6),
          child: InkWell(
              hoverColor: AppColor.themeColor,
              focusColor: AppColor.themeColor,
              splashColor: AppColor.themeColor,
              highlightColor: AppColor.themeColor,
              onTap: (){
                homeScreenKey = new GlobalKey<HomeScreenState>();
                Navigator.pushReplacement(context,
                    new MaterialPageRoute(
                        builder: (context) => BlocProvider(
                          create: (context) => RestaurantGetBloc(),
                          child: new HomeScreen(),
                        )
                    )
                );
              },
              child: Container(
                  child: Padding(
                    padding: EdgeInsets.only(
                        top: 12, bottom: 12, right: 15, left: 0),
                    child: SvgPicture.asset(
                        'assets/svg_images/arrow_left.svg'),
                  ))),
        ),
        title: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: Container(
                  height: 40,
                  width: 40,
                  child: Image.asset('assets/images/chat_circle_icon.png')),
            ),
            Column(
              children: [
                Text(
                  'Поддержка',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF3F3F3F)),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 32),
                  child: Text('Мы рядом 24/7',
                    style: TextStyle(
                        color: AppColor.additionalTextColor,
                        fontSize: 12
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      body: GestureDetector(
        child: Container(
          color: Color(0xFFF9F9F9),
          child: Column(
            children: [
              ChatContent(key: chatContentKey),
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                    padding: EdgeInsets.only(bottom: 0),
                    child: SafeArea(
                      minimum: EdgeInsets.only(bottom: 15),
                      bottom: true,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Color(0xFFF9F9F9),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.black12,
                                blurRadius: 1,
                                offset: Offset(0,-1)
                            )
                          ],
                        ),
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                            maxHeight: 300.0,
                            minHeight: 52
                          ),
                          child: TextField(
                            cursorColor: Colors.grey,
                            controller: messageField,
                            maxLines: null,
                            onChanged: (text){
                              chatFieldKey.currentState.setState(() {

                              });
                            },
                            decoration: new InputDecoration(
                              suffixIcon: InkWell(
                                child: Container(
                                  padding: EdgeInsets.all(6),
                                  child: ChatFieldButton(parent: this, key: chatFieldKey,),
                                ),
                                onTap: () async{

                                  // Добавляем облачко чата
                                  chatContentKey.currentState.chatClouds.add(
                                    ChatCloud(
                                        Chat(
                                            msg: messageField.text,
                                            createdAt: DateTime.now().subtract(Duration(hours: 3)),
                                            unreaded: true,
                                            sent: false,
                                            operatorUuid: ''
                                        ),
                                      key: GlobalKey(),
                                      send: true,
                                    )
                                  );
                                  print('neeeee1');
                                  // Показываем его на экране
                                  chatContentKey.currentState.setState(() {

                                  });
                                  print('neeeee2');

                                  messageField.clear();
                                },
                              ),
                              hintText: 'Сообщение ...',
                              contentPadding: EdgeInsets.only(left: 20, right: 10, top: 30),
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide.none
                              ),
                              border: new OutlineInputBorder(
                                  borderSide: BorderSide.none
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                ),
              ),
            ],
          ),
        ),
        onTap: (){
          FocusScope.of(context).requestFocus(new FocusNode());
        },
      ),
    );
  }
}



class ChatContent extends StatefulWidget {
  ChatContent({Key key}) : super(key: key);
  @override
  ChatContentState createState() => ChatContentState();
}

class ChatContentState extends State<ChatContent> {
  List<ChatCloud> chatClouds;
  ScrollController controller;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller = ScrollController();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  scrollToEnd(){
    controller.animateTo(controller.position.maxScrollExtent, duration: Duration(milliseconds: 100), curve: Curves.ease);
  }


  List<Widget> buildChatList(){
    List<Widget> result = [];
    DateTime tempDate = new DateTime(1970);
    chatClouds.forEach((cloud) {
      DateTime date = new DateTime(cloud.chat.createdAt.year, cloud.chat.createdAt.month, cloud.chat.createdAt.day);
      if(date != tempDate){
        result.add(
          Padding(
            padding: const EdgeInsets.only(bottom: 15),
            child: Center(
                child: Text(DateFormat.yMMMd(Localizations.localeOf(context).languageCode).format(date),
                  style: TextStyle(
                    fontSize: 12
                  ),
                )
        ),
          ));
        tempDate = date;
      }
      result.add(cloud);
    });

    return List.from(result.reversed);
  }

  buildChatBody(){
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white
        ),
        child: ListView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          reverse: true,
          controller: controller,
          physics: BouncingScrollPhysics(),
          padding: EdgeInsets.zero,
          scrollDirection: Axis.vertical,
          children: buildChatList()
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Expanded(
      child: FutureBuilder<ChatData>(
        future: getFilteredMessage(),
        builder: (BuildContext context,
            AsyncSnapshot<ChatData> snapshot) {
           if(chatClouds != null)
             return buildChatBody();

          if (snapshot.connectionState ==
              ConnectionState.done &&
              snapshot.data != null || snapshot.hasData) {
            chatClouds = List<ChatCloud>.from(snapshot.data.chat.map((e) => ChatCloud(e, key: GlobalKey(),)));
            return buildChatBody();
          } else {
            return Container(
              height: 0,
            );
          }
        },
      ),
    );
  }
}
