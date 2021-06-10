import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/Internet/check_internet.dart';
import 'package:flutter_app/Screens/AuthScreen/Bloc/phone_number_event.dart';
import 'package:flutter_app/Screens/AuthScreen/Bloc/phone_number_get_bloc.dart';
import 'package:flutter_app/Screens/AuthScreen/Bloc/phone_number_state.dart';
import 'package:flutter_app/Screens/AuthScreen/Widgets/AuthButton.dart';
import 'package:flutter_app/Screens/CodeScreen/Bloc/code_get_bloc.dart';
import 'package:flutter_app/Screens/HomeScreen/Bloc/restaurant_get_bloc.dart';
import 'package:flutter_app/Screens/HomeScreen/View/home_screen.dart';
import 'package:flutter_app/data/data.dart';
import 'package:flutter_app/data/globalVariables.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:flutter_svg/svg.dart';
import '../../../data/data.dart';
import '../../CodeScreen/View/code_screen.dart';

class AuthScreen extends StatefulWidget {
  AuthSources source;

  AuthScreen({this.source = AuthSources.Drawer, Key key}) : super(key: key);

  @override
  _AuthScreenState createState() => _AuthScreenState(source);
}

class _AuthScreenState extends State<AuthScreen> {
  AuthSources source;
  final controller = TextEditingController();
  AuthGetBloc authGetBloc;
  Color colorButton;
  GlobalKey<AuthButtonState> buttonStateKey;
  final phoneFormatter = PhoneInputFormatter();

  _AuthScreenState(this.source);

  @override
  void initState() {
    super.initState();
    authGetBloc = BlocProvider.of<AuthGetBloc>(context); // инициализация bloc
    buttonStateKey = new GlobalKey<AuthButtonState>();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    colorButton = AppColor.unselectedBorderFieldColor.withOpacity(0.2);
    return Scaffold(
        backgroundColor: AppColor.themeColor,
        body: BlocListener<AuthGetBloc, AuthState>(
          // листенер для переходов на другие скрины
          bloc: authGetBloc,
          listener: (BuildContext context, AuthState state) {
            if (state is AuthStateSuccess) {
              if (state.goToHomeScreen) {
                homeScreenKey = new GlobalKey<HomeScreenState>();
                Navigator.of(context).pushAndRemoveUntil(
                    new MaterialPageRoute(
                      builder: (context) => BlocProvider(
                        create: (context) => RestaurantGetBloc(),
                        child: new HomeScreen(),
                      ),
                    ),
                    (Route<dynamic> route) => false);
              } else {
                Navigator.push(
                  context,
                  new MaterialPageRoute(
                      builder: (context) => MultiBlocProvider(providers: [
                            BlocProvider<CodeGetBloc>(
                              create: (BuildContext context) => CodeGetBloc(),
                            ),
                            BlocProvider<AuthGetBloc>(
                              create: (BuildContext context) => AuthGetBloc(),
                            ),
                          ], child: new CodeScreen(state.authData, source: source))),
                );
              }
            }
          },
          child: BlocBuilder<AuthGetBloc, AuthState>(
            // билдинг скрина в зависимости от состояния
            bloc: authGetBloc,
            builder: (BuildContext context, AuthState state) {
              return Stack(
                children: <Widget>[
                  Align(
                    alignment: Alignment.topCenter,
                    child: Row(
                      children: <Widget>[
                        InkWell(
                          hoverColor: AppColor.themeColor,
                          focusColor: AppColor.themeColor,
                          splashColor: AppColor.themeColor,
                          highlightColor: AppColor.themeColor,
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Padding(
                              padding: EdgeInsets.only(left: 15, top: 40),
                              child: Container(
                                  height: 40,
                                  width: 60,
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                        top: 12, bottom: 12, right: 10),
                                    child: SvgPicture.asset(
                                        'assets/svg_images/arrow_left.svg'),
                                  )),),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 140, left: 31, right: 31),
                        child: Align(
                          alignment: Alignment.topCenter,
                          child: Container(
                            height: 82,
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                              color: AppColor.mainColor,
                              border: Border.all(
                                color: AppColor.mainColor,
                              ),
                              borderRadius: const BorderRadius.all(
                                const Radius.circular(10.0),
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  height: 41,
                                  alignment: Alignment.center,
                                  child: Text(
                                    'Укажите ваш номер телефона',
                                    style: TextStyle(fontSize: 18, color: AppColor.textColor),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    height: 41,
                                      child: TextField(
                                        autofocus: true,
                                        controller: controller,
                                        style: TextStyle(fontSize: 18),
                                        textAlign: TextAlign.center,
                                        inputFormatters: [phoneFormatter],
                                        cursorColor: AppColor.mainColor,
                                        keyboardType: TextInputType.number,
                                        decoration: new InputDecoration(
                                          contentPadding: EdgeInsets.zero,
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.only(
                                              bottomLeft: Radius.circular(10),
                                              bottomRight: Radius.circular(10),
                                            ),
                                            borderSide: BorderSide(
                                              width: 0,
                                              style: BorderStyle.none,
                                            ),
                                          ),
                                          filled: true,
                                          fillColor: AppColor.themeColor,
                                          counterText: '',
                                          hintStyle: TextStyle(
                                            color: Color(0xFFC0BFC6),
                                          ),
                                          hintText: '+7 918 888-88-88',
                                        ),
                                        onChanged: (String value) async {
                                          if (value.isNotEmpty && value[0] == '9') {
                                            controller.text = value.replaceRange(0, 1, phoneFormatter.mask('+7 9'));
                                            controller.selection = TextSelection.fromPosition(TextPosition(offset: controller.text.length));
                                          }
                                          currentUser.phone = phoneFormatter.unmasked;
                                          if (phoneFormatter.isFilled) {
                                            buttonStateKey.currentState.setState(() {
                                              buttonStateKey.currentState.color = AppColor.mainColor;
                                              FocusScope.of(context).requestFocus(new FocusNode());
                                              print(currentUser.phone.length);
                                            });
                                          } else {
                                            buttonStateKey.currentState.setState(() {
                                              buttonStateKey.currentState.color = Color(0xF3F3F3F3);
                                              colorButton = AppColor.unselectedBorderFieldColor.withOpacity(0.2);
                                            });
                                          }
                                        },
                                      )),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      (state is SearchStateError)
                          ? Center(
                              child: Padding(
                                padding: const EdgeInsets.only(top: 11, left: 31, right: 31),
                                child: Text(
                                  getAuthorizationError(state.error),
                                  style: TextStyle(color: Colors.red, fontSize: 12),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            )
                          : Container(),
                    ],
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: SafeArea(
                        minimum: EdgeInsets.only(bottom: 15),
                        bottom: true,
                        child: AuthButton(
                            key: buttonStateKey, color: AppColor.unselectedBorderFieldColor.withOpacity(0.2), source: source, authGetBloc: authGetBloc)),
                  ),
                ],
              );
            },
          ),
        ));
  }
}

enum AuthSources { Drawer, Cart }
