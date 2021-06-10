class ChatHistoryModel {
  List<ChatMessage>chatMessageList;

  ChatHistoryModel( {
    this.chatMessageList,
  });

  factory ChatHistoryModel.fromJson(List<dynamic> parsedJson){
    var chat_message_list = parsedJson;
    List<ChatMessage> messageList = new List<ChatMessage>();
    print('ksdjflksdjflkshfshfioshdfiohsdhg');
    if(chat_message_list != null){
      messageList = chat_message_list.map((i) =>
          ChatMessage.fromJson(i)).toList();
    }
    return ChatHistoryModel(
        chatMessageList:messageList
    );
  }
}

class ChatMessage{
  String uuid;
  String message;
  bool ack;
  String order_uuid;
  String from;
  String to;
  int created_at;
  String driver_uuid;
  String client_uuid;

  ChatMessage( {
    this.uuid,
    this.message,
    this.ack,
    this.order_uuid,
    this.from,
    this.to,
    this.created_at,
    this.driver_uuid,
    this.client_uuid,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> parsedJson){

    return ChatMessage(
      uuid:parsedJson['uuid'],
      message:parsedJson['message'],
      ack:parsedJson['ack'],
      order_uuid:parsedJson['order_uuid'],
      from:parsedJson['from'],
      to:parsedJson['to'],
      created_at:parsedJson['created_at'],
      driver_uuid:parsedJson['driver_uuid'],
      client_uuid:parsedJson['client_uuid'],
    );
  }
}