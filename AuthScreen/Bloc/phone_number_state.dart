import 'package:equatable/equatable.dart';
import 'package:flutter_app/Screens/AuthScreen/Model/Auth.dart';

// описание состояний блока

// класс от которого наследуются все состояния скрина
abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

class AuthStateLoading extends AuthState {} // подгрузка скрина

class AuthStateEmpty extends AuthState {} // изначальное состояние скрина до подгрузки данных

class AuthStateSuccess extends AuthState { // состояние после успешной подгрузки

  final AuthData authData;
  final bool goToHomeScreen;

  const AuthStateSuccess(this.authData, {this.goToHomeScreen = false});

  @override
  List<Object> get props => [authData, goToHomeScreen];
}

class SearchStateError extends AuthState {  // состояние в случае ошибки
  final String error;

  const SearchStateError(this.error);

  @override
  List<Object> get props => [error];
}