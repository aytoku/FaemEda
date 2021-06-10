class QuickMessages {
  List<QuickMessageItem>chatMessageList;

  QuickMessages( {
    this.chatMessageList,
  });

  factory QuickMessages.fromJson(List<dynamic> parsedJson){
    var chat_message_list = parsedJson;
    List<QuickMessageItem> messageList = new List<QuickMessageItem>();
    print('ksdjflksdjflkshfshfioshdfiohsdhg');
    if(chat_message_list != null){
      messageList = chat_message_list.map((i) =>
          QuickMessageItem.fromJson(i)).toList();
    }
    return QuickMessages(
        chatMessageList:messageList
    );
  }
}

class QuickMessageItem{
  String receiver;
  List<String> messages;

  QuickMessageItem( {
    this.receiver,
    this.messages,
  });

  factory QuickMessageItem.fromJson(Map<String, dynamic> parsedJson){
    List<String> messages = new List<String>();
    List<dynamic> msgs = parsedJson['messages'];
    msgs.forEach((element) {
      messages.add(element);
    });

    return QuickMessageItem(
      receiver:parsedJson['receiver'],
      messages:messages,
    );
  }
}