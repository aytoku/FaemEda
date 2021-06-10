import 'package:flutter/material.dart';
import 'package:flutter_app/Screens/CartScreen/View/cart_page_view.dart';
import 'package:flutter_app/Screens/HomeScreen/Bloc/restaurant_get_bloc.dart';
import 'package:flutter_app/Screens/RestaurantScreen/View/restaurant_screen.dart';
import 'package:flutter_app/data/globalVariables.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../data/data.dart';
import '../../HomeScreen/Model/FilteredStores.dart';
import '../../HomeScreen/View/home_screen.dart';

class EmptyCartScreen extends StatefulWidget {
  final FilteredStores restaurant;
  CartSources source;

  EmptyCartScreen({Key key, this.restaurant, this.source}) : super(key: key);

  @override
  EmptyCartScreenState createState() {
    return new EmptyCartScreenState(restaurant, source);
  }
}

class EmptyCartScreenState extends State<EmptyCartScreen> {
  final FilteredStores restaurant;
  CartSources source;

  EmptyCartScreenState(this.restaurant, this.source);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: InkWell(
              hoverColor: Colors.white,
              focusColor: Colors.white,
              splashColor: Colors.white,
              highlightColor: Colors.white,
              child: Container(
                  child: Padding(
                    padding: EdgeInsets.all(
                        19),
                    child: SvgPicture.asset(
                        'assets/svg_images/arrow_left.svg'),
                  )),
            onTap: () {
              if(source == CartSources.Home){
                homeScreenKey = new GlobalKey<HomeScreenState>();
                Navigator.pushReplacement(context,
                    new MaterialPageRoute(
                        builder: (context) => BlocProvider(
                          create: (context) => RestaurantGetBloc(),
                          child: new HomeScreen(),
                        )
                    )
                );
              }else if(source == CartSources.Restaurant){
                Navigator.pushReplacement(context,
                    new MaterialPageRoute(builder:
                        (context)=>RestaurantScreen(restaurant: restaurant)
                    )
                );
              }else if(source == CartSources.Other){
                homeScreenKey = new GlobalKey<HomeScreenState>();
                Navigator.pushReplacement(context,
                    new MaterialPageRoute(
                        builder: (context) => BlocProvider(
                          create: (context) => RestaurantGetBloc(),
                          child: new HomeScreen(),
                        )
                    )
                );
              }
            },
          ),
          title: Text(
            'Корзина',
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF3F3F3F)),
          ),
        ),
        body: Container(
            color: AppColor.themeColor,
            child: Stack(
              children: <Widget>[
                Align(
                  alignment: Alignment.center,
                  child: Padding(
                    padding: EdgeInsets.only(top: 0),
                    child: Container(
                      decoration: BoxDecoration(color: Color(0xFFFAFAFA)),
                      child: Column(
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(top: 30),
                            child: Center(
                              child: SvgPicture.asset(
                                  'assets/svg_images/basket.svg'),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 20),
                            child: Center(
                                child: Text(
                                  'Корзина пуста',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 17,
                                      color: Color(0xFF424242)),
                                )),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 10, bottom: 100),
                            child: Center(
                              child: Text(
                                'Вернитесь на главную,\nчтобы оформить заказ заново',
                                style:
                                TextStyle(color: Color(0xFFB0B0B0), fontSize: 15),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: GestureDetector(
                      child: Container(
                        height: 52,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          color: AppColor.mainColor,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding:
                          EdgeInsets.only(bottom: 15, left: 15, right: 15, top: 15),
                          child: Center(
                            child: Text(
                                'Вернуться на главную',
                                style: TextStyle(
                                    fontSize: 18.0,
                                    color: AppColor.textColor)
                            ),
                          ),
                        ),
                      ),
                      onTap: () {
                        homeScreenKey = new GlobalKey<HomeScreenState>();
                        Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                                builder: (context) => BlocProvider(
                                  create: (context) => RestaurantGetBloc(),
                                  child: new HomeScreen(),
                                )),
                                (Route<dynamic> route) => false);
                      },
                    ),
                  ),
                ),
              ],
            )
        ),
      ),
    );
  }
}