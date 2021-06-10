class ChatData{
  
  List<Chat> chat;

  ChatData( {
    this.chat,
  });

  factory ChatData.fromJson(List<dynamic> parsedJson){
    List<Chat> chatList = null;
    if(parsedJson != null){
      chatList = parsedJson.map((i) => Chat.fromJson(i)).toList();
    }

    return ChatData(
      chat:chatList,
    );
  }
}

class Chat {
  Chat({
    this.msg,
    this.clientUuid,
    this.createdAt,
    this.operatorUuid,
    this.chatUuid,
    this.unreaded,
    this.sent = true
  });

  final String msg;
  final String clientUuid;
  final DateTime createdAt;
  final String operatorUuid;
  final String chatUuid;
  final bool unreaded;
  bool sent;

  factory Chat.fromJson(Map<String, dynamic> json) => Chat(
    msg: json["msg"] == null ? null : json["msg"],
    clientUuid: json["client_uuid"] == null ? null : json["client_uuid"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    operatorUuid: json["operator_uuid"] == null ? null : json["operator_uuid"],
    chatUuid: json["chat_uuid"] == null ? null : json["chat_uuid"],
    unreaded: json["unreaded"] == null ? null : json["unreaded"],
  );

  Map<String, dynamic> toJson() => {
    "msg": msg == null ? null : msg,
    "client_uuid": clientUuid == null ? null : clientUuid,
    "created_at": createdAt == null ? null : createdAt.toIso8601String(),
    "operator_uuid": operatorUuid == null ? null : operatorUuid,
    "chat_uuid": chatUuid == null ? null : chatUuid,
    "unreaded": unreaded == null ? null : unreaded,
  };
}
