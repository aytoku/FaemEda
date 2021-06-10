import 'package:equatable/equatable.dart';


abstract class CodeEvent extends Equatable {
  const CodeEvent();
}

class SendCode extends CodeEvent {
  final int code;

  const SendCode({this.code});

  @override
  List<Object> get props => [code];
}

class CodeInitialLoad extends CodeEvent {

  CodeInitialLoad({this.flag = true});
  bool flag;

  @override
  List<Object> get props => [flag];
}

class CodeSetError extends CodeEvent {
  final String error;
  const CodeSetError(this.error);

  @override
  List<Object> get props => [error];
}