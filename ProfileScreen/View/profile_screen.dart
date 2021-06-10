import 'package:flutter/material.dart';
import 'package:flutter_app/Config/config.dart';
import 'package:flutter_app/Internet/check_internet.dart';
import 'package:flutter_app/Screens/AuthScreen/Bloc/phone_number_get_bloc.dart';
import 'package:flutter_app/Screens/AuthScreen/View/auth_screen.dart';
import 'package:flutter_app/Screens/HomeScreen/Bloc/restaurant_get_bloc.dart';
import 'package:flutter_app/Screens/HomeScreen/View/home_screen.dart';
import 'package:flutter_app/data/data.dart';
import 'package:flutter_app/data/globalVariables.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

class ProfileScreen extends StatefulWidget {
  @override
  ProfileScreenState createState() => ProfileScreenState();
}

class ProfileScreenState extends State<ProfileScreen> {
  TextEditingController nameField;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    nameField = new TextEditingController();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    nameField.dispose();
  }

  @override
  Widget build(BuildContext context) {
    nameField.text = necessaryDataForAuth.name;
    // TODO: implement build
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: Column(
          children: <Widget>[
            Align(
              child: Padding(
                padding: EdgeInsets.only(top: 30, bottom: 25),
                child: Stack(
                  children: <Widget>[
                    Align(
                      alignment: Alignment.topLeft,
                      child: InkWell(
                        child: Padding(
                            padding: EdgeInsets.only(),
                            child: Container(
                                height: 40,
                                width: 60,
                                child: Padding(
                                  padding: EdgeInsets.only(
                                      top: 12, bottom: 12, right: 0),
                                  child: SvgPicture.asset(
                                      'assets/svg_images/arrow_left.svg'),
                                ))),
                        onTap: () async {
                          if (await Internet.checkConnection()) {
                            homeScreenKey = new GlobalKey<HomeScreenState>();
                            Navigator.of(context).pushAndRemoveUntil(
                                PageRouteBuilder(
                                    pageBuilder: (context, animation, anotherAnimation) {
                                      return BlocProvider(
                                      create: (context) => RestaurantGetBloc(),
                                      child: new HomeScreen(),
                                      );
                                    },
                                    transitionDuration: Duration(milliseconds: 300),
                                    transitionsBuilder:
                                        (context, animation, anotherAnimation, child) {
                                      return SlideTransition(
                                        position: Tween(
                                            begin: Offset(1.0, 0.0),
                                            end: Offset(0.0, 0.0))
                                            .animate(animation),
                                        child: child,
                                      );
                                    }
                                ), (Route<dynamic> route) => false);
                          } else {
                            noConnection(context);
                          }
                        },
                      ),
                    ),
                    Align(
                      alignment: Alignment.topCenter,
                      child: Padding(
                        padding: EdgeInsets.only(top: 10),
                        child: Text(
                          "Ваши данные",
                          style: TextStyle(
                              fontSize: 17, fontWeight: FontWeight.bold),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            Flexible(
              flex: 3,
              child: Container(
                child: Column(
                  children: <Widget>[
                    Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding:
                          EdgeInsets.only(left: 30, top: 0, bottom: 10),
                          child: Text(
                            'Ваше имя',
                            style: TextStyle(
                                fontSize: 13, color: Color(0xFF8A8A8A)),
                          ),
                        )),
                    Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          height: 30,
                          child: Padding(
                            padding:
                            EdgeInsets.only(left: 30, right: 0, bottom: 10),
                            child: TextField(
                              textCapitalization: TextCapitalization.sentences,
                              style: TextStyle(
                                  color: Color(0xFF515151), fontSize: 17),
                              controller: nameField,
                              textAlign: TextAlign.start,
                              keyboardType: TextInputType.text,
                              decoration: new InputDecoration(
                                border: InputBorder.none,
                                counterText: '',
                              ),
                              onChanged: (value) {
                                necessaryDataForAuth.name = value;
                                NecessaryDataForAuth.saveData();
                              },
                            ),
                          ),
                        )),
                    Padding(
                      padding: EdgeInsets.only(left: 15, right: 15),
                      child: Divider(height: 1.0, color: Color(0xFFEDEDED)),
                    ),
                    Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding:
                          EdgeInsets.only(left: 30, top: 20, bottom: 15),
                          child: Text(
                            'Номер телефона',
                            style: TextStyle(
                                fontSize: 13, color: Color(0xFF8A8A8A)),
                          ),
                        )),
                    Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                            padding:
                            EdgeInsets.only(left: 30, right: 0, bottom: 10),
                            child: GestureDetector(
                              child: Text(
                                necessaryDataForAuth.phone_number,
                                style: TextStyle(
                                    fontSize: 17, color: Color(0xFF515151)),
                              ),
                              onTap: () {
                                Navigator.pushReplacement(
                                  context,
                                  new MaterialPageRoute(
                                    builder: (context) => BlocProvider(
                                      create: (context)=> AuthGetBloc(),
                                      child: AuthScreen(),
                                    ),
                                  ),
                                );
                              },
                            ))),
                    Padding(
                      padding: EdgeInsets.only(left: 15, right: 15),
                      child: Divider(height: 1.0, color: Color(0xFFEDEDED)),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ));
  }
}
