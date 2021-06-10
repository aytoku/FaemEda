import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/Internet/check_internet.dart';
import 'package:flutter_app/Screens/HomeScreen/Bloc/restaurant_get_bloc.dart';
import 'package:flutter_app/Screens/HomeScreen/Model/FilteredStores.dart';
import 'package:flutter_app/Screens/HomeScreen/View/home_screen.dart';
import 'package:flutter_app/data/data.dart';
import 'package:flutter_app/data/globalVariables.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'SliverBackButton.dart';
import 'SliverText.dart';

class SliverAppBarSettings extends StatefulWidget {
  SliverAppBarSettings({
    this.key,
  }) : super(key: key);
  final GlobalKey<SliverAppBarSettingsState> key;

  @override
  SliverAppBarSettingsState createState() {
    return new SliverAppBarSettingsState();
  }
}

class SliverAppBarSettingsState extends State<SliverAppBarSettings>{

  FilteredStores restaurant;
  GlobalKey<SliverTextState>sliverTextKey = new GlobalKey();
  GlobalKey<SliverBackButtonState>sliverImageKey = new GlobalKey();
  ScrollController sliverScrollController;
  Color color = Colors.transparent;
  SliverAppBarSettingsState();

  bool get _isAppBarExpanded {
    return sliverScrollController.hasClients && sliverScrollController.offset > 90;
  }


  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      brightness: _isAppBarExpanded ? Brightness.dark : Brightness.light,
      expandedHeight: 100.0,
      floating: false,
      pinned: true,
      snap: false,
      stretch: true,
      elevation: 0,
      backgroundColor: color,
      leading: InkWell(
        hoverColor: Colors.transparent,
        focusColor: Colors.transparent,
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        child: Container(
          height: 20,
          width: 60,
          child: Padding(
            padding: const EdgeInsets.only(top: 20, bottom: 0, right: 10),
            child: SliverBackButton(key: sliverImageKey, image: null,),
          ),
        ),
        onTap: () async {
          homeScreenKey =
          new GlobalKey<HomeScreenState>();
          if(await Internet.checkConnection()){
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
          }else{
            noConnection(context);
          }
        },
      ),
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        title: SliverText(title: Text('', style: TextStyle(fontSize: 18),),key: sliverTextKey,),
        background: AnnotatedRegion<SystemUiOverlayStyle>(
          value: (Platform.isIOS) ? _isAppBarExpanded ? SystemUiOverlayStyle.dark : SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark,
          child: ClipRRect(
              child: Stack(
                children: <Widget>[
                  Image.network(
                    getImage((restaurant.meta.images != null && restaurant.meta.images.length > 0) ? restaurant.meta.images[0] : ''),
                    fit: BoxFit.cover,
                    height: 500.0,
                    alignment: Alignment.topCenter,
                    width: MediaQuery.of(context).size.width,
                  ),
                  Align(
                      alignment: Alignment.topLeft,
                      child: Padding(
                        padding: EdgeInsets.only(top: 40, left: 15),
                        child: GestureDetector(
                          child: SvgPicture.asset(
                              'assets/svg_images/rest_arrow_left.svg'),
                          onTap: () async {
                            if(await Internet.checkConnection()){
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
                            }else{
                              noConnection(context);
                            }
                          },
                        ),
                      ))
                ],
              )),
        ),
      ),
    );
  }
}