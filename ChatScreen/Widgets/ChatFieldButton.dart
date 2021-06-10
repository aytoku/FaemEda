import 'package:flutter/material.dart';
import 'package:flutter_app/Screens/ChatScreen/View/chat_screen.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ChatFieldButton extends StatefulWidget {
  ChatScreenState parent;
  ChatFieldButton({Key key, this.parent}) : super(key: key);
  @override
  ChatFieldButtonState createState() => ChatFieldButtonState(parent);
}

class ChatFieldButtonState extends State<ChatFieldButton> {

  ChatScreenState parent;
  ChatFieldButtonState(this.parent);

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


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return SvgPicture.asset((parent.messageField.text.length == 0)
        ? 'assets/svg_images/inactive_message_button.svg'
        : 'assets/svg_images/send_message.svg',
    );
  }
}