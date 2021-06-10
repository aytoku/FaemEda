import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_app/Amplitude/amplitude.dart';
import 'package:flutter_app/Centrifugo/centrifugo.dart';
import 'package:flutter_app/Config/config.dart';
import 'package:flutter_app/FCM/fcm.dart';
import 'package:flutter_app/Screens/CodeScreen/API/auth_code_data_pass.dart';
import 'package:flutter_app/Screens/CodeScreen/Bloc/code_event.dart';
import 'package:flutter_app/Screens/CodeScreen/Bloc/code_state.dart';
import 'package:flutter_app/Screens/CodeScreen/Model/AuthCode.dart';
import 'package:flutter_app/Screens/HomeScreen/View/home_screen.dart';
import 'package:flutter_app/data/data.dart';
import 'package:flutter_app/data/globalVariables.dart';
import 'package:rxdart/rxdart.dart';
import 'package:bloc/bloc.dart';

class CodeGetBloc extends Bloc<CodeEvent, CodeState> {

  @override
  Stream<Transition<CodeEvent, CodeState>> transformEvents(
      Stream<CodeEvent> events,
      Stream<Transition<CodeEvent, CodeState>> Function(
          CodeEvent event,
          )
      transitionFn,
      ) {
    return events
        .debounceTime(const Duration(milliseconds: 300))
        .switchMap(transitionFn);
  }

  @override
  void onTransition(
      Transition<CodeEvent, CodeState> transition) {
    print(transition);
    super.onTransition(transition);
  }

  @override
  CodeState get initialState => CodeStateEmpty();



  @override
  Stream<CodeState> mapEventToState(CodeEvent event ) async* {
    if (event is CodeInitialLoad) {
      yield CodeStateEmpty(flag: event.flag);
    }else if(event is SendCode){ // Отправка кода на сервер
      // Состояние загруки
      yield CodeStateLoading();
      // Если передан кривой код
      if(event.code == null || event.code.toString() == ''){
        yield CodeSearchStateError('Вы ввели неверный смс код');
        return;
      }
      // Отправляем код на серв
      authCodeData = await loadAuthCodeData(necessaryDataForAuth.device_id, event.code);
      if(authCodeData != null){ // Если модель не крашнула

        //Активация амплитуды
        await AmplitudeAnalytics.analytics.logEvent('code_entry ', eventProperties: {
          'phone': necessaryDataForAuth.phone_number
        });
        // Сохранение данных в память
        necessaryDataForAuth.phone_number =
            currentUser.phone;
        necessaryDataForAuth.refresh_token =
            authCodeData.refreshToken.value;
        necessaryDataForAuth.token =
            authCodeData.token;
        necessaryDataForAuth.name = necessaryDataForAuth.name ?? necessaryDataForAuth.nameList[necessaryDataForAuth.phone_number];
        await NecessaryDataForAuth.saveData();

        await Centrifugo.connectToServer();
        await new FirebaseNotifications().setUpFirebase();

        // Изменение флажка и переход на скрин
        currentUser.isLoggedIn = true;
        if(necessaryDataForAuth.name == null){
          yield CodeStateSuccess(null, goToHomeScreen: false, goToNameScreen: true);
        }else{
          yield CodeStateSuccess(null, goToHomeScreen: true, goToNameScreen: false);
        }
      }else{
        yield CodeSearchStateError('Вы ввели неверный смс код');
      }

    }else if(event is CodeSetError){
      yield CodeSearchStateError(event.error);
    }
  }
}