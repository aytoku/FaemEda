import 'package:flutter/material.dart';
import 'package:flutter_app/Screens/ChatScreen/API/create_message.dart';
import 'package:flutter_app/Screens/ChatScreen/API/get_filtered_messages.dart';
import 'package:flutter_app/Screens/ChatScreen/Model/CreateMessage.dart';
import 'package:flutter_app/data/data.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';

class ChatCloud extends StatefulWidget {
  Chat chat;
  bool send;
  GlobalKey<ChatContentState> key;
  ChatCloud(this.chat, {this.key, this.send = false}) : super(key: key);

  @override
  ChatContentState createState() => ChatContentState(chat, send);
}

class ChatContentState extends State<ChatCloud> {
  Chat chat;
  bool send;
  ChatContentState(this.chat, this.send);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  void sendOnServer() async{
    await createMessage(chat.msg);
    setState(() {
      chat.sent = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    WidgetsBinding.instance
        .addPostFrameCallback((_) {
      if(send){
        send = false;
        sendOnServer();
      }
    });

    if(chat.operatorUuid != ''){
      return Padding(
        padding: const EdgeInsets.only(bottom: 15, left: 15, right: 15, top: 5),
        child: Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Flexible(
                child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Color(0xFFF6F6F6)
                    ),
                    padding: EdgeInsets.only(left: 16, right: 16, top: 9, bottom: 9),
                    child: Text(chat.msg,
                      textAlign: TextAlign.start,
                      style: TextStyle(
                          color: Color(0xFF424242)
                      ),
                    )
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text(DateFormat('kk:mm').format(chat.createdAt.add(Duration(hours: 3)))),
              ),
            ],
          ),
        ),
      );
    }else{
      return Padding(
        padding: const EdgeInsets.only(bottom: 15, left: 50, right: 15),
        child: Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Column(
                  children: [
                    Text(DateFormat('kk:mm').format(chat.createdAt.add(Duration(hours: 3)))),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: (chat.sent) ? SvgPicture.asset(!(chat.unreaded) ?
                      'assets/svg_images/read_message.svg' : 'assets/svg_images/unread_message.svg') :
                      SpinKitFadingCircle(
                        color: AppColor.mainColor,
                        size: 10,
                      ),
                    )
                  ],
                ),
              ),
              Flexible(
                child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Color(0xFF7D7D7D)
                    ),
                    padding: EdgeInsets.only(left: 16, right: 16, top: 9, bottom: 9),
                    child: Text(chat.msg,
                      textAlign: TextAlign.start,
                      style: TextStyle(
                          color: Colors.white
                      ),
                    )
                ),
              ),
            ],
          ),
        ),
      );
    }
  }
}