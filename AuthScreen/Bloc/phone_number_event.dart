import 'package:equatable/equatable.dart';

// описание событий на экране


// класс от которого наследуются все события
abstract class PhoneNumberEvent extends Equatable {
  const PhoneNumberEvent();
}

class SendPhoneNumber extends PhoneNumberEvent {  // событие отправки номера на серв
  final String phoneNumber;

  const SendPhoneNumber({this.phoneNumber});

  @override
  List<Object> get props => [phoneNumber];
}

class InitialLoad extends PhoneNumberEvent {  //  событие изначальной подгрузки скрина

  const InitialLoad();

  @override
  List<Object> get props => [];
}

class SetError extends PhoneNumberEvent { // установка ошибка
  final String error;
  const SetError(this.error);

  @override
  List<Object> get props => [error];
}