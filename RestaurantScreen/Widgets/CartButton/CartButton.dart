import 'package:flutter/material.dart';
import 'package:flutter_app/Amplitude/amplitude.dart';
import 'package:flutter_app/Internet/check_internet.dart';
import 'package:flutter_app/Screens/CartScreen/View/cart_page_view.dart';
import 'package:flutter_app/Screens/CartScreen/View/empty_cart_screen.dart';
import 'package:flutter_app/Screens/HomeScreen/Model/FilteredStores.dart';
import 'package:flutter_app/Screens/RestaurantScreen/View/restaurant_screen.dart';
import 'package:flutter_app/data/data.dart';
import 'package:flutter_app/data/globalVariables.dart';
import 'package:tap_debouncer/tap_debouncer.dart';

import 'CartButtonCounter.dart';

class CartButton extends StatefulWidget {
  final FilteredStores restaurant;
  CartSources source;

  CartButton({Key key, this.restaurant, this.source}) : super(key: key);

  @override
  CartButtonState createState() {
    return new CartButtonState(restaurant, source);
  }
}

class CartButtonState extends State<CartButton> {
  GlobalKey<CartButtonCounterState> buttonCounterKey;
  final FilteredStores restaurant;
  CartSources source;

  CartButtonState(this.restaurant, this.source);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    buttonCounterKey = new GlobalKey();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    // if (currentUser.cartModel.cart != null &&
    //     (currentUser.cartModel.cart.length == 0 ||
    //         currentUser.cartModel.cart[0].restaurant.uuid !=
    //             restaurant.uuid)) {
    //   return Container();
    // }
    if(currentUser.cartModel == null ||
        currentUser.cartModel.items == null ||
          currentUser.cartModel.items.length < 1){
      return Container();
    }else{
      return Container(
        width: MediaQuery.of(context).size.width,
        height: 82,
        decoration: BoxDecoration(
          color: AppColor.themeColor,
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 4.0, // soften the shadow
              spreadRadius: 1.0, //extend the shadow
            )
          ],
        ),
        child: Column(
          children: [
            // Padding(
            //   padding: const EdgeInsets.only(top: 15, bottom: 5),
            //   child: Center(
            //     child: Text('До бесплатной доставки осталось 250\₽',
            //       style: TextStyle(
            //           fontSize: 12
            //       ),
            //     ),
            //   ),
            // ),
            Padding(
              padding: EdgeInsets.only(left: 15, right: 15, bottom: 15, top: 15),
              child: Stack(
                children: [
                  Container(
                    padding: EdgeInsets.only(left: 15, top: 15, right: 15, bottom: 15),
                    width: MediaQuery.of(context).size.width,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        // Text(
                        //   (currentUser.cartModel.cookingTime != null)? '~ ${currentUser.cartModel.cookingTime ~/ 60} мин' : '',
                        //   style: TextStyle(
                        //     fontSize: 12.0,
                        //     color: AppColor.textColor,
                        //   ),
                        // ),
                        Text('Корзина',
                            style: TextStyle(
                                fontSize: 18.0,
                                color: AppColor.textColor)),
                        CartButtonCounter(
                          key: buttonCounterKey,
                        ),
                      ],
                    ),
                    decoration: BoxDecoration(
                      color: AppColor.mainColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  Material(
                    type: MaterialType.transparency,
                    child: TapDebouncer(
                      cooldown: const Duration(seconds: 5),
                        onTap: () async {
                          if (await Internet.checkConnection()) {
                            if (currentUser.cartModel.items.length == 0) {
                              Navigator.of(context).push(PageRouteBuilder(
                                  pageBuilder:
                                      (context, animation, anotherAnimation) {
                                    return EmptyCartScreen(
                                        restaurant: restaurant, source: source);
                                  },
                                  transitionDuration:
                                      Duration(milliseconds: 300),
                                  transitionsBuilder: (context, animation,
                                      anotherAnimation, child) {
                                    return SlideTransition(
                                      position: Tween(
                                              begin: Offset(-1.0, 0.0),
                                              end: Offset(0.0, 0.0))
                                          .animate(animation),
                                      child: child,
                                    );
                                  }));
                            } else {
                              AmplitudeAnalytics.analytics.logEvent('open_cart');
                              Navigator.of(context).push(PageRouteBuilder(
                                  pageBuilder:
                                      (context, animation, anotherAnimation) {
                                    return CartPageScreen(
                                        restaurant: restaurant, source: source);
                                  },
                                  transitionDuration:
                                      Duration(milliseconds: 300),
                                  transitionsBuilder: (context, animation,
                                      anotherAnimation, child) {
                                    return SlideTransition(
                                      position: Tween(
                                              begin: Offset(-1.0, 0.0),
                                              end: Offset(0.0, 0.0))
                                          .animate(animation),
                                      child: child,
                                    );
                                  }));
                            }
                          } else {
                            noConnection(context);
                          }
                        },
                        builder: (BuildContext context, TapDebouncerFunc onTap) {
                        return InkWell(
                          splashColor: AppColor.unselectedBorderFieldColor.withOpacity(0.5),
                          child: Container(
                            height: 52,
                          ),
                          onTap: onTap,
                        );
                      }
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }
  }

  void refresh() {
    setState(() {});
  }
}