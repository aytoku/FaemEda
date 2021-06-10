import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/Config/config.dart';
import 'package:flutter_app/Screens/AuthScreen/Bloc/phone_number_event.dart';
import 'package:flutter_app/Screens/AuthScreen/Bloc/phone_number_state.dart';
import 'package:tap_debouncer/tap_debouncer.dart';
import 'package:flutter_app/Internet/check_internet.dart';
import 'package:flutter_app/Screens/AuthScreen/API/auth_data_pass.dart';
import 'package:flutter_app/Screens/AuthScreen/Bloc/phone_number_get_bloc.dart';
import 'package:flutter_app/Screens/AuthScreen/Model/Auth.dart';
import 'package:flutter_app/Screens/CodeScreen/API/auth_code_data_pass.dart';
import 'package:flutter_app/Screens/CodeScreen/Bloc/code_event.dart';
import 'package:flutter_app/Screens/CodeScreen/Bloc/code_get_bloc.dart';
import 'package:flutter_app/Screens/CodeScreen/Bloc/code_state.dart';
import 'package:flutter_app/Screens/HomeScreen/Bloc/restaurant_get_bloc.dart';
import 'package:flutter_app/Screens/HomeScreen/View/home_screen.dart';
import 'package:flutter_app/Screens/NameScreen/View/name_screen.dart';
import 'package:flutter_app/data/data.dart';
import 'package:flutter_app/data/globalVariables.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pin_input_text_field/pin_input_text_field.dart';
import 'dart:async';

import '../../../Amplitude/amplitude.dart';
import '../../../Centrifugo/centrifugo.dart';
import '../../../data/data.dart';
import '../../../data/data.dart';
import '../../AuthScreen/View/auth_screen.dart';

class CodeScreen extends StatefulWidget {
  AuthSources source;
  AuthData authData;

  CodeScreen(this.authData, {this.source = AuthSources.Drawer, Key key}) : super(key: key);

  @override
  _CodeScreenState createState() => _CodeScreenState(source, authData);
}

class _CodeScreenState extends State<CodeScreen> {
  TextEditingController pinController = new TextEditingController();
  AuthSources source;
  AuthData authData;

  // TextField code1;
  // TextField code2;
  // TextField code3;
  // TextField code4;
  String error = '';

  // TextEditingController controller1 = new TextEditingController();
  // TextEditingController controller2 = new TextEditingController();
  // TextEditingController controller3 = new TextEditingController();
  // TextEditingController controller4 = new TextEditingController();
  // String temp1 = '';
  // String temp2 = '';
  // String temp3 = '';
  // String temp4 = '';
  AuthGetBloc authGetBloc;
  GlobalKey<ButtonState> buttonStateKey = new GlobalKey<ButtonState>();
  GlobalKey timerKey;
  CodeGetBloc codeGetBloc;

  _CodeScreenState(this.source, this.authData);

  String code;

  void buttonColor() {
    // String code = code1.controller.text +
    //     code2.controller.text +
    //     code3.controller.text +
    //     code4.controller.text;
    if (code.length == 4 && buttonStateKey.currentState.color != AppColor.mainColor) {
      buttonStateKey.currentState.setState(() {
        buttonStateKey.currentState.color = AppColor.mainColor;
      });
    } else if (code.length < 4 && buttonStateKey.currentState.color != AppColor.subElementsColor) {
      buttonStateKey.currentState.setState(() {
        buttonStateKey.currentState.color = AppColor.subElementsColor;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    codeGetBloc = BlocProvider.of<CodeGetBloc>(context);
    authGetBloc = BlocProvider.of<AuthGetBloc>(context);
    timerKey = new GlobalKey();
    // controller1.addListener(() {
    //   if(controller1.text.length > 1){
    //     if(controller1.text[0] == temp1){
    //       temp1 = controller1.text[1];
    //       controller1.text = controller1.text[1];
    //     }else{
    //       temp1 = controller1.text[0];
    //       controller1.text = controller1.text[0];
    //     }
    //   }
    //   else
    //     temp1 = controller1.text;
    // });
    // controller2.addListener(() {
    //   if(controller2.text.length > 1){
    //     if(controller2.text[0] == temp2){
    //       temp2 = controller2.text[1];
    //       controller2.text = controller2.text[1];
    //     }else{
    //       temp2 = controller2.text[0];
    //       controller2.text = controller2.text[0];
    //     }
    //   }
    //   else
    //     temp2 = controller2.text;
    // });
    // controller3.addListener(() {
    //   if(controller3.text.length > 1){
    //     if(controller3.text[0] == temp3){
    //       temp3 = controller3.text[1];
    //       controller3.text = controller3.text[1];
    //     }else{
    //       temp3 = controller3.text[0];
    //       controller3.text = controller3.text[0];
    //     }
    //   }
    //   else
    //     temp3 = controller3.text;
    // });
    // controller4.addListener(() {
    //   if(controller4.text.length > 1){
    //     if(controller4.text[0] == temp4){
    //       temp4 = controller4.text[1];
    //       controller4.text = controller4.text[1];
    //     }else{
    //       temp4 = controller4.text[0];
    //       controller4.text = controller4.text[0];
    //     }
    //   }
    //   else
    //     temp4 = controller4.text;
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.themeColor,
      body: MultiBlocListener(
        listeners: [
          BlocListener<CodeGetBloc, CodeState>(
            bloc: codeGetBloc,
            listener: (BuildContext context, CodeState state) {
              if (state is CodeStateSuccess) {
                if (state.goToNameScreen) {
                  Navigator.push(
                    context,
                    new MaterialPageRoute(
                      builder: (context) => new NameScreen(
                        source: source,
                      ),
                    ),
                  );
                } else if (state.goToHomeScreen) {
                  if (source == AuthSources.Cart) {
                    for (int i = 0; i < 2; i++) Navigator.pop(context);

                    return;
                  }
                  homeScreenKey = new GlobalKey<HomeScreenState>();
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                        builder: (context) => BlocProvider(
                          create: (context) => RestaurantGetBloc(),
                          child: new HomeScreen(),
                        ),
                      ),
                      (Route<dynamic> route) => false);
                }
              } else {
                timerKey = new GlobalKey();
              }
            },
          ),
          BlocListener<AuthGetBloc, AuthState>(
            bloc: authGetBloc,
            listener: (BuildContext context, AuthState state) {
              if (state is SearchStateError) {
                codeGetBloc.add(CodeSetError(state.error));
              }
            },
          ),
        ],
        child: BlocBuilder<CodeGetBloc, CodeState>(
          bloc: codeGetBloc,
          builder: (BuildContext context, CodeState state) {
            print('updated!!111');
            return Stack(
              children: <Widget>[
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //   children: [
                //     InkWell(
                //       hoverColor: AppColor.themeColor,
                //       focusColor: AppColor.themeColor,
                //       splashColor: AppColor.themeColor,
                //       highlightColor: AppColor.themeColor,
                //       child: Padding(
                //           padding: EdgeInsets.only(left: 20, top: 40),
                //           child: Container(
                //             width: 40,
                //             height: 60,
                //             child: Center(
                //               child: SvgPicture.asset(
                //                   'assets/svg_images/arrow_left.svg'),
                //             ),
                //           )),
                //       onTap: () => Navigator.pop(context),
                //     ),
                //     InkWell(
                //       hoverColor: AppColor.themeColor,
                //       focusColor: AppColor.themeColor,
                //       splashColor: AppColor.themeColor,
                //       highlightColor: AppColor.themeColor,
                //       child:  Padding(
                //           padding: EdgeInsets.only(right: 24, top: 40),
                //           child: Container(
                //             width: 40,
                //             height: 60,
                //             child: Center(
                //               child: SvgPicture.asset(
                //                   'assets/svg_images/code_cross.svg', color: AppColor.textColor,),
                //             ),
                //           )),
                //       onTap: () => Navigator.pop(context),
                //     ),
                //   ],
                // ),
                Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: EdgeInsets.only(left: 31, top: MediaQuery.of(context).viewPadding.top + 27),
                    child: SizedBox(
                      width: 9,
                      height: 18,
                      child: IconButton(
                        padding: EdgeInsets.zero,
                        iconSize: 30,
                        icon: SvgPicture.asset('assets/svg_images/arrow_left.svg'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ),
                  ),
                ),
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 135),
                      child: Center(
                        child: Text(
                          'На номер ${currentUser.phone} отправлен код',
                          style: TextStyle(color: Color(0xFF979797), fontSize: 13),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 15, left: 31, right: 31),
                      child: Align(
                        alignment: Alignment.topCenter,
                        child: Container(
                          // height: 130,
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            color: AppColor.mainColor,
                            // border: Border.all(
                            //   color: mainColor,
                            // ),
                            borderRadius: const BorderRadius.all(
                              const Radius.circular(10.0),
                            ),
                          ),
                          child: Column(
                            children: [
                              Align(
                                alignment: Alignment.topCenter,
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 15.0),
                                  child: Text(
                                    'Введите код из смс',
                                    style: TextStyle(fontSize: 18, color: AppColor.textColor),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 14.0),
                                child: Container(
                                  height: 80.0,
                                  decoration: BoxDecoration(
                                    border: Border.all(color: AppColor.mainColor),
                                    borderRadius: BorderRadius.only(bottomRight: Radius.circular(10), bottomLeft: Radius.circular(10)),
                                    color: AppColor.fieldColor,
                                  ),
                                  child: Align(
                                    alignment: Alignment.bottomCenter,
                                    child: Padding(
                                      padding: const EdgeInsets.only(top: 6.0),
                                      child: Container(
                                        width: 200.0,
                                        padding: EdgeInsets.only(bottom: 19.0),
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.only(bottomRight: Radius.circular(10), bottomLeft: Radius.circular(10)),
                                            color: Colors.white),
                                        child: PinInputTextField(
                                          keyboardType: TextInputType.number,
                                          autoFocus: true,
                                          controller: pinController,
                                          pinLength: 4,
                                          inputFormatters: [
                                            FilteringTextInputFormatter.digitsOnly,
                                          ],
                                          decoration: UnderlineDecoration(
                                            textStyle: TextStyle(
                                              color: Colors.black,
                                              fontSize: 30.0,
                                            ),
                                            colorBuilder: PinListenColorBuilder(
                                              Colors.black26,
                                              Colors.black26,
                                            ),
                                          ),
                                          // inputFormatter: <TextInputFormatter>[
                                          //   WhitelistingTextInputFormatter.digitsOnly
                                          // ],
                                          onChanged: (String newPin) async {
                                            if (this.mounted) {
                                              setState(() {
                                                code = newPin;
                                                buttonColor();
                                              });
                                            }
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    (state is CodeSearchStateError)
                        ? Center(
                            child: Padding(
                              padding: const EdgeInsets.only(top: 16, left: 31, right: 31),
                              child: Text(
                                getAuthorizationError(state.error),
                                style: TextStyle(
                                  color: Colors.red,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          )
                        : Container(),
                  ],
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                      padding: EdgeInsets.only(bottom: 90, top: 15),
                      child: new TimerCountDown(
                        codeScreenState: this,
                        key: timerKey,
                      )),
                ),
                Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: EdgeInsets.only(top: 10),
                      child: SafeArea(
                        minimum: EdgeInsets.only(bottom: 10),
                        bottom: true,
                        child: Button(
                          key: buttonStateKey,
                          color: AppColor.unselectedBorderFieldColor.withOpacity(0.2),
                          onTap: () async {
                            if (await Internet.checkConnection()) {
                              String temp = '';
                              temp = code;
                              codeGetBloc.add(SendCode(code: int.parse(temp)));
                            } else {
                              noConnection(context);
                            }
                          },
                        ),
                      ),
                    ))
              ],
            );
          },
        ),
      ),
    );
  }
}

class TimerCountDown extends StatefulWidget {
  TimerCountDown({
    Key key,
    this.codeScreenState,
  }) : super(key: key);
  final _CodeScreenState codeScreenState;

  @override
  TimerCountDownState createState() {
    return new TimerCountDownState(codeScreenState: codeScreenState);
  }
}

class TimerCountDownState extends State<TimerCountDown> {
  TimerCountDownState({this.codeScreenState});

  AuthGetBloc authGetBloc;

  final _CodeScreenState codeScreenState;
  Timer _timer;
  int _start = 60;

  void startTimer() {
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(oneSec, (Timer timer) {
      try {
        setState(
          () {
            if (_start < 1) {
              timer.cancel();
              _timer.cancel();
            } else {
              _start = _start - 1;
            }
          },
        );
      } catch (e) {
        _timer.cancel();
        timer.cancel();
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    authGetBloc = BlocProvider.of<AuthGetBloc>(context);
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_start == 60) {
      startTimer();
    }
    return _start != 0
        ? Text('Получить новый код можно через $_start c',
            style: TextStyle(
              color: AppColor.additionalTextColor,
              fontSize: 13.0,
              letterSpacing: 1.2,
            ))
        : GestureDetector(
            child: Text(
              'Отправить код повторно',
              style: TextStyle(color: AppColor.additionalTextColor),
            ),
            onTap: () {
              authGetBloc.add(SendPhoneNumber(phoneNumber: currentUser.phone));
              //codeScreenState.codeGetBloc.add(CodeSetError("Вы ввели неверный смс код"));
              if (codeScreenState.codeGetBloc.state is CodeStateEmpty)
                codeScreenState.codeGetBloc.add(CodeInitialLoad(flag: !(codeScreenState.codeGetBloc.state as CodeStateEmpty).flag));
              else
                codeScreenState.codeGetBloc.add(CodeInitialLoad());
            },
          );
  }
}

class Button extends StatefulWidget {
  Color color;
  final AsyncCallback onTap;

  Button({Key key, this.color, this.onTap}) : super(key: key);

  @override
  ButtonState createState() {
    return new ButtonState(color, onTap);
  }
}

class ButtonState extends State<Button> {
  String error = '';

  // TextField code1;
  // TextField code2;
  // TextField code3;
  // TextField code4;
  Color color;
  final AsyncCallback onTap;

  ButtonState(this.color, this.onTap);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Stack(
      children: [
        Container(
          width: MediaQuery.of(context).size.width - 62,
          height: 52,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(
            child: Text('Далее', style: TextStyle(fontSize: 18.0, color: AppColor.textColor)),
          ),
        ),
        Material(
          type: MaterialType.transparency,
          child: TapDebouncer(
              cooldown: const Duration(seconds: 10),
              onTap: () async {
                if (await Internet.checkConnection()) {
                  await onTap();
                } else {
                  noConnection(context);
                }
              },
              builder: (BuildContext context, TapDebouncerFunc onTap) {
                return InkWell(
                  borderRadius: BorderRadius.circular(10),
                  splashColor: AppColor.unselectedBorderFieldColor.withOpacity(0.5),
                  child: Container(
                    width: MediaQuery.of(context).size.width - 62,
                    height: 52,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onTap: onTap,
                );
              }),
        ),
      ],
    );
  }

  String validateMobile(String value) {
    String pattern = r'(^(?:[+]?7)[0-9]{10}$)';
    RegExp regExp = new RegExp(pattern);
    if (value.length == 0) {
      return 'Укажите норер';
    } else if (!regExp.hasMatch(value)) {
      return 'Указан неверный номер';
    }
    return null;
  }
}
