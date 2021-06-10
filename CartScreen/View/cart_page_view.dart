import 'dart:io' show Platform;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/Internet/check_internet.dart';
import 'package:flutter_app/Screens/AuthScreen/Bloc/phone_number_get_bloc.dart';
import 'package:flutter_app/Screens/AuthScreen/View/auth_screen.dart';
import 'package:flutter_app/Screens/CartScreen/API/clear_cart.dart';
import 'package:flutter_app/Screens/CartScreen/Widgets/TotalPrice.dart';
import 'package:flutter_app/Screens/HomeScreen/Bloc/restaurant_get_bloc.dart';
import 'package:flutter_app/Screens/HomeScreen/Model/FilteredStores.dart';
import 'package:flutter_app/Screens/HomeScreen/View/home_screen.dart';
import 'package:flutter_app/Screens/OrderConfirmationScreen/View/address_screen.dart';
import 'package:flutter_app/Screens/RestaurantScreen/View/restaurant_screen.dart';
import 'package:flutter_app/data/data.dart';
import 'package:flutter_app/data/globalVariables.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import '../../../Amplitude/amplitude.dart';
import '../../AuthScreen/View/auth_screen.dart';
import '../../HomeScreen/View/home_screen.dart';
import 'cart_screen.dart';
import 'empty_cart_screen.dart';

class CartPageScreen extends StatefulWidget {
  final FilteredStores restaurant;
  CartSources source;

  CartPageScreen({Key key, this.restaurant, this.source}) : super(key: key);

  @override
  CartPageState createState() => CartPageState(restaurant, source);
}

class CartPageState extends State<CartPageScreen> {
  final FilteredStores restaurant;

  int selectedPageId = 0;
  GlobalKey<CartScreenState> cartTakeAwayScreenKey;
  GlobalKey<CartScreenState> cartScreenKey;
  TotalPrice totalPriceWidget;
  CartSources source;

  int selectedPaymentId = 0;

  CartPageState(this.restaurant, this.source);

  PageController _controller;

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.black, // Color for Android
        statusBarBrightness: Brightness.dark // Dark == white status bar -- for IOS.
    ));
    cartTakeAwayScreenKey = new GlobalKey<CartScreenState>();
    cartScreenKey = new GlobalKey<CartScreenState>();
    totalPriceWidget = new TotalPrice(
      key: new GlobalKey(),
    );
    _controller = PageController(
      initialPage: 0,
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    FocusNode focusNode;
    double totalPrice = 0;
    // currentUser.cartModel.cart.forEach(
    //         (Order order) {
    //       if(order.food.variants != null && order.food.variants.length > 0 && order.food.variants[0].price != null){
    //         totalPrice += order.quantity * (order.food.price + order.food.variants[0].price);
    //       }else{
    //         totalPrice += order.quantity * order.food.price;
    //       }
    //       double toppingsCost = 0;
    //       if(order.food.toppings != null){
    //         order.food.toppings.forEach((element) {
    //           toppingsCost += order.quantity * element.price;
    //         });
    //         totalPrice += toppingsCost;
    //       }
    //     }
    // );
    var cartScreen = CartScreen(
      restaurant: restaurant,
      key: cartScreenKey,
      parent: this,
      isTakeAwayScreen: false,
    );
    var cartTakeAwayScreen = CartScreen(
      restaurant: restaurant,
      key: cartTakeAwayScreenKey,
      parent: this,
      isTakeAwayScreen: true,
    );
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(statusBarColor: Colors.white, statusBarBrightness: Brightness.light),
      child: WillPopScope(
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          body: Container(
            color: AppColor.themeColor,
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(top: MediaQuery.of(context).viewPadding.top, bottom: 10, left: 15, right: 15),
                  child: Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
                          width: 40,
                          child: InkWell(
                              hoverColor: AppColor.themeColor,
                              focusColor: AppColor.themeColor,
                              splashColor: AppColor.themeColor,
                              highlightColor: AppColor.themeColor,
                              onTap: () {
                                if (source == CartSources.Home) {
                                  homeScreenKey = new GlobalKey<HomeScreenState>();
                                  Navigator.pushReplacement(
                                      context,
                                      new MaterialPageRoute(
                                          builder: (context) => BlocProvider(
                                            create: (context) => RestaurantGetBloc(),
                                            child: new HomeScreen(),
                                          )));
                                } else if (source == CartSources.Restaurant) {
                                  Navigator.pushReplacement(context, new MaterialPageRoute(builder: (context) => RestaurantScreen(restaurant: restaurant)));
                                } else if (source == CartSources.Other) {
                                  Navigator.pop(context);
                                  setState(() {});
                                }
                              },
                              child: Container(
                                  height: 40,
                                  width: 60,
                                  child: Padding(
                                    padding: EdgeInsets.only(top: 12, bottom: 12, right: 15, left: 0),
                                    child: SvgPicture.asset('assets/svg_images/arrow_left.svg'),
                                  ))),
                        ),
                        Text(
                          'Корзина',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF3F3F3F),
                          ),
                          textAlign: TextAlign.center,
                        ),
                        Container(
                            child: InkWell(
                              child: Container(
                                height: 40,
                                width: 40,
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 10, bottom: 10),
                                  child: SvgPicture.asset('assets/svg_images/del_basket.svg'),
                                ),
                              ),
                              onTap: () {
                                if (Platform.isIOS) {
                                  return showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return Padding(
                                          padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.75),
                                          child: CupertinoActionSheet(
                                            actions: [
                                              CupertinoActionSheetAction(
                                                child: Text(
                                                  "Очистить корзину",
                                                  style: TextStyle(color: Color(0xFFFF3B30), fontSize: 20),
                                                ),
                                                onPressed: () async {
                                                  currentUser.cartModel = await clearCart(necessaryDataForAuth.device_id);
                                                  setState(() {
                                                    AmplitudeAnalytics.analytics.logEvent('clear_cart', eventProperties: {
                                                      'uuid': currentUser.cartModel.uuid
                                                    });
                                                  });
                                                  Navigator.pushReplacement(
                                                    context,
                                                    new MaterialPageRoute(
                                                      builder: (context) => new EmptyCartScreen(
                                                        restaurant: restaurant,
                                                        source: source,
                                                      ),
                                                    ),
                                                  );
                                                },
                                              ),
                                            ],
                                            cancelButton: CupertinoActionSheetAction(
                                              child: Text(
                                                "Отмена",
                                                style: TextStyle(color: Color(0xFF007AFF), fontSize: 20),
                                              ),
                                              onPressed: () {
                                                Navigator.pop(context);
                                                AmplitudeAnalytics.analytics.logEvent('not_clear_cart', eventProperties: {
                                                  'uuid': currentUser.cartModel.uuid
                                                });
                                              },
                                            ),
                                          ),
                                        );
                                      });
                                } else {
                                  return showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return Padding(
                                        padding: EdgeInsets.only(bottom: 0),
                                        child: Dialog(
                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(15.0))),
                                          child: Container(
                                              height: 130,
                                              width: 300,
                                              child: Column(
                                                children: <Widget>[
                                                  InkWell(
                                                    child: Container(
                                                      padding: EdgeInsets.only(top: 20, bottom: 20),
                                                      child: Center(
                                                        child: Text(
                                                          "Очистить корзину",
                                                          style: TextStyle(color: Color(0xFFFF3B30), fontSize: 20),
                                                        ),
                                                      ),
                                                    ),
                                                    onTap: () async {
                                                      currentUser.cartModel = await clearCart(necessaryDataForAuth.device_id);
                                                      setState(() {
                                                        AmplitudeAnalytics.analytics.logEvent('clear_cart', eventProperties: {
                                                          'uuid': currentUser.cartModel.uuid
                                                        });
                                                      });
                                                      Navigator.pushReplacement(
                                                        context,
                                                        new MaterialPageRoute(
                                                          builder: (context) => new EmptyCartScreen(restaurant: restaurant, source: source),
                                                        ),
                                                      );
                                                    },
                                                  ),
                                                  Divider(
                                                    height: 1,
                                                    color: Colors.grey,
                                                  ),
                                                  InkWell(
                                                    child: Container(
                                                      padding: EdgeInsets.only(top: 20, bottom: 20),
                                                      child: Center(
                                                        child: Text(
                                                          "Отмена",
                                                          style: TextStyle(color: Color(0xFF007AFF), fontSize: 20),
                                                        ),
                                                      ),
                                                    ),
                                                    onTap: () {
                                                      Navigator.pop(context);
                                                      AmplitudeAnalytics.analytics.logEvent('not_clear_cart', eventProperties: {
                                                        'uuid': currentUser.cartModel.uuid
                                                      });
                                                    },
                                                  ),
                                                ],
                                              )),
                                        ),
                                      );
                                    },
                                  );
                                }
                              },
                            )),
                      ],
                    ),
                  ),
                ),
                Divider(
                  color: Color(0xFFE6E6E6),
                  height: 1,
                ),
                // Padding(
                //   padding: const EdgeInsets.only(left: 15, right: 15, bottom: 10),
                //   child: Container(
                //     decoration: BoxDecoration(
                //       color: AppColor.mainColor,
                //       borderRadius: BorderRadius.circular(4),
                //       border: Border.all(
                //         color: AppColor.mainColor,
                //         width: 0.5
                //       ),
                //     ),
                //     height: 40,
                //     child: Row(
                //       children: <Widget>[
                //         Expanded(
                //           flex: 5,
                //           child: GestureDetector(
                //             child: Container(
                //               decoration: BoxDecoration(
                //                 borderRadius: BorderRadius.only(
                //                   topLeft: Radius.circular(4),
                //                   bottomLeft: Radius.circular(4),
                //                 ),
                //                 border: Border.all(
                //                     color: AppColor.mainColor,
                //                     width: 0.5
                //                 ),
                //                 color: (selectedPageId == 0) ? AppColor.mainColor : AppColor.themeColor,
                //               ),
                //               child: Center(
                //                 child: Text(
                //                   'Доставка',
                //                   style: TextStyle(
                //                       color: (selectedPageId == 0) ? AppColor.textColor : AppColor.mainColor, fontSize: 15),
                //                 ),
                //               ),
                //             ),
                //             onTap: () async {
                //               if (await Internet.checkConnection()) {
                //                 _controller.animateToPage(
                //                   0,
                //                   duration: const Duration(milliseconds: 400),
                //                   curve: Curves.easeInOut,
                //                 );
                //                 AmplitudeAnalytics.analytics.logEvent('delivery ', eventProperties: {
                //                   'uuid': currentUser.cartModel.uuid
                //                 });
                //               } else {
                //                 noConnection(context);
                //               }
                //             },
                //           ),
                //         ),
                //         Expanded(
                //           flex: 5,
                //           child: GestureDetector(
                //             child: Container(
                //               decoration: BoxDecoration(
                //                 borderRadius: BorderRadius.only(
                //                   topRight: Radius.circular(4),
                //                   bottomRight: Radius.circular(4),
                //                 ),
                //                 border: Border.all(
                //                     color: AppColor.mainColor,
                //                     width: 0.5
                //                 ),
                //                 color: (selectedPageId == 1) ? AppColor.mainColor : AppColor.themeColor,
                //               ),
                //               child: Center(
                //                 child: Text(
                //                   'Самовывоз',
                //                   style: TextStyle(
                //                       color: (selectedPageId == 1) ? AppColor.textColor : AppColor.mainColor, fontSize: 15),
                //                 ),
                //               ),
                //             ),
                //             onTap: () async {
                //               if (await Internet.checkConnection()) {
                //                 _controller.animateToPage(
                //                   1,
                //                   duration: const Duration(milliseconds: 400),
                //                   curve: Curves.easeIn,
                //                 );
                //                 AmplitudeAnalytics.analytics.logEvent('without_delivery ', eventProperties: {
                //                   'uuid': currentUser.cartModel.uuid
                //                 });
                //               } else {
                //                 noConnection(context);
                //               }
                //             },
                //           ),
                //         ),
                //       ],
                //     ),
                //   ),
                // ),
                // Expanded(
                //   child: PageView(
                //     controller: _controller,
                //     children: [cartScreen, cartTakeAwayScreen],
                //     onPageChanged: (int pageId) {
                //       setState(() {
                //         selectedPageId = pageId;
                //       });
                //     },
                //   ),
                // ),
                cartScreen,
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(color: AppColor.themeColor, boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4, spreadRadius: 1)]),
                    child: Padding(
                      padding: EdgeInsets.only(top: 15, right: 20, left: 50, bottom: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 5),
                            child: Column(
                              children: [
                                totalPriceWidget,
                                // Padding(
                                //   padding: const EdgeInsets.only(right: 3),
                                //   child: Text(
                                //     (currentUser.cartModel.cookingTime != null)
                                //         ? '~' + '${currentUser.cartModel.cookingTime ~/ 60} мин'
                                //         : '',
                                //     style: TextStyle(
                                //       fontSize: 12.0,
                                //       color: Colors.black,
                                //     ),
                                //   ),
                                // ),
                              ],
                            ),
                          ),
                          InkWell(
                            child: Container(
                              height: 52,
                              width: 168,
                              decoration: BoxDecoration(
                                color: AppColor.mainColor,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Center(
                                child: Text('Далее', style: TextStyle(fontSize: 18.0, color: AppColor.textColor)),
                              ),
                            ),
                            onTap: () async {
                              if (await Internet.checkConnection()) {
                                if (currentUser.isLoggedIn) {
                                  if (currentUser.cartModel.productsPrice < currentUser.cartModel.storeData.meta.minOrderPrice) {
                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        Future.delayed(Duration(seconds: 2), () {
                                          Navigator.of(context).pop(true);
                                        });
                                        return CupertinoAlertDialog(
                                          content: Text('Минимальная сумма заказа - ${currentUser.cartModel.storeData.meta.minOrderPrice}${String.fromCharCode(0x00A0)}\₽', style: TextStyle(fontSize: 14),),
                                        );
                                      },
                                    );
                                  } else if (selectedPageId == 0) {
                                    Navigator.of(context).push(
                                      PageRouteBuilder(
                                        pageBuilder: (context, animation, anotherAnimation) {
                                          return AddressScreen(restaurant: restaurant, isTakeAwayOrderConfirmation: false);
                                        },
                                        transitionDuration: Duration(milliseconds: 300),
                                        transitionsBuilder: (context, animation, anotherAnimation, child) {
                                          return SlideTransition(
                                            position: Tween(begin: Offset(-1.0, 0.0), end: Offset(0.0, 0.0)).animate(animation),
                                            child: child,
                                          );
                                        },
                                      ),
                                    );
                                    AmplitudeAnalytics.analytics.logEvent('checkout');
                                  } else {
                                    Navigator.of(context).push(PageRouteBuilder(
                                        pageBuilder: (context, animation, anotherAnimation) {
                                          return AddressScreen(restaurant: restaurant, isTakeAwayOrderConfirmation: true);
                                        },
                                        transitionDuration: Duration(milliseconds: 300),
                                        transitionsBuilder: (context, animation, anotherAnimation, child) {
                                          return SlideTransition(
                                            position: Tween(begin: Offset(-1.0, 0.0), end: Offset(0.0, 0.0)).animate(animation),
                                            child: child,
                                          );
                                        }));
                                    AmplitudeAnalytics.analytics.logEvent('checkout');
                                  }
                                } else {
                                  Navigator.push(
                                    context,
                                    new MaterialPageRoute(
                                      builder: (context) => BlocProvider(
                                        create: (context) => AuthGetBloc(),
                                        child: AuthScreen(source: AuthSources.Cart),
                                      ),
                                    ),
                                  );
                                }
                              } else {
                                noConnection(context);
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        onWillPop: () async {
          if (source == CartSources.Home) {
            homeScreenKey = new GlobalKey<HomeScreenState>();
            Navigator.pushReplacement(
                context,
                new MaterialPageRoute(
                    builder: (context) => BlocProvider(
                      create: (context) => RestaurantGetBloc(),
                      child: new HomeScreen(),
                    )));
          } else if (source == CartSources.Restaurant) {
            Navigator.pushReplacement(context, new MaterialPageRoute(builder: (context) => RestaurantScreen(restaurant: restaurant)));
          }
          return false;
        },
      ),
    );
  }
}

enum CartSources { Home, Restaurant, Other }
