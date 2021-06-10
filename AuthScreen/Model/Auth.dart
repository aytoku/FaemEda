class AuthData {
  int code;
  String message;
  int next_request_time;

  AuthData( {
    this.code,
    this.message,
    this.next_request_time
  });

  factory AuthData.fromJson(Map<String, dynamic> parsedJson){

    return AuthData(
        code:parsedJson['code'],
        message:parsedJson['message'],
        next_request_time:parsedJson['next_request_time']
    );
  }
}