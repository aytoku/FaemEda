import 'package:flutter/material.dart';
import 'package:flutter_app/Screens/AuthScreen/Bloc/phone_number_state.dart';
import 'package:flutter_app/data/globalVariables.dart';

import '../../../Internet/check_internet.dart';
import '../../../data/data.dart';
import '../Bloc/phone_number_event.dart';
import '../Bloc/phone_number_get_bloc.dart';
import '../View/auth_screen.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';

class AuthButton extends StatefulWidget {
  Color color;
  AuthSources source;
  AuthGetBloc authGetBloc;

  AuthButton({Key key, this.color, this.source, this.authGetBloc}) : super(key: key);

  @override
  AuthButtonState createState() {
    return new AuthButtonState(color, source, authGetBloc);
  }
}

class AuthButtonState extends State<AuthButton> {
  String error = '';
  Color color;
  AuthSources source;
  AuthGetBloc authGetBloc;

  AuthButtonState(this.color, this.source, this.authGetBloc);

  String validateMobile(String value) {
    String pattern = r'(^(?:[+]?7)[0-9]{10}$)';
    RegExp regExp = new RegExp(pattern);
    if (value.length == 0) {
      return 'Укажите номер';
    } else if (!regExp.hasMatch(value)) {
      return 'Указан неверный номер';
    }
    return null;
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    lock = false;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      padding: const EdgeInsets.only(left: 31, right: 31),
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 52,
        child: FlatButton(
          child: Center(
            child: Text('Далее',
                style: TextStyle(
                    fontSize: 18.0,
                    color: AppColor.textColor)),
          ),
          color: color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          onPressed: () async {
            if (await Internet.checkConnection()) {
              if(authGetBloc.state is AuthStateLoading){
                await Vibrate.vibrate();
                return;
              }
              print(currentUser.phone);
              if (validateMobile(currentUser.phone) == null) {
                authGetBloc.add(SendPhoneNumber(phoneNumber: currentUser.phone)); // отправка события в bloc
              } else {
                authGetBloc.add(SetError('Указан неверный номер')); // отправка события в bloc
              }
            } else {
              noConnection(context);
            }
          },
        ),

      ),
    );
  }
}