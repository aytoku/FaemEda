import 'package:equatable/equatable.dart';
import 'package:flutter_app/Screens/CodeScreen/Model/AuthCode.dart';

// описание состояний блока

// класс от которого наследуются все состояния скрина
abstract class CodeState extends Equatable {
  const CodeState();

  @override
  List<Object> get props => [];
}

class CodeStateLoading extends CodeState {}

class CodeStateEmpty extends CodeState {
  CodeStateEmpty({this.flag = true});
  bool flag;

  @override
  List<Object> get props => [flag];
}

class CodeStateSuccess extends CodeState {

  final AuthCodeData authCodeData;
  final bool goToHomeScreen;
  final bool goToNameScreen;

  const CodeStateSuccess(this.authCodeData, {this.goToHomeScreen = false, this.goToNameScreen = false});

  @override
  List<Object> get props => [authCodeData, goToHomeScreen];
}

class CodeSearchStateError extends CodeState {

  final String error;

  const CodeSearchStateError(this.error);

  @override
  List<Object> get props => [error];
}