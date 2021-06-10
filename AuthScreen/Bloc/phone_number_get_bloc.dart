import 'dart:async';
import 'package:flutter_app/Amplitude/amplitude.dart';
import 'package:flutter_app/Screens/AuthScreen/API/auth_data_pass.dart';
import 'package:flutter_app/Screens/AuthScreen/API/new_auth.dart';
import 'package:flutter_app/Screens/AuthScreen/Bloc/phone_number_event.dart';
import 'package:flutter_app/Screens/AuthScreen/Bloc/phone_number_state.dart';
import 'package:flutter_app/Screens/AuthScreen/Model/Auth.dart';
import 'package:flutter_app/data/globalVariables.dart';
import 'package:flutter_app/data/refreshToken.dart';
import 'package:flutter_app/data/data.dart';
import 'package:rxdart/rxdart.dart';
import 'package:bloc/bloc.dart';

// сам bloc


class AuthGetBloc extends Bloc<PhoneNumberEvent, AuthState> {

  @override
  Stream<Transition<PhoneNumberEvent, AuthState>> transformEvents(
      Stream<PhoneNumberEvent> events,
      Stream<Transition<PhoneNumberEvent, AuthState>> Function(
          PhoneNumberEvent event,
          )
      transitionFn,
      ) {
    return events
        .debounceTime(const Duration(milliseconds: 300))
        .switchMap(transitionFn);
  }

  @override
  void onTransition(
      Transition<PhoneNumberEvent, AuthState> transition) {
    print(transition);
    super.onTransition(transition);
  }

  @override
  AuthState get initialState => AuthStateEmpty(); // изначальное состояние скрина


  // обработка изменения событий
  @override
  Stream<AuthState> mapEventToState(PhoneNumberEvent event ) async* {
    // выбор действия в зависимости от события
    if (event is InitialLoad) {
      // возвращает изначальное состояние скрина
      yield AuthStateEmpty();
    }else if(event is SendPhoneNumber){// обработка и отправка номера телефона на серв
      // проверка на пустоту номера
      yield AuthStateLoading();
      if(event.phoneNumber == ''){
        // вывод ошибки
        yield SearchStateError('Указан неверный номер');
      }


      bool sendDataOnServer = false;
      if (currentUser.phone != necessaryDataForAuth.phone_number) { // если введен новый номер
        sendDataOnServer = true;
        necessaryDataForAuth.name = null;
        currentUser.isLoggedIn = false;
      } else { // если введен старый номер
        print(necessaryDataForAuth.refresh_token);
        bool isRefreshSuccess = await SendRefreshToken.sendRefreshToken();
        if (!isRefreshSuccess) { // проверка валидности рефреш токена
          currentUser.isLoggedIn = false;
          sendDataOnServer = true;
        }
        else { // если токен валиден
          currentUser.isLoggedIn = true;
          await AmplitudeAnalytics.analytics.logEvent('authorization', eventProperties: {
            'phone': necessaryDataForAuth.phone_number
          });
          yield AuthStateSuccess(null, goToHomeScreen: true);
        }
      }


      if(sendDataOnServer){ // отправка данных на серв и обработка результата
        AuthData authorization = await newAuth(necessaryDataForAuth.device_id, event.phoneNumber);
        if(authorization != null){
          if(authorization.code != 200){
            yield SearchStateError('Вас еще никто не пригласил.\nМы добавили Вас в список ожидания ❤');
          }else{
            yield AuthStateSuccess(authorization);
          }

        }else{
          yield SearchStateError('Указан неверный номер');
        }
      }
    }else if(event is SetError){ // вывод ошибки на authScreen
      yield SearchStateError(event.error);
    }
  }
}